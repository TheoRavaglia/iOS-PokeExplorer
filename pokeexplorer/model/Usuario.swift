import CoreData

@objc(Usuario)
public class Usuario: NSManagedObject {
    @NSManaged public var id: UUID?
    @NSManaged public var nome: String?
    @NSManaged public var email: String?
    @NSManaged public var senha: String?
}

// Adicione esta extensão SE precisar de fetchRequest
extension Usuario {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Usuario> {
        return NSFetchRequest<Usuario>(entityName: "Usuario")
    }
}
