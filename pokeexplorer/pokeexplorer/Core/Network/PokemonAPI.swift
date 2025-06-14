import Foundation

struct PokemonAPI {
    private static let baseURL = "https://pokeapi.co/api/v2"
    
    // MARK: - Endpoints
    static func pokemonList(limit: Int = 20, offset: Int = 0) -> String {
        "\(baseURL)/pokemon?limit=\(limit)&offset=\(offset)"
    }
    
    static func pokemonDetail(id: Int) -> String {
        "\(baseURL)/pokemon/\(id)"
    }
    
    static func pokemonSpecies(id: Int) -> String {
        "\(baseURL)/pokemon-species/\(id)"
    }
    
    static func ability(id: Int) -> String {
        "\(baseURL)/ability/\(id)"
    }
    
    static func move(id: Int) -> String {
        "\(baseURL)/move/\(id)"
    }
    
    static func type(id: Int) -> String {
        "\(baseURL)/type/\(id)"
    }
    
    // MARK: - Fetch Methods
    static func fetchPokemonList(limit: Int = 20, offset: Int = 0) async throws -> [PokemonListItem] {
        let endpoint = pokemonList(limit: limit, offset: offset)
        let response: PaginatedResponse<PokemonListItem> = try await APIService.shared.request(endpoint)
        return response.results
    }
    
    static func fetchPokemonDetail(id: Int) async throws -> Pokemon {
        let endpoint = pokemonDetail(id: id)
        return try await APIService.shared.request(endpoint)
    }
    
    static func fetchPokemonSpecies(id: Int) async throws -> PokemonSpecies {
        let endpoint = pokemonSpecies(id: id)
        return try await APIService.shared.request(endpoint)
    }
    
    static func fetchAbility(id: Int) async throws -> Ability {
        let endpoint = ability(id: id)
        return try await APIService.shared.request(endpoint)
    }
    
    static func fetchMove(id: Int) async throws -> Move {
        let endpoint = move(id: id)
        return try await APIService.shared.request(endpoint)
    }
    
    static func fetchType(id: Int) async throws -> PokeType {
        let endpoint = type(id: id)
        return try await APIService.shared.request(endpoint)
    }
    
    // MARK: - Data Models
    struct PokemonListItem: Codable, Identifiable {
        let name: String
        let url: String
        
        var id: Int? {
            guard let idString = url.split(separator: "/").last else { return nil }
            return Int(idString)
        }
    }
}
