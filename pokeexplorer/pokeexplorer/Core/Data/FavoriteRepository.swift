import CoreData

class FavoriteRepository {
    private let dataStore = DataStore.shared
    
    func toggleFavorite(user: CDUser, pokemonId: Int) {
        let request: NSFetchRequest<CDFavorite> = CDFavorite.fetchRequest()
        request.predicate = NSPredicate(format: "user == %@ AND pokemonId == %d", user, pokemonId)
        
        do {
            let favorites = try dataStore.context.fetch(request)
            
            if let existingFavorite = favorites.first {
                dataStore.context.delete(existingFavorite)
            } else {
                let newFavorite = CDFavorite(context: dataStore.context)
                newFavorite.user = user
                newFavorite.pokemonId = Int32(pokemonId)
                newFavorite.dateAdded = Date()
            }
            
            dataStore.saveContext()
        } catch {
            print("Erro ao alternar favorito: \(error)")
        }
    }
    
    func isFavorite(user: CDUser, pokemonId: Int) -> Bool {
        let request: NSFetchRequest<CDFavorite> = CDFavorite.fetchRequest()
        request.predicate = NSPredicate(format: "user == %@ AND pokemonId == %d", user, pokemonId)
        request.fetchLimit = 1
        
        do {
            let count = try dataStore.context.count(for: request)
            return count > 0
        } catch {
            print("Erro ao verificar favorito: \(error)")
            return false
        }
    }
    
    func getFavorites(for user: CDUser) -> [CDFavorite] {
        let request: NSFetchRequest<CDFavorite> = CDFavorite.fetchRequest()
        request.predicate = NSPredicate(format: "user == %@", user)
        request.sortDescriptors = [NSSortDescriptor(key: "dateAdded", ascending: false)]
        
        do {
            return try dataStore.context.fetch(request)
        } catch {
            print("Erro ao obter favoritos: \(error)")
            return []
        }
    }
}
