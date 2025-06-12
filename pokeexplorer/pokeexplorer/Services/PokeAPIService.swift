import Foundation

class PokeAPIService {
    static let shared = PokeAPIService()
    private let baseURL = "https://pokeapi.co/api/v2/"
    
    func fetchPokemonList(limit: Int = 20, completion: @escaping (Result<[PokemonListItem], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)pokemon?limit=\(limit)") else {
            completion(.failure(NSError(domain: "URL inválida", code: 0)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "Dados inválidos", code: 1)))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(PokemonListResponse.self, from: data)
                completion(.success(response.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

// Modelos de suporte
struct PokemonListResponse: Codable {
    let results: [PokemonListItem]
}

struct PokemonListItem: Codable, Identifiable {
    let name: String
    let url: String
    var id: Int? {
        guard let pokemonID = URL(string: url)?.lastPathComponent else { return nil }
        return Int(pokemonID)
    }
}
