
//
//  CustomFieldTextFieldBulletinItem.swift
//  Contacts
//  Created by Noban Aits on 23/2/20.
//  Copyright © 2020 Johnny Perdomo. All rights reserved.
//

import Foundation
import BLTNBoard

class CustomFieldTextFieldBulletinItem : BLTNPageItem {
    
    @objc public var textField: UITextField!
    
    @objc public var textInputHandler: ((BLTNActionItem, String?) -> Void)? = nil
    
    override func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        textField = interfaceBuilder.makeTextField(placeholder: "Field Name", returnKey: .done, delegate: self)
        
        return [textField]
    }
    override func tearDown() {
        super.tearDown()
        textField?.delegate = nil
    }
    
    override func actionButtonTapped(sender: UIButton) {
        textField.resignFirstResponder()
     
        super.actionButtonTapped(sender: sender)
    }
}

// MARK: - UITextFieldDelegate
extension CustomFieldTextFieldBulletinItem: UITextFieldDelegate {
    
    @objc open func isInputValid(text: String?) -> Bool {
        
        if text == nil || text!.isEmpty {
            return false
        }
        
        return true
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
//        if isInputValid(text: textField2.text) {
//            textInputHandler?(self, textField2.text)
//        } else {
//            descriptionLabel!.textColor = .red
//            descriptionLabel!.text = "You must enter some text to continue."
//            textField.backgroundColor = UIColor.red.withAlphaComponent(0.3)
//        }
    }
}

