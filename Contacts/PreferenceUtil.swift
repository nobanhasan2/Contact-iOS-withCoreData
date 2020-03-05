//
//  PreferenceUtil.swift
//  Contacts
//  Created by Noban Aits on 4/3/20.
//  Copyright © 2020 Johnny Perdomo. All rights reserved.
//

import Foundation
import ObjectMapper

class PreferenceUtil{
    

    static let PREF_FIELD: String = "FIELD"
    static let PREF_EMAIL: String = "EMAIL"
    static let PREF_APP_FIRST_TIME_LAUNCE:String = "PREF_APP_FIRST_TIME_LAUNCE"
       
    class func setFirstLaunch() {
           UserDefaults.standard.set(false, forKey: PREF_APP_FIRST_TIME_LAUNCE)
    }
    
    class func addNewFields(field : FieldModel){
            let defaults = UserDefaults.standard
        var allFields = getAllFields()
            print(field.fieldName)
        
            allFields.fields?.append(field)
           
            let fieldJson = Mapper().toJSONString(allFields)
        
            print(fieldJson)
            defaults.set(fieldJson, forKey: PREF_FIELD)
        
    }
    class func getAllFields() -> FieldList {
        let defaults = UserDefaults.standard
        if(defaults.value(forKey: PREF_FIELD) != nil){
                let allFieldJSON = defaults.value(forKey: PREF_FIELD) as! String
              //  print(allFieldJSON)
                let allFields = FieldList(JSONString: allFieldJSON)
                return allFields!
              } else{
            var Allfields = FieldList()
                Allfields.fields = [FieldModel]()
                return Allfields
                
              }
      }
     
    class func isExistInField(name : String) -> Bool {
       
        let allFields = getAllFields()
              for i in 0..<(allFields.fields?.count ?? 0){
                  if name == allFields.fields![i].fieldName{
                    //  cartProducts.products?.remove(at: i)
                      return true
                  }
              }
              return false
        
    }
    class func removeField(name : String){
        let defaults = UserDefaults.standard
        var allFields = getAllFields()
        for i in 0..<(allFields.fields?.count ?? 0){
                    if name == allFields.fields![i].fieldName{
                      //  cartProducts.products?.remove(at: i)
                        allFields.fields?.remove(at: i)
                        break
                    }
                }
        let fieldJson = Mapper().toJSONString(allFields)
        defaults.set(fieldJson, forKey: PREF_FIELD)
    
    }
    
    


    
 
      
}
