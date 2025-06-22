import SwiftUI
import SwiftData

@main
struct PokeExplorerApp: App {
    @StateObject private var authManager = AuthManager() // Sua classe de autenticação
    
    var body: some Scene {
        WindowGroup {
            if authManager.isAuthenticated {
                PokemonListView()
                    .environmentObject(authManager)
            } else {
                LoginView()
                    .environmentObject(authManager)
            }
        }
    }
}
