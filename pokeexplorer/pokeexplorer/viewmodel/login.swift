import CoreData

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var senha = ""
    @Published var mostrarErro = false
    @Published var mensagemErro = ""
    
    private let context = PersistenceController.shared.container.viewContext
    
    func login() -> Bool {
        let request: NSFetchRequest<Usuario> = Usuario.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@ AND senha == %@", email, senha)
        
        do {
            let usuarios = try context.fetch(request)
            return !usuarios.isEmpty
        } catch {
            print("Erro ao buscar usuário: \(error)")
            return false
        }
    }
}
