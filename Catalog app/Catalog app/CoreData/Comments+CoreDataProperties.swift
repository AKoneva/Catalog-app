//
//  Comments+CoreDataProperties.swift
//  Catalog app
//
//  Created by Macbook Pro on 12.11.2021.
//
//

import Foundation
import CoreData


extension Comments {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Comments> {
        return NSFetchRequest<Comments>(entityName: "Comments")
    }

    @NSManaged public var comment: String?
    @NSManaged public var id: UUID?
    @NSManaged public var productId: UUID?
    @NSManaged public var rate: Double
    @NSManaged public var time: Date?
    @NSManaged public var user: User?
    @NSManaged public var products: Products?

}

extension Comments : Identifiable {

}
