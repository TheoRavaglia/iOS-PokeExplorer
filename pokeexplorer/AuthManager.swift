import Foundation

class AuthManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    
    struct User {
        let email: String
        let name: String
    }
    
    func login(email: String, name: String) {
        currentUser = User(email: email, name: name)
        isAuthenticated = true
        UserDefaults.standard.set(email, forKey: "userEmail")
        UserDefaults.standard.set(name, forKey: "userName")
    }
    
    func logout() {
        currentUser = nil
        isAuthenticated = false
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.removeObject(forKey: "userName")
    }
    
    func checkAuthentication() {
        if let email = UserDefaults.standard.string(forKey: "userEmail"),
           let name = UserDefaults.standard.string(forKey: "userName") {
            login(email: email, name: name)
        }
    }
}
