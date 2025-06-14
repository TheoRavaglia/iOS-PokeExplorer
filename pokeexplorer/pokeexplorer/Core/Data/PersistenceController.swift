import CoreData

class PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "PokéExplorerModel")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Erro não resolvido ao carregar Core Data: \(error), \(error.userInfo)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Erro não resolvido ao salvar Core Data: \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // MARK: - Operações de Usuário
    
    func criarUsuario(nome: String, email: String, senha: String, completion: @escaping (Bool, CDUser?) -> Void) {
        let newUser = CDUser(context: context)
        newUser.id = UUID()
        newUser.nome = nome
        newUser.email = email
        newUser.senha = senha
        
        do {
            try context.save()
            completion(true, newUser)
        } catch {
            print("Erro ao criar usuário: \(error)")
            completion(false, nil)
        }
    }
    
    func autenticarUsuario(email: String, senha: String, completion: @escaping (Bool, CDUser?) -> Void) {
        let request: NSFetchRequest<CDUser> = CDUser.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@ AND senha == %@", email, senha)
        
        do {
            let users = try context.fetch(request)
            if let user = users.first {
                completion(true, user)
            } else {
                completion(false, nil)
            }
        } catch {
            print("Erro ao autenticar: \(error)")
            completion(false, nil)
        }
    }
    
    func getCurrentUser(completion: @escaping (CDUser?) -> Void) {
        let request: NSFetchRequest<CDUser> = CDUser.fetchRequest()
        request.fetchLimit = 1
        
        do {
            let users = try context.fetch(request)
            completion(users.first)
        } catch {
            print("Erro ao obter usuário atual: \(error)")
            completion(nil)
        }
    }
    
    func logout() {
        // Limpa o usuário atual do contexto
        // (O estado real é gerenciado pelo AppState)
    }
    
    // MARK: - Operações de Favoritos
    
    func toggleFavorite(for user: CDUser, pokemon: Pokemon) {
        let request: NSFetchRequest<CDFavorite> = CDFavorite.fetchRequest()
        request.predicate = NSPredicate(format: "usuario == %@ AND pokemonId == %d", user, pokemon.id)
        
        do {
            let favorites = try context.fetch(request)
            
            if let existingFavorite = favorites.first {
                context.delete(existingFavorite)
            } else {
                let newFavorite = CDFavorite(context: context)
                newFavorite.usuario = user
                newFavorite.pokemonId = Int32(pokemon.id)
                newFavorite.dataAdicao = Date()
            }
            
            saveContext()
        } catch {
            print("Erro ao alternar favorito: \(error)")
        }
    }
    
    func isFavorite(pokemon: Pokemon, for user: CDUser) -> Bool {
        let request: NSFetchRequest<CDFavorite> = CDFavorite.fetchRequest()
        request.predicate = NSPredicate(format: "usuario == %@ AND pokemonId == %d", user, pokemon.id)
        request.fetchLimit = 1
        
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            print("Erro ao verificar favorito: \(error)")
            return false
        }
    }
    
    func getFavorites(for user: CDUser) -> [CDFavorite] {
        let request: NSFetchRequest<CDFavorite> = CDFavorite.fetchRequest()
        request.predicate = NSPredicate(format: "usuario == %@", user)
        request.sortDescriptors = [NSSortDescriptor(key: "dataAdicao", ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Erro ao obter favoritos: \(error)")
            return []
        }
    }
    
    // MARK: - Pré-carregamento de Dados (Opcional)
    
    func preloadInitialDataIfNeeded() {
        // Implementar se necessário
    }
}
