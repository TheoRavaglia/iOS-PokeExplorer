import SwiftUI

enum DesignSystem {
    // MARK: - Colors
    enum Colors {
        static let primary = Color(hex: "#EF5350") // Vermelho Pokémon
        static let secondary = Color(hex: "#42A5F5") // Azul Pokémon
        static let background = Color(hex: "#F5F5F5")
        static let cardBackground = Color.white
        static let textPrimary = Color(hex: "#212121")
        static let textSecondary = Color(hex: "#757575")
        static let error = Color(hex: "#D32F2F")
        static let success = Color(hex: "#388E3C")
        
        // Pokémon Types
        static let bug = Color(hex: "#A8B820")
        static let dark = Color(hex: "#705848")
        static let dragon = Color(hex: "#7038F8")
        static let electric = Color(hex: "#F8D030")
        static let fairy = Color(hex: "#EE99AC")
        static let fighting = Color(hex: "#C03028")
        static let fire = Color(hex: "#F08030")
        static let flying = Color(hex: "#A890F0")
        static let ghost = Color(hex: "#705898")
        static let grass = Color(hex: "#78C850")
        static let ground = Color(hex: "#E0C068")
        static let ice = Color(hex: "#98D8D8")
        static let normal = Color(hex: "#A8A878")
        static let poison = Color(hex: "#A040A0")
        static let psychic = Color(hex: "#F85888")
        static let rock = Color(hex: "#B8A038")
        static let steel = Color(hex: "#B8B8D0")
        static let water = Color(hex: "#6890F0")
        
        static func typeColor(_ type: String) -> Color {
            switch type.lowercased() {
            case "bug": return bug
            case "dark": return dark
            case "dragon": return dragon
            case "electric": return electric
            case "fairy": return fairy
            case "fighting": return fighting
            case "fire": return fire
            case "flying": return flying
            case "ghost": return ghost
            case "grass": return grass
            case "ground": return ground
            case "ice": return ice
            case "normal": return normal
            case "poison": return poison
            case "psychic": return psychic
            case "rock": return rock
            case "steel": return steel
            case "water": return water
            default: return primary
            }
        }
    }
    
    // MARK: - Fonts
    enum Fonts {
        static let largeTitle = Font.system(size: 34, weight: .bold)
        static let title = Font.system(size: 28, weight: .bold)
        static let title2 = Font.system(size: 22, weight: .bold)
        static let headline = Font.system(size: 18, weight: .semibold)
        static let body = Font.system(size: 16, weight: .regular)
        static let callout = Font.system(size: 14, weight: .regular)
        static let caption = Font.system(size: 12, weight: .medium)
        
        static func customFont(size: CGFloat, weight: Font.Weight) -> Font {
            Font.system(size: size, weight: weight)
        }
    }
    
    // MARK: - Spacing
    enum Spacing {
        static let xxs: CGFloat = 2
        static let xs: CGFloat = 4
        static let s: CGFloat = 8
        static let m: CGFloat = 16
        static let l: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }
    
    // MARK: - Corner Radius
    enum CornerRadius {
        static let small: CGFloat = 4
        static let medium: CGFloat = 8
        static let large: CGFloat = 16
        static let xlarge: CGFloat = 24
        static let circle: CGFloat = .infinity
    }
    
    // MARK: - Shadows
    enum Shadows {
        static let small = Shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        static let medium = Shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
        static let large = Shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Icons
    enum Icons {
        static let pokeball = "pokeball"
        static let favorite = "heart.fill"
        static let favoriteOutline = "heart"
        static let search = "magnifyingglass"
        static let back = "arrow.left"
        static let close = "xmark"
        static let stats = "chart.bar"
        static let moves = "bolt.fill"
        static let abilities = "sparkles"
    }
    
    // MARK: - Animations
    enum Animations {
        static let defaultDuration: Double = 0.3
        static let fast: Double = 0.15
        static let medium: Double = 0.5
        static let slow: Double = 1.0
        
        static func pulsate(duration: Double = 1.5) -> Animation {
            Animation.easeInOut(duration: duration).repeatForever(autoreverses: true)
        }
    }
}

// MARK: - Extensões de Suporte
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension View {
    func applyCardStyle() -> some View {
        self
            .background(DesignSystem.Colors.cardBackground)
            .cornerRadius(DesignSystem.CornerRadius.large)
            .shadow(color: DesignSystem.Colors.textSecondary.opacity(0.1), radius: 6, x: 0, y: 2)
    }
    
    func typeBackground(_ type: String) -> some View {
        self.background(DesignSystem.Colors.typeColor(type).opacity(0.2))
    }
}
