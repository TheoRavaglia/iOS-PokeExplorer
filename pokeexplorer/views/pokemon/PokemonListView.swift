import SwiftUI

struct PokemonListView: View {
    @StateObject var viewModel = PokemonListViewModel()
    @EnvironmentObject var authManager: AuthManager
    
    private let gridColumns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                searchField
                pokemonGrid
            }
            .navigationTitle("Pokédex")
            .toolbar { toolbarContent }
            .overlay(alignment: .center) { loadingIndicator }
            .alert("Error", isPresented: Binding<Bool>(
                get: { viewModel.error != nil },
                set: { _ in viewModel.error = nil }
            )) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.error ?? "Unknown error")
            }
        }
    }
    
    // MARK: - Subviews
    
    private var searchField: some View {
        TextField("Search Pokémon", text: $viewModel.searchText)
            .padding(.horizontal)
            .textFieldStyle(.roundedBorder)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .padding(.horizontal)
    }
    
    private var pokemonGrid: some View {
        ScrollView {
            LazyVGrid(columns: gridColumns, spacing: 16) {
                ForEach(viewModel.filteredPokemons) { pokemon in
                    NavigationLink(destination: PokemonDetailView(pokemon: pokemon)) {
                        PokemonGridCell(pokemon: pokemon)
                    }
                    .buttonStyle(PlainButtonStyle()) // Remove o efeito de botão padrão
                    .onAppear {
                        if viewModel.filteredPokemons.last?.id == pokemon.id {
                            viewModel.fetchPokemons()
                        }
                    }
                }
            }
            .padding()
        }
        .refreshable {
            viewModel.refresh()
        }
    }
    
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            NavigationLink(destination: ProfileView()) {
                Image(systemName: "person.circle")
            }
        }
    }
    
    private var loadingIndicator: some View {
        Group {
            if viewModel.isLoading && viewModel.pokemons.isEmpty {
                ProgressView()
                    .scaleEffect(1.5)
            }
        }
    }
}

// MARK: - PokemonGridCell
struct PokemonGridCell: View {
    let pokemon: Pokemon
    
    var body: some View {
        VStack(spacing: 8) {
            AsyncImage(url: pokemon.imageUrl) { phase in
                switch phase {
                case .success(let image):
                    image.resizable()
                        .scaledToFit()
                        .transition(.opacity.combined(with: .scale))
                case .failure:
                    Image(systemName: "questionmark.circle")
                        .font(.largeTitle)
                default:
                    ProgressView()
                }
            }
            .frame(width: 100, height: 100)
            
            Text(pokemon.name.capitalized)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            
            if let id = pokemon.pokemonId {
                Text("#\(String(format: "%03d", id))")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(radius: 3)
        .contentShape(Rectangle())
    }
}
