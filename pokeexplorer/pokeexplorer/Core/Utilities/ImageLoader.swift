import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private var url: URL?
    private var cancellable: AnyCancellable?
    private var cache: ImageCache?
    
    private static let imageProcessingQueue = DispatchQueue(label: "image-processing")
    
    init(url: URL?, cache: ImageCache? = nil) {
        self.url = url
        self.cache = cache
    }
    
    deinit {
        cancel()
    }
    
    func load() {
        guard let url = url else { return }
        
        if let image = cache?[url] {
            self.image = image
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: Self.imageProcessingQueue)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                if let image = $0 {
                    self.cache?[url] = image
                }
                self.image = $0
            }
    }
    
    func cancel() {
        cancellable?.cancel()
    }
}

protocol ImageCache {
    subscript(_ url: URL) -> UIImage? { get set }
}

struct TemporaryImageCache: ImageCache {
    private let cache = NSCache<NSURL, UIImage>()
    
    subscript(_ key: URL) -> UIImage? {
        get { cache.object(forKey: key as NSURL) }
        set { newValue == nil ? cache.removeObject(forKey: key as NSURL) : cache.setObject(newValue!, forKey: key as NSURL) }
    }
}

struct ImageCacheKey: EnvironmentKey {
    static let defaultValue: ImageCache = TemporaryImageCache()
}

extension EnvironmentValues {
    var imageCache: ImageCache {
        get { self[ImageCacheKey.self] }
        set { self[ImageCacheKey.self] = newValue }
    }
}

struct AsyncImage: View {
    @StateObject private var loader: ImageLoader
    private let placeholder: Image
    private let content: (Image) -> Image
    
    init(
        url: URL?,
        placeholder: Image = Image(systemName: "photo"),
        content: @escaping (Image) -> Image = { $0.resizable() }
    ) {
        _loader = StateObject(wrappedValue: ImageLoader(url: url, cache: nil))
        self.placeholder = placeholder
        self.content = content
    }
    
    var body: some View {
        Group {
            if let image = loader.image {
                content(Image(uiImage: image))
            } else {
                placeholder
                    .onAppear(perform: loader.load)
            }
        }
        .onDisappear(perform: loader.cancel)
    }
}
