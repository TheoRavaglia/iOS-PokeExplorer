import SwiftUI
import SwiftData

// ButtonStyle (sem alterações)
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
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    @StateObject var viewModel = PokemonListViewModel()
    
    @Namespace private var animation
    
    // --- INÍCIO DA MODIFICAÇÃO ---
    // A propriedade `gridColumns` agora tem uma lógica para cada tipo de tela.
    private var gridColumns: [GridItem] {
        if horizontalSizeClass == .compact {
            // Para telas compactas (iPhones), usamos 2 colunas flexíveis.
            // Isso garante que sempre haverá exatamente duas colunas.
            return [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ]
        } else {
            // Para telas regulares (iPads), usamos a grade adaptativa.
            // Ela cria quantas colunas couberem, com um tamanho mínimo de 160.
            return [
                GridItem(.adaptive(minimum: 160), spacing: 16)
            ]
        }
    }
    // --- FIM DA MODIFICAÇÃO ---
    
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
    
    // MARK: - Subviews (sem alterações)
    
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
                    NavigationLink(destination: PokemonDetailView(pokemon: pokemon, modelContext: modelContext, authManager: authManager, namespace: animation)) {
                        PokemonGridCell(pokemon: pokemon, namespace: animation)
                    }
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

// MARK: - PokemonGridCell (sem alterações)
struct PokemonGridCell: View {
    let pokemon: Pokemon
    var namespace: Namespace.ID
    
    var body: some View {
        VStack(spacing: 8) {
            AsyncImage(url: pokemon.imageUrl) { phase in
                switch phase {
                case .success(let image):
                    image.resizable()
                        .scaledToFit()
                        .matchedGeometryEffect(id: "sprite\(pokemon.id)", in: namespace)
                        .transition(.opacity.combined(with: .scale))
                case .failure:
                    Image(systemName: "questionmark.circle").font(.largeTitle)
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
