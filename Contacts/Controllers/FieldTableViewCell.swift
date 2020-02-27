//
//  FieldTableViewCell.swift
//  Contacts
//
//  Created by Noban Aits on 27/2/20.
//  Copyright © 2020 Johnny Perdomo. All rights reserved.
//

import UIKit

class FieldTableViewCell: UITableViewCell {

    @IBOutlet weak var fieldName: UILabel!
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
