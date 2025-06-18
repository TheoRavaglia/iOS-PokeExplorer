import CoreData

@objc(CDUser)
public class CDUser: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID?
    @NSManaged public var nome: String?
    @NSManaged public var email: String?
    @NSManaged public var senha: String?
    @NSManaged public var favoritos: Set<CDFavorite>?
}

extension CDUser {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDUser> {
        return NSFetchRequest<CDUser>(entityName: "CDUser")
    }
}

extension CDUser {
    static func mock() -> CDUser {
        let user = CDUser(context: DataStore.shared.context)
        user.id = UUID()
        user.nome = "Ash Ketchum"
        user.email = "ash@pokemon.com"
        user.senha = "pikachu123"
        return user
    }
}
