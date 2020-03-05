//
//  FieldsModel.swift
//  Contacts
//
//  Created by Noban Aits on 24/2/20.
//  Copyright © 2020 Johnny Perdomo. All rights reserved.
//

import Foundation
import ObjectMapper

struct FieldModel : Mappable ,Codable{
    var fieldName : String?
    var fieldValue : String?
     init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        fieldName <- map["fieldName"]
        fieldValue <- map["fieldValue"]
    }
    init(name: String , value: String){
        self.fieldName = name
        self.fieldValue = value
    }
}
struct FieldList : Mappable,Codable{
    var fields : [FieldModel]? = []
     init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        fields <- map["fields"]
    }
    init(){
        
    }
}
