//
//  FieldsModel.swift
//  Contacts
//
//  Created by Noban Aits on 24/2/20.
//  Copyright © 2020 Johnny Perdomo. All rights reserved.
//

import Foundation


class FieldModel : Codable {
    var fieldName : String?
    var fieldValue : String?
    
    init(name: String , value: String){
        self.fieldName = name
        self.fieldValue = value
    }
}
