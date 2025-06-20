import SwiftUI

struct PokemonListView: View {
    @StateObject var viewModel = PokemonListViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 16) {
                    ForEach(viewModel.pokemons) { pokemon in
                        PokemonGridCell(pokemon: pokemon)
                            .onAppear {
                                if pokemon == viewModel.pokemons.last {
                                    viewModel.fetchPokemons()
                                }
                            }
                    }
                }
                .padding()
            }
            .navigationTitle("Pokémons")
            .onAppear {
                if viewModel.pokemons.isEmpty {
                    viewModel.fetchPokemons()
                }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
                
                if let error = viewModel.error {
                    Text("Erro: \(error)")
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                }
            }
        }
    }
}

struct PokemonGridCell: View {
    let pokemon: Pokemon
    
    var body: some View {
        VStack {
            AsyncImage(url: pokemon.imageUrl) { phase in
                switch phase {
                case .success(let image):
                    image.resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                case .failure:
                    Image(systemName: "questionmark.circle")
                        .font(.largeTitle)
                default:
                    ProgressView()
                }
            }
            
            Text(pokemon.name.capitalized)
                .font(.headline)
            
            if let id = pokemon.pokemonId {
                Text("#\(String(format: "%03d", id))")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
