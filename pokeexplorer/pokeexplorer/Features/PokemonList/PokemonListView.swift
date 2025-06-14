import SwiftUI

struct PokemonListView: View {
    @StateObject private var viewModel = PokemonListViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.pokemonList) { pokemon in
                NavigationLink(destination: Text("Detalhes de \(pokemon.name)")) {
                    Text(pokemon.name.capitalized)
                }
            }
            .navigationTitle("Pokédex")
            .onAppear {
                viewModel.fetchPokemonList()
            }
        }
    }
}

class PokemonListViewModel: ObservableObject {
    @Published var pokemonList: [PokemonListItem] = []
    
    func fetchPokemonList() {
        PokeAPIService.shared.fetchPokemonList { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let list):
                    self.pokemonList = list
                case .failure(let error):
                    print("Erro ao buscar Pokémon: \(error)")
                }
            }
        }
    }
}
