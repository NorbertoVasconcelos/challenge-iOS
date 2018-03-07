import Foundation
import CoreData


extension CDNote {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDNote> {
        return NSFetchRequest<CDNote>(entityName: "CDNote")
    }

    @NSManaged public var body: String?
    @NSManaged public var title: String?
    @NSManaged public var uid: String?
    @NSManaged public var createdAt: String?
    @NSManaged public var latitude: NSNumber?
    @NSManaged public var longitude: NSNumber?
}
