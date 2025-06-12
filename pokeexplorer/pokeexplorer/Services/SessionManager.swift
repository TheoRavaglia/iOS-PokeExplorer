import SwiftUI
import CoreData

class SessionManager: ObservableObject {
    @Published var isLoggedIn = false
    @Published var currentUser: Usuario?
    
    func login(email: String, password: String, context: NSManagedObjectContext) -> Bool {
        let request: NSFetchRequest<Usuario> = Usuario.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@ AND senha == %@", email, password)
        
        do {
            let users = try context.fetch(request)
            if let user = users.first {
                currentUser = user
                isLoggedIn = true
                return true
            }
            return false
        } catch {
            print("Erro no login: \(error)")
            return false
        }
    }
    
    func logout() {
        currentUser = nil
        isLoggedIn = false
    }
}
