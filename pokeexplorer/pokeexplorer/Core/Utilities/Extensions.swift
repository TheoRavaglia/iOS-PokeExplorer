import SwiftUI

// MARK: - View Extensions
extension View {
    func loadingOverlay(isLoading: Bool) -> some View {
        self.overlay {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
                    .padding(DesignSystem.Spacing.l)
                    .background(DesignSystem.Colors.background.opacity(0.8))
                    .cornerRadius(DesignSystem.CornerRadius.medium)
            }
        }
    }
    
    func errorAlert(errorMessage: Binding<String?>) -> some View {
        self.alert(isPresented: .constant(errorMessage.wrappedValue != nil)) {
            Alert(
                title: Text("Erro"),
                message: Text(errorMessage.wrappedValue ?? ""),
                dismissButton: .default(Text("OK")) {
                    errorMessage.wrappedValue = nil
                }
            )
        }
    }
    
    func pokemonTypeBadge(_ type: String) -> some View {
        Text(type.capitalized)
            .font(DesignSystem.Fonts.caption)
            .padding(.horizontal, DesignSystem.Spacing.s)
            .padding(.vertical, DesignSystem.Spacing.xxs)
            .background(DesignSystem.Colors.typeColor(type))
            .foregroundColor(.white)
            .cornerRadius(DesignSystem.CornerRadius.circle)
    }
    
    func shimmering() -> some View {
        self.modifier(ShimmerEffect())
    }
}

struct ShimmerEffect: ViewModifier {
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                ShimmerView(phase: phase)
                    .mask(content)
            )
            .onAppear {
                withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}

struct ShimmerView: View {
    var phase: CGFloat
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.white.opacity(0.3),
                Color.white,
                Color.white.opacity(0.3)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .scaleEffect(2)
        .rotationEffect(.degrees(70))
        .offset(x: phase * 200 - 100)
    }
}

// MARK: - String Extensions
extension String {
    func capitalizingFirstLetter() -> String {
        prefix(1).capitalized + dropFirst()
    }
    
    func formattedPokemonId() -> String {
        "#\(String(format: "%03d", Int(self) ?? 0))"
    }
}

// MARK: - Int Extensions
extension Int {
    func formattedStat() -> String {
        String(format: "%03d", self)
    }
    
    func toHeightString() -> String {
        let heightInMeters = Double(self) / 10.0
        return String(format: "%.1f m", heightInMeters)
    }
    
    func toWeightString() -> String {
        let weightInKg = Double(self) / 10.0
        return String(format: "%.1f kg", weightInKg)
    }
}

// MARK: - Array Extensions
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

// MARK: - Binding Extensions
extension Binding {
    func toUnwrapped<T>(defaultValue: T) -> Binding<T> where Value == T? {
        Binding<T>(
            get: { self.wrappedValue ?? defaultValue },
            set: { self.wrappedValue = $0 }
        )
    }
}
