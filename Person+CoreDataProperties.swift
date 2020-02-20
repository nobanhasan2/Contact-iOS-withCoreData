//
//  Person+CoreDataProperties.swift
//  
//
//  Created by Noban Aits on 20/2/20.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var addresses: NSObject?
    @NSManaged public var dateOfBirth: String?
    @NSManaged public var emails: NSObject?
    @NSManaged public var firstName: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var lastName: String?
    @NSManaged public var phoneNumbers: NSObject?
    @NSManaged public var profileImage: Data?
    @NSManaged public var fields: Field?

}
