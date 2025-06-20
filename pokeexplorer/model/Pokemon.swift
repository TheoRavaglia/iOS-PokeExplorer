
import Foundation

struct PokemonListResponse: Codable {
    let results: [Pokemon]
}

struct Pokemon: Codable, Identifiable, Equatable {
    let id = UUID()
    let name: String
    let url: String
    
    var pokemonId: Int? {
        Int(url.split(separator: "/").last?.description ?? "")
    }
    
    var imageUrl: URL? {
        guard let id = pokemonId else { return nil }
        return URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png")
    }
    
    // Exemplo para testes
    static let sample = [
        Pokemon(name: "pikachu", url: "https://pokeapi.co/api/v2/pokemon/25/"),
        Pokemon(name: "charmander", url: "https://pokeapi.co/api/v2/pokemon/4/"),
        Pokemon(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"),
        Pokemon(name: "squirtle", url: "https://pokeapi.co/api/v2/pokemon/7/")
    ]
}
