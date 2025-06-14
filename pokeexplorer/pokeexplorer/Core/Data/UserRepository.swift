import CoreData

class UserRepository {
    private let dataStore = DataStore.shared
    
    func createUser(name: String, email: String, password: String) -> CDUser? {
        let newUser = CDUser(context: dataStore.context)
        newUser.id = UUID()
        newUser.name = name
        newUser.email = email
        newUser.password = password
        
        do {
            try dataStore.context.save()
            return newUser
        } catch {
            print("Erro ao criar usuário: \(error)")
            return nil
        }
    }
    
    func authenticateUser(email: String, password: String) -> CDUser? {
        let request: NSFetchRequest<CDUser> = CDUser.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@ AND password == %@", email, password)
        
        do {
            let users = try dataStore.context.fetch(request)
            return users.first
        } catch {
            print("Erro ao autenticar usuário: \(error)")
            return nil
        }
    }
    
    func getCurrentUser() -> CDUser? {
        let request: NSFetchRequest<CDUser> = CDUser.fetchRequest()
        request.fetchLimit = 1
        
        do {
            let users = try dataStore.context.fetch(request)
            return users.first
        } catch {
            print("Erro ao obter usuário atual: \(error)")
            return nil
        }
    }
}
