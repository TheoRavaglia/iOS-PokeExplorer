import CoreData

class DataStore {
    static let shared = DataStore()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PokéExplorerModel")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Erro ao carregar Core Data: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Erro ao salvar contexto: \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func fetch<T: NSManagedObject>(_ request: NSFetchRequest<T>) -> [T] {
        do {
            return try context.fetch(request)
        } catch {
            print("Erro ao buscar dados: \(error)")
            return []
        }
    }
    
    func delete(_ object: NSManagedObject) {
        context.delete(object)
        saveContext()
    }
}
