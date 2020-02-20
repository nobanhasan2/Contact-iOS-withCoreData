//
//  Field+CoreDataProperties.swift
//  
//
//  Created by Noban Aits on 20/2/20.
//
//

import Foundation
import CoreData


extension Field {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Field> {
        return NSFetchRequest<Field>(entityName: "Field")
    }

    @NSManaged public var name: String?
    @NSManaged public var value: String?
    @NSManaged public var person: Person?

}
