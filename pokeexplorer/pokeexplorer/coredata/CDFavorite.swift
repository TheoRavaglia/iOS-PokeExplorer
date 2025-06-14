import CoreData

@objc(CDFavorite)
public class CDFavorite: NSManagedObject, Identifiable {
    @NSManaged public var pokemonId: Int32
    @NSManaged public var dateAdded: Date?
    @NSManaged public var user: CDUser?
}

extension CDFavorite {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDFavorite> {
        return NSFetchRequest<CDFavorite>(entityName: "CDFavorite")
    }
}

extension CDFavorite {
    static func mock(user: CDUser) -> CDFavorite {
        let favorite = CDFavorite(context: DataStore.shared.context)
        favorite.pokemonId = 25
        favorite.dateAdded = Date()
        favorite.user = user
        return favorite
    }
}
