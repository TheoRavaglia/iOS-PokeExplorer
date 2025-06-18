import SwiftUI

enum DesignSystem {
    // MARK: - Colors
    enum Colors {
        static let primary = Color(hex: "#EF5350")
        static let secondary = Color(hex: "#42A5F5")
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
        static let largeTitle = Font.largeTitle.bold()
        static let title = Font.title.bold()
        static let title2 = Font.title2.bold()
        static let headline = Font.headline
        static let body = Font.body
        static let callout = Font.callout
        static let caption = Font.caption
        
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
        static let small = (color: Color.black.opacity(0.1), radius: 2.0, x: 0.0, y: 1.0)
        static let medium = (color: Color.black.opacity(0.2), radius: 4.0, x: 0.0, y: 2.0)
        static let large = (color: Color.black.opacity(0.3), radius: 8.0, x: 0.0, y: 4.0)
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
    
    // MARK: - Gradients
    enum Gradients {
        static let primary = LinearGradient(
            gradient: Gradient(colors: [Colors.primary, Colors.secondary]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static func typeGradient(_ type: String) -> LinearGradient {
            let baseColor = Colors.typeColor(type)
            return LinearGradient(
                gradient: Gradient(colors: [baseColor, baseColor.opacity(0.7)]),
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
}

// MARK: - Extensão de Color para suporte a Hex
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        var rgbValue: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)
        
        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}

// MARK: - Modificadores de View
extension View {
    func applyCardStyle(cornerRadius: CGFloat = DesignSystem.CornerRadius.large) -> some View {
        self
            .background(DesignSystem.Colors.cardBackground)
            .cornerRadius(cornerRadius)
            .shadow(color: DesignSystem.Colors.textSecondary.opacity(0.1), radius: 6, x: 0, y: 2)
    }
    
    func typeBackground(_ type: String) -> some View {
        self.background(DesignSystem.Colors.typeColor(type).opacity(0.2))
    }
    
    func pokemonCardStyle(type: String) -> some View {
        self
            .padding(DesignSystem.Spacing.m)
            .background(DesignSystem.Gradients.typeGradient(type))
            .cornerRadius(DesignSystem.CornerRadius.large)
            .shadow(color: DesignSystem.Colors.typeColor(type).opacity(0.4), radius: 8, x: 0, y: 4)
    }
    
    func sectionHeader() -> some View {
        self
            .font(DesignSystem.Fonts.title2)
            .foregroundColor(DesignSystem.Colors.primary)
            .padding(.vertical, DesignSystem.Spacing.s)
    }
    
    // Modificadores para sombras
    func shadowSmall() -> some View {
        self.shadow(
            color: DesignSystem.Shadows.small.color,
            radius: DesignSystem.Shadows.small.radius,
            x: DesignSystem.Shadows.small.x,
            y: DesignSystem.Shadows.small.y
        )
    }
    
    func shadowMedium() -> some View {
        self.shadow(
            color: DesignSystem.Shadows.medium.color,
            radius: DesignSystem.Shadows.medium.radius,
            x: DesignSystem.Shadows.medium.x,
            y: DesignSystem.Shadows.medium.y
        )
    }
    
    func shadowLarge() -> some View {
        self.shadow(
            color: DesignSystem.Shadows.large.color,
            radius: DesignSystem.Shadows.large.radius,
            x: DesignSystem.Shadows.large.x,
            y: DesignSystem.Shadows.large.y
        )
    }
    
    // Modificador para aplicar qualquer sombra do sistema
    func applyShadow(_ style: (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat)) -> some View {
        self.shadow(color: style.color, radius: style.radius, x: style.x, y: style.y)
    }
}
