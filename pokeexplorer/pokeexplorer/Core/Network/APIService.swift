import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case statusCode(Int)
    case decodingError(Error)
    case networkError(Error)
}

final class APIService {
    static let shared = APIService()
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func request<T: Decodable>(
        _ endpoint: String,
        method: String = "GET",
        headers: [String: String] = [:],
        body: Data? = nil
    ) async throws -> T {
        guard let url = URL(string: endpoint) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        
        // Adiciona headers
        headers.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        // Adiciona header padrão para JSON
        if body != nil {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw APIError.statusCode(httpResponse.statusCode)
            }
            
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                throw APIError.decodingError(error)
            }
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    func paginatedRequest<T: Decodable>(
        _ endpoint: String,
        limit: Int = 20,
        offset: Int = 0
    ) async throws -> (results: [T], nextOffset: Int?) {
        let parameters = [
            "limit": "\(limit)",
            "offset": "\(offset)"
        ]
        
        guard var urlComponents = URLComponents(string: endpoint) else {
            throw APIError.invalidURL
        }
        
        urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0
