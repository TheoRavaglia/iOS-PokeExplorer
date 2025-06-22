import SwiftUI
import SwiftData

@main
struct PokeExplorerApp: App {
    @StateObject private var authManager = AuthManager()
    
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
        .modelContainer(for: [FavoritePokemon.self]) 
    }
}
