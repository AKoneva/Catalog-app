//
//  User+CoreDataProperties.swift
//  Catalog app
//
//  Created by Macbook Pro on 09.11.2021.
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
    @NSManaged public var image: String?
    @NSManaged public var name: String?
    @NSManaged public var password: String?

}

extension User : Identifiable {

}
