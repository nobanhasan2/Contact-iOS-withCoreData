//
//  field+CoreDataProperties.swift
//  
//
//  Created by Noban Aits on 3/3/20.
//
//

import Foundation
import CoreData


extension field {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<field> {
        return NSFetchRequest<field>(entityName: "Field")
    }

    @NSManaged public var fieldName: NSObject?
    @NSManaged public var fieldValue: String?
    @NSManaged public var person: Person?

}
