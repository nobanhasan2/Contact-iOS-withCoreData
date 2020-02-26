//
//  field+CoreDataProperties.swift
//  
//
//  Created by Noban Aits on 24/2/20.
//
//

import Foundation
import CoreData


extension field {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<field> {
        return NSFetchRequest<field>(entityName: "Field")
    }

    @NSManaged public var fieldName: String?
    @NSManaged public var value: String?

}
