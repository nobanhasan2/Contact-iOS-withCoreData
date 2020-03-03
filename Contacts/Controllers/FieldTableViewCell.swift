//
//  FieldTableViewCell.swift
//  Contacts
//
//  Created by Noban Aits on 27/2/20.
//  Copyright © 2020 Johnny Perdomo. All rights reserved.
//

import UIKit
protocol TextFieldChangeDeleget {
    func fieldTableCell( index: Int,didChange text: String)
}
protocol RemoveFieldDeleget {
    func removeField( index: Int)
}
class FieldTableViewCell: UITableViewCell {

    var index: Int?
    var textFieldChangeDeleget : TextFieldChangeDeleget?
    var removeFieldDeleget : RemoveFieldDeleget?
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var fieldName: UILabel!
   
   
    @IBAction func onTapRemove(_ sender: Any) {
        removeFieldDeleget?.removeField(index: index!)
    }
    
    
    @IBAction func textDidChange(_ sender: Any) {
        textFieldChangeDeleget?.fieldTableCell(index: index!, didChange: fieldtext.text!)
    }
    @IBOutlet weak var fieldtext: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
