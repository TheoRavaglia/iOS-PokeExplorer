import SwiftUI

extension View {
    func animateOnAppear(delay: Double = 0, duration: Double = 0.5) -> some View {
        self.modifier(AnimateOnAppearModifier(delay: delay, duration: duration))
    }
    
    func bounceOnAppear(delay: Double = 0) -> some View {
        self.modifier(BounceOnAppearModifier(delay: delay))
    }
    
    func pulseAnimation() -> some View {
        self.modifier(PulseAnimationModifier())
    }
}

struct AnimateOnAppearModifier: ViewModifier {
    let delay: Double
    let duration: Double
    @State private var isVisible = false
    
    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 20)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: duration)
                    .delay(delay)
                ) {
                    isVisible = true
                }
            }
    }
}

struct BounceOnAppearModifier: ViewModifier {
    let delay: Double
    @State private var scale: CGFloat = 0.8
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .onAppear {
                withAnimation(
                    .interpolatingSpring(stiffness: 300, damping: 10)
                    .delay(delay)
                ) {
                    scale = 1
                }
            }
    }
}

struct PulseAnimationModifier: ViewModifier {
    @State private var animate = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(animate ? 1.05 : 1)
            .animation(
                Animation.easeInOut(duration: 1)
                    .repeatForever(autoreverses: true),
                value: animate
            )
            .onAppear { animate = true }
    }
}
