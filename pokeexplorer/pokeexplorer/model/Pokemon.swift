import Foundation

struct Pokemon: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let sprites: Sprites
    let types: [PokemonType]
    let abilities: [PokemonAbility]
    let stats: [PokemonStat]
    let moves: [PokemonMove]
    
    var primaryType: String? {
        types.first?.type.name.capitalized
    }
    
    var imageURL: URL? {
        URL(string: sprites.other?.officialArtwork.frontDefault ?? "")
    }
    
    static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
        lhs.id == rhs.id
    }
    
    struct Sprites: Codable {
        let frontDefault: String?
        let other: Other?
        
        struct Other: Codable {
            let officialArtwork: OfficialArtwork
            
            struct OfficialArtwork: Codable {
                let frontDefault: String?
                
                enum CodingKeys: String, CodingKey {
                    case frontDefault = "front_default"
                }
            }
            
            enum CodingKeys: String, CodingKey {
                case officialArtwork = "official-artwork"
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case frontDefault = "front_default"
            case other
        }
    }
    
    struct PokemonType: Codable {
        let slot: Int
        let type: NamedAPIResource
    }
    
    struct PokemonAbility: Codable {
        let ability: NamedAPIResource
        let isHidden: Bool
        let slot: Int
        
        enum CodingKeys: String, CodingKey {
            case ability
            case isHidden = "is_hidden"
            case slot
        }
    }
    
    struct PokemonStat: Codable {
        let baseStat: Int
        let effort: Int
        let stat: NamedAPIResource
        
        enum CodingKeys: String, CodingKey {
            case baseStat = "base_stat"
            case effort
            case stat
        }
    }
    
    struct PokemonMove: Codable {
        let move: NamedAPIResource
        let versionGroupDetails: [MoveVersionGroupDetail]
        
        enum CodingKeys: String, CodingKey {
            case move
            case versionGroupDetails = "version_group_details"
        }
    }
    
    struct MoveVersionGroupDetail: Codable {
        let levelLearnedAt: Int
        let moveLearnMethod: NamedAPIResource
        
        enum CodingKeys: String, CodingKey {
            case levelLearnedAt = "level_learned_at"
            case moveLearnMethod = "move_learn_method"
        }
    }
}

struct NamedAPIResource: Codable {
    let name: String
    let url: String
}

struct PokemonSpecies: Codable {
    let id: Int
    let name: String
    let flavorTextEntries: [FlavorTextEntry]
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case flavorTextEntries = "flavor_text_entries"
    }
    
    struct FlavorTextEntry: Codable {
        let flavorText: String
        let language: NamedAPIResource
        
        enum CodingKeys: String, CodingKey {
            case flavorText = "flavor_text"
            case language
        }
    }
}

struct Ability: Codable {
    let id: Int
    let name: String
    let effectEntries: [EffectEntry]
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case effectEntries = "effect_entries"
    }
    
    struct EffectEntry: Codable {
        let effect: String
        let language: NamedAPIResource
    }
}

struct Move: Codable {
    let id: Int
    let name: String
    let accuracy: Int?
    let power: Int?
    let pp: Int?
    let type: NamedAPIResource
}

struct PokeType: Codable {
    let id: Int
    let name: String
    let damageRelations: DamageRelations
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case damageRelations = "damage_relations"
    }
    
    struct DamageRelations: Codable {
        let doubleDamageFrom: [NamedAPIResource]
        let doubleDamageTo: [NamedAPIResource]
        let halfDamageFrom: [NamedAPIResource]
        let halfDamageTo: [NamedAPIResource]
        let noDamageFrom: [NamedAPIResource]
        let noDamageTo: [NamedAPIResource]
        
        enum CodingKeys: String, CodingKey {
            case doubleDamageFrom = "double_damage_from"
            case doubleDamageTo = "double_damage_to"
            case halfDamageFrom = "half_damage_from"
            case halfDamageTo = "half_damage_to"
            case noDamageFrom = "no_damage_from"
            case noDamageTo = "no_damage_to"
        }
    }
}
