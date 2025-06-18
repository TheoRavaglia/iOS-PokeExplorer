import SwiftUI
import Combine

struct ImageCache {
    private static var cache = NSCache<NSString, ImageContainer>()
    
    static func get(forKey key: String) -> Image? {
        return cache.object(forKey: key as NSString)?.image
    }
    
    static func set(_ image: Image, forKey key: String) {
        cache.setObject(ImageContainer(image: image), forKey: key as NSString)
    }
    
    private final class ImageContainer {
        let image: Image
        
        init(image: Image) {
            self.image = image
        }
    }
}

class ImageLoader: ObservableObject {
    @Published var image: Image?
    private var url: URL?
    private var cancellable: AnyCancellable?
    
    init(url: URL?) {
        self.url = url
    }
    
    deinit {
        cancel()
    }
    
    func load() {
        guard let url = url else { return }
        let cacheKey = url.absoluteString
        
        // Verificar cache
        if let cachedImage = ImageCache.get(forKey: cacheKey) {
            self.image = cachedImage
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { data, _ -> Image? in
                #if os(macOS)
                guard let nsImage = NSImage(data: data) else { return nil }
                return Image(nsImage: nsImage)
                #else
                guard let uiImage = UIImage(data: data) else { return nil }
                return Image(uiImage: uiImage)
                #endif
            }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loadedImage in
                guard let self = self, let loadedImage = loadedImage else { return }
                
                // Atualizar cache
                ImageCache.set(loadedImage, forKey: cacheKey)
                
                self.image = loadedImage
            }
    }
    
    func cancel() {
        cancellable?.cancel()
    }
}

struct AsyncImage: View {
    @StateObject private var loader: ImageLoader
    private let placeholder: Image
    
    init(
        url: URL?,
        placeholder: Image = Image(systemName: "photo")
    ) {
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
        self.placeholder = placeholder
    }
    
    var body: some View {
        Group {
            if let image = loader.image {
                image
                    .resizable()
                    .scaledToFit()
            } else {
                placeholder
                    .onAppear(perform: loader.load)
            }
        }
        .onDisappear(perform: loader.cancel)
    }
}
