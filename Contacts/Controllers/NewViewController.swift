//
//  NewViewController.swift
//  Contacts
//
//  Created by Noban Aits on 26/2/20.
//  Copyright © 2020 Johnny Perdomo. All rights reserved.
//

import UIKit

class NewViewController: UIViewController {

    private var isFavoritesLblHidden = Bool()
    private var isFavoritesBtnHidden = Bool()
    private var isTableViewEditable = Bool()
    
    private var firstNameString = String()
    private var lastNameString = String()
    private var dateOfBirthString = String()
    private var profileImage = UIImage()
    private var fieldString = String()
    private var fieldList : [FieldModel] = []
    
    
    private var phoneNumberArray = [String]()
    private var emailArray = [String]()
    private var addressArray = [String]()
    
    private var fieldsArray = [String]()
    
    private var datePicker = UIDatePicker()
    
    let xPos : CGFloat = 0
    var yPos : CGFloat = 0
    
    private var userDataArray: [Int : [String]] = [0: [], 1: [], 2: [], 3: []]
    @IBOutlet weak var stackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
