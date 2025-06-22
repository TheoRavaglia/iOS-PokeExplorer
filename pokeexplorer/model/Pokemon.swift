import Foundation

struct Pokemon: Identifiable, Equatable, Codable {
    let id: UUID // This will be generated locally
    let name: String
    let url: String
    
    // Add a new struct for decoding the raw data from the API
    private enum CodingKeys: String, CodingKey {
        case name, url
    }
    
    // Custom initializer for decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.url = try container.decode(String.self, forKey: .url)
        self.id = UUID() // Generate a new UUID for the Identifiable protocol
    }
    
    // Keep your existing initializer for manual creation if needed
    init(id: UUID = UUID(), name: String, url: String) {
        self.id = id
        self.name = name
        self.url = url
    }
    
    var pokemonId: Int? {
        Int(url.split(separator: "/").last?.description ?? "")
    }
    
    var imageUrl: URL? {
        guard let id = pokemonId else { return nil }
        return URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png")
    }
}
