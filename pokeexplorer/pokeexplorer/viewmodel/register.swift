import CoreData

class RegisterViewModel: ObservableObject {
    @Published var nomeDeUsuario = ""
    @Published var email = ""
    @Published var senha = ""
    @Published var confirmarSenha = ""
    
    private let context = PersistenceController.shared.container.viewContext
    
    func registrar() -> Bool {
        guard senha == confirmarSenha else { return false }
        
        let novoUsuario = Usuario(context: context)
        novoUsuario.id = UUID()
        novoUsuario.nomeDeUsuario = nomeDeUsuario
        novoUsuario.email = email
        novoUsuario.senha = senha
        
        do {
            try context.save()
            return true
        } catch {
            print("Erro ao salvar usuário: \(error)")
            return false
        }
    }
}
