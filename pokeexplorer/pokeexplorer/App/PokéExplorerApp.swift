import SwiftUI

@main
struct PokéExplorerApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var dataStore = DataStore()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if appState.isLoading {
                    LoadingView()	
                } else if appState.isLoggedIn {
                    PokemonListView()
                } else {
                    LoginView()
                }
            }
            .environmentObject(appState)
            .environmentObject(dataStore)
        }
    }
}
