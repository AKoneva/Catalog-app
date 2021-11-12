//
//  User+CoreDataProperties.swift
//  Catalog app
//
//  Created by Macbook Pro on 12.11.2021.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var commentsCount: Int64
    @NSManaged public var email: String?
    @NSManaged public var id: UUID?
    @NSManaged public var image: Data?
    @NSManaged public var name: String?
    @NSManaged public var password: String?
    @NSManaged public var comments: NSSet?

}

// MARK: Generated accessors for comments
extension User {

    @objc(addCommentsObject:)
    @NSManaged public func addToComments(_ value: Comments)

    @objc(removeCommentsObject:)
    @NSManaged public func removeFromComments(_ value: Comments)

    @objc(addComments:)
    @NSManaged public func addToComments(_ values: NSSet)

    @objc(removeComments:)
    @NSManaged public func removeFromComments(_ values: NSSet)

}

extension User : Identifiable {

}
