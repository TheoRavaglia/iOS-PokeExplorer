import Combine
import CoreData

class AppState: ObservableObject {
    @Published var isLoading: Bool = true
    @Published var isLoggedIn: Bool = false
    @Published var currentUser: CDUser?
    
    private let userRepository = UserRepository()
    private let favoriteRepository = FavoriteRepository()
    
    init() {
        checkLoginStatus()
    }
    
    func checkLoginStatus() {
        currentUser = userRepository.getCurrentUser()
        isLoggedIn = currentUser != nil
        isLoading = false
    }
    
    func login(email: String, password: String) -> Bool {
        if let user = userRepository.authenticateUser(email: email, password: password) {
            currentUser = user
            isLoggedIn = true
            return true
        }
        return false
    }
    
    func register(name: String, email: String, password: String) -> Bool {
        if let user = userRepository.createUser(name: name, email: email, password: password) {
            currentUser = user
            isLoggedIn = true
            return true
        }
        return false
    }
    
    func logout() {
        currentUser = nil
        isLoggedIn = false
    }
    
    func toggleFavorite(pokemon: Pokemon) {
        guard let user = currentUser else { return }
        favoriteRepository.toggleFavorite(user: user, pokemonId: pokemon.id)
    }
    
    func isFavorite(pokemon: Pokemon) -> Bool {
        guard let user = currentUser else { return false }
        return favoriteRepository.isFavorite(user: user, pokemonId: pokemon.id)
    }
    
    func getFavorites() -> [CDFavorite] {
        guard let user = currentUser else { return [] }
        return favoriteRepository.getFavorites(for: user)
    }
}
