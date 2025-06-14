import Foundation

class PaginationManager<T> {
    private(set) var items: [T] = []
    private var currentPage = 0
    private var isLoading = false
    private var hasMore = true
    private let pageSize: Int
    
    typealias FetchHandler = (Int, Int) async throws -> [T]
    private let fetchHandler: FetchHandler
    
    init(pageSize: Int = 20, fetchHandler: @escaping FetchHandler) {
        self.pageSize = pageSize
        self.fetchHandler = fetchHandler
    }
    
    func loadFirstPage() async throws {
        reset()
        try await loadMore()
    }
    
    func loadMore() async throws {
        guard !isLoading && hasMore else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        currentPage += 1
        let newItems = try await fetchHandler(currentPage, pageSize)
        
        if newItems.count < pageSize {
            hasMore = false
        }
        
        items.append(contentsOf: newItems)
    }
    
    func reset() {
        items = []
        currentPage = 0
        isLoading = false
        hasMore = true
    }
    
    var canLoadMore: Bool {
        hasMore && !isLoading
    }
}
