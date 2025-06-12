import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            PokemonListView()
                .tabItem {
                    Label("Pokédex", systemImage: "list.bullet")
                }
            
            FavoritesView()
                .tabItem {
                    Label("Favoritos", systemImage: "star")
                }
            
            ProfileView()
                .tabItem {
                    Label("Perfil", systemImage: "person")
                }
        }
    }
}
