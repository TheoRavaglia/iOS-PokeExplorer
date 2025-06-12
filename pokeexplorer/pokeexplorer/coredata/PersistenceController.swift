// Verificar credenciais	
func autenticarUsuario(email: String, senha: String) -> Bool {
    let context = container.viewContext
    let request: NSFetchRequest<Usuario> = Usuario.fetchRequest()
    request.predicate = NSPredicate(format: "email == %@ AND senha == %@", email, senha)
    
    do {
        let usuarios = try context.fetch(request)
        return !usuarios.isEmpty
    } catch {
        print("Erro na autenticação: \(error)")
        return false
    }
}

// Método para registrar novo usuário
func registrarUsuario(nome: String, email: String, senha: String) -> Bool {
    let context = container.viewContext
    let novoUsuario = Usuario(context: context)
    novoUsuario.id = UUID()
    novoUsuario.nomeDeUsuario = nome
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
