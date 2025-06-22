import SwiftUI
import SwiftData

// MODIFICAÇÃO: Lógica da animação de clique, adicionada diretamente neste arquivo.
struct BounceOnClickStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

struct PokemonListView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var authManager: AuthManager
    
    @StateObject var viewModel = PokemonListViewModel()
    
    // MODIFICAÇÃO: Namespace para conectar a animação entre as telas.
    @Namespace private var animation
    
    private let gridColumns = [ // Renomeei para corresponder ao uso abaixo
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
                    // MODIFICAÇÃO: Passando o namespace para a DetailView.
                    NavigationLink(destination: PokemonDetailView(pokemon: pokemon, modelContext: modelContext, authManager: authManager, namespace: animation)) {
                        // MODIFICAÇÃO: Passando o namespace para a célula do grid.
                        PokemonGridCell(pokemon: pokemon, namespace: animation)
                    }
                    // MODIFICAÇÃO: Trocando o PlainButtonStyle pelo nosso estilo de animação.
                    .buttonStyle(BounceOnClickStyle())
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
    // MODIFICAÇÃO: A célula agora aceita o namespace para identificar a imagem.
    var namespace: Namespace.ID
    
    var body: some View {
        VStack(spacing: 8) {
            AsyncImage(url: pokemon.imageUrl) { phase in
                switch phase {
                case .success(let image):
                    image.resizable()
                        .scaledToFit()
                        // MODIFICAÇÃO: Identifica a imagem para a animação.
                        .matchedGeometryEffect(id: "sprite\(pokemon.id)", in: namespace)
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
