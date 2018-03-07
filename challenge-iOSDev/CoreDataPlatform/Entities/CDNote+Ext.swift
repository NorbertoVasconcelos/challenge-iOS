import Foundation
import CoreData
import QueryKit
import RxSwift

extension CDNote {
    static var title: Attribute<String> { return Attribute("title")}
    static var body: Attribute<String> { return Attribute("body")}
    static var uid: Attribute<String> { return Attribute("uid")}
    static var createdAt: Attribute<String> { return Attribute("createdAt")}
    static var latitude: Attribute<Double> { return Attribute("latitude")}
    static var longitude: Attribute<Double> { return Attribute("longitude")}
}

extension CDNote: DomainConvertibleType {
    func asDomain() -> Note {
        return Note(body: body!,
                    title: title!,
                    location: Location(latitude: latitude! as! Double, longitude: longitude! as! Double),
                    createdAt: createdAt!,
                    uid: uid!)
    }
}

extension CDNote: Persistable {
    static var entityName: String {
        return "CDNote"
    }
}

extension Note: CoreDataRepresentable {
    typealias CoreDataType = CDNote
    
    func update(entity: CDNote) {
        entity.uid = uid
        entity.title = title
        entity.body = body
        entity.createdAt = createdAt
        entity.latitude = location.latitude as NSNumber
        entity.longitude = location.longitude as NSNumber
    }
}
