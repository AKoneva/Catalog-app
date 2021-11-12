//
//  Products+CoreDataProperties.swift
//  Catalog app
//
//  Created by Macbook Pro on 12.11.2021.
//
//

import Foundation
import CoreData


extension Products {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Products> {
        return NSFetchRequest<Products>(entityName: "Products")
    }

    @NSManaged public var category: String?
    @NSManaged public var discription: String?
    @NSManaged public var id: UUID?
    @NSManaged public var image: String?
    @NSManaged public var name: String?
    @NSManaged public var rating: Double
    @NSManaged public var comments: NSSet?

}

// MARK: Generated accessors for comments
extension Products {

    @objc(addCommentsObject:)
    @NSManaged public func addToComments(_ value: Comments)

    @objc(removeCommentsObject:)
    @NSManaged public func removeFromComments(_ value: Comments)

    @objc(addComments:)
    @NSManaged public func addToComments(_ values: NSSet)

    @objc(removeComments:)
    @NSManaged public func removeFromComments(_ values: NSSet)

}

extension Products : Identifiable {

}
