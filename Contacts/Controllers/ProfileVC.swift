//
//  CreateContactVC.swift
//  Contacts
//
//  Created by Johnny Perdomo on 12/19/18.
//  Copyright © 2018 Johnny Perdomo. All rights reserved.
//
import UIKit
import CoreData
import MessageUI
import MapKit
import SwiftMessages
import BLTNBoard

class ProfileVC: UIViewController {
    
    //MARK: Variables, Constants, Arrays ------------------------------------------------------------
    
    
    @IBOutlet weak var fieldtableView: UITableView!
    @IBOutlet weak var addBtn: UIButton!
    @IBAction func onAddFieldButtonClick(_ sender: Any) {
         customField.showBulletin(above: self)
    }
    private var isNameLblHidden = Bool()
    private var isModifyBtnHidden = Bool()
    private var isDateLblHidden = Bool()
    private var isFirstNameTextFieldHidden = Bool()
    private var isLastNameTextFieldHidden = Bool()
    private var isDateOfBirthTextFieldHidden = Bool()
    private var isSaveBtnHidden = Bool()
    private var isBackBtnHidden = Bool()
    private var isCancelBtnHidden = Bool()
    private var isChangeImageBtnHidden = Bool()
    private var isFavoritesIconImgHidden = Bool()
    private var isFavoritesIconShadowViewHidden = Bool()
    private var isFavoritesLblHidden = Bool()
    private var isFavoritesBtnHidden = Bool()
    private var isTableViewEditable = Bool()
    
    private var firstNameString = String()
    private var lastNameString = String()
    private var dateOfBirthString = String()
    private var profileImage = UIImage()
    private var fieldString = String()
    private var fieldList = [FieldModel]()
    private var pFieldList = [FieldModel]()
    private var isEditable : Bool = false
    
    
  //  private var phoneNumberArray = [String]()
 //   private var emailArray = [String]()
 //   private var addressArray = [String]()
    
    private var fieldsArray = [String]()
    
    private var datePicker = UIDatePicker()
    
    let xPos : CGFloat = 0
    var yPos : CGFloat = 0
    
    private var userDataArray: [Int : [String]] = [0: [], 1: [], 2: [], 3: []] //to store user data -> 0: phone, 1: email, 2: address
    
    private var profileType: ProfileTypeEnum!
    private var isFavorite: IsFavoriteEnum!
    private var initialIsFavoriteValue: IsFavoriteEnum!
    
    private var userDataButtonInfo = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        fieldtableView.delegate = self
        fieldtableView.dataSource = self
        fieldList = PreferenceUtil.getAllFields().fields!
       
        setupProfileVC()
    }
    
       //MARK: Bulletin Items -----------------------------------------------------------------------------
       lazy var customField: BLTNItemManager = {
        
        let page = CustomFieldTextFieldBulletinItem(title: "Field")
        page.descriptionText = "Enter a field value"
        page.actionButtonTitle = "Enter"
        page.alternativeButtonTitle = "Close"
        
       
        page.actionHandler = { (item: BLTNActionItem) in
            
            if(!page.textField.text!.isEmpty){
                let field =  FieldModel(name: page.textField.text!,value: "")
                if(PreferenceUtil.isExistInField(name: page.textField.text!)){
                    print("Exist in field")
                }else{
                       PreferenceUtil.addNewFields(field: field)
                }
             
                           do{
                               let jsonEncoder = JSONEncoder()
                               let jsonData = try jsonEncoder.encode(field)
                               let json = String(data: jsonData, encoding: String.Encoding.utf8)
                               self.appendUserData(text: json!, section: self.userDataButtonInfo.tag)
                           }
                           catch let error as NSError
                           {
                               print(error.localizedDescription)
                           }

                         
                           self.dismissCustomBoard()
                       }
            }
           
        
        page.alternativeHandler = { (item: BLTNActionItem) in
        self.dismissCustomBoard()        }
        
        let item: BLTNItem = page
        item.isDismissable = true
        item.requiresCloseButton = false
        return BLTNItemManager(rootItem: item)
    }()
    
    
    lazy var datePickerBulletin: BLTNItemManager = {
        
        let page = DatePickerBLTNItem(title: "Birthday")
        page.descriptionText = "Enter a date of birth."
        page.actionButtonTitle = "Enter"
        page.alternativeButtonTitle = "Close"
        
        page.actionHandler = { (item: BLTNActionItem) in
            
            self.dateChanged(datePicker: page.datePicker)
            self.dismissDatePickerBoard()
            self.view.endEditing(true)
        }
        
        page.alternativeHandler = { (item: BLTNActionItem) in
            self.dismissDatePickerBoard()
            self.view.endEditing(true)
        }
        
        let item: BLTNItem = page
        item.isDismissable = true
        item.requiresCloseButton = false
        return BLTNItemManager(rootItem: item)
    }()
    
    //MARK: IBOutlets -----------------------------------------------------------------------------
    
    @IBOutlet weak private var profileTableView: UITableView!
    @IBOutlet weak private var backgroundTableview: CustomUIViewTopRounded!
    @IBOutlet weak private var backgroundTableViewTopContraint: NSLayoutConstraint!
    @IBOutlet weak private var firstNameTxtField: UITextField!
    @IBOutlet weak private var lastNameTxtField: UITextField!
    @IBOutlet weak private var dateOfBirthTextField: UITextField!
    @IBOutlet weak private var modifyBtn: UIButton!
    @IBOutlet weak private var nameLbl: UILabel!
    @IBOutlet weak private var dateOfBirthLbl: UILabel!
    @IBOutlet weak private var saveBtn: UIButton!
    @IBOutlet weak private var cancelBtn: UIButton!
    @IBOutlet weak private var backBtn: UIButton!
    @IBOutlet weak private var profileImg: UIImageView!
    @IBOutlet weak private var changeImageBtn: UIButton!
    @IBOutlet weak private var favoritesLbl: UILabel!
    @IBOutlet weak private var favoritesBtn: UIButton!
    @IBOutlet weak private var favoritesIconImg: UIImageView!
    @IBOutlet weak private var favoritesIconShadowView: CustomUIView!
    
    //MARK: IBActions -----------------------------------------------------------------------------
    
    @IBAction private func saveBtnPressed(_ sender: Any) {
        
        if profileType == ProfileTypeEnum.createNew {
            
            if firstNameTxtField.text != "" && lastNameTxtField.text != "" && dateOfBirthTextField.text != "" && (userDataArray[0]?.count)! >= 0 && (userDataArray[1]?.count)! >= 0 {
                
                saveProfile(firstName: (firstNameTxtField.text?.capitalized)!, lastName: (lastNameTxtField.text?.capitalized)!, dateOfBirth: dateOfBirthTextField.text!, phoneNumbers: userDataArray[0]!, emails: userDataArray[1]!, addresses: userDataArray[2]!,fields: fieldList, profileImage: profileImg.image!, isFavoritePerson: isFavorite) { (complete) in
                    
                    if complete {
                        guard let contactsVC = storyboard?.instantiateViewController(withIdentifier: "ContactsVC") else { return }
                        self.present(contactsVC, animated: true)
                    } else {
                        print("error saving")
                    }
                }
                
            } else {
                showIncompleteFieldsErrorCard()
            }
            
        } else {
            
            var isFavoriteBool = Bool()
            
            if isFavorite == .no {
                isFavoriteBool = false
            } else if isFavorite == .yes {
                isFavoriteBool = true
            }
            
            if firstNameTxtField.text != "" && lastNameTxtField.text != "" && dateOfBirthTextField.text != "" && (userDataArray[0]?.count)! >= 0 && (userDataArray[1]?.count)! >= 0 {
            
                modifyProfileInfo(searchFirstName: firstNameString, searchLastName: lastNameString, searchDateOfBirth: dateOfBirthString, newFirstName: firstNameTxtField.text!, newLastName: lastNameTxtField.text!, newDateOfBirth: dateOfBirthTextField.text!, newProfileImage: profileImg.image!, newPhonenumbers: userDataArray[0]!, newEmails: userDataArray[1]!, newAddresses: userDataArray[2]!, newIsFavoritePerson: isFavoriteBool ,fields: fieldList) { (complete) in
                
                    if complete {
                        guard let contactsVC = storyboard?.instantiateViewController(withIdentifier: "ContactsVC") else { return }
                        self.present(contactsVC, animated: true)
                    } else {
                        print("error saving")
                    }
                }
                
            } else {
                showIncompleteFieldsErrorCard()
            }
        }
    }
    
    @IBAction private func changeImageBtnPressed(_ sender: Any) {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction private func modifyProfileBtnPressed(_ sender: Any) {
        
        nameLbl.isHidden = true
        dateOfBirthLbl.isHidden = true
        firstNameTxtField.isHidden = false
        lastNameTxtField.isHidden = false
        dateOfBirthTextField.isHidden = false
        
        isEditable = true
        addBtn.isHidden = false
        fieldtableView.reloadData()
        modifyBtn.isHidden = true
        backBtn.isHidden = true
        
        saveBtn.isHidden = false
        cancelBtn.isHidden = false
        changeImageBtn.isHidden = true
        
        isTableViewEditable = true
        
        favoritesBtn.isHidden = true
        favoritesLbl.isHidden = true
        favoritesIconImg.isHidden = true
        favoritesIconShadowView.isHidden = true
        
        if initialIsFavoriteValue == .no {
  
            favoritesBtn.setImage(UIImage(named: "starUnfilled"), for: .normal)
            favoritesLbl.text = "Add to favorites"
            
        } else if initialIsFavoriteValue == .yes {
            
            favoritesBtn.setImage(UIImage(named: "starFilled"), for: .normal)
            favoritesLbl.text = "Remove from favorites"
        }
        
//        backgroundTableViewTopContraint.constant = 40
        
        firstNameTxtField.text = firstNameString
        lastNameTxtField.text = lastNameString
        dateOfBirthTextField.text = dateOfBirthString
        
//        profileTableView.reloadData()
    }
    
    @IBAction private func cancelBtnPressed(_ sender: Any) {
        nameLbl.isHidden = false
        dateOfBirthLbl.isHidden = false
        firstNameTxtField.isHidden = true
        lastNameTxtField.isHidden = true
        dateOfBirthTextField.isHidden = true
        
        modifyBtn.isHidden = false
        backBtn.isHidden = false
        
        saveBtn.isHidden = true
        cancelBtn.isHidden = true
        changeImageBtn.isHidden = true
        
        isTableViewEditable = false
        
        favoritesBtn.isHidden = true
        favoritesLbl.isHidden = true
        
        if initialIsFavoriteValue == .no {
            isFavorite = initialIsFavoriteValue
            
            favoritesIconImg.isHidden = true
            favoritesIconShadowView.isHidden = true
            
            favoritesBtn.setImage(UIImage(named: "starUnfilled"), for: .normal)
            favoritesLbl.text = "Add to favorites"
            
        } else if initialIsFavoriteValue == .yes {
            isFavorite = initialIsFavoriteValue
            
            favoritesIconImg.isHidden = false
            favoritesIconShadowView.isHidden = false
            
            favoritesBtn.setImage(UIImage(named: "starFilled"), for: .normal)
            favoritesLbl.text = "Remove from favorites"
        }
        
//        backgroundTableViewTopContraint.constant = -10
        
        nameLbl.text = "\(firstNameString) \(lastNameString)"
        dateOfBirthLbl.text = "Birthday: \(dateOfBirthString) 🎉"
        
      //  profileTableView.reloadData()
    }
    
    @IBAction private func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func favoritesBtnPressed(_ sender: Any) {
        
        addFavoritePerson(isFavoritePerson: isFavorite)
    }
    
    //MARK: VC Functions -----------------------------------------------------------------------------
    
    func initProfileView(firstName: String = "", lastName: String = "", dateOfBirth: String = "", profileImage: UIImage = UIImage(named: "personPlaceholder")!, phoneNumbers: [String] = [], emails: [String] = [], addresses: [String] = [],fields: String = "", profileType: ProfileTypeEnum, isFavorite: IsFavoriteEnum = .no) {
        isEditable = false
//        addBtn.isHidden = true
        userDataArray[0] = phoneNumbers
        userDataArray[1] = emails
        userDataArray[2] = addresses
      //  userDataArray[3] = fields
        do{
            print(fields)
            let fieldLi = FieldList(JSONString: fields)
            print(fieldLi)
            //pFieldList = (fieldLi?.fields!)!
        }catch let error{
         print(error)
        }
        
     
        
      //  print(fields)
      //  print("All Fields :" + (PreferenceUtil.getAllFields().toJSONString())!)

        for item in pFieldList {
            for mItem in fieldList{
                if(item.fieldName == mItem.fieldName){
                    mItem.fieldValue = item.fieldValue
                }
            }
         
    }
        print(fieldList.toJSON())
       // fieldtableView.reloadData()
    
       
   //     if(fieldList.count != 0){
//            self.fieldtableView.reloadData()
//            for item in fieldList{
//                      yPos += 22
//                      let tf = CustomTextField()
//                      tf.text = item.fieldName
//                      tf.textColor = UIColor.white
//                      tf.frame = CGRect(x: xPos, y: yPos, width: 200, height: 20)
//
//                      tf.backgroundColor = UIColor.black
//                    //  self.stackview.addSubview(tf)
//                  }
//        }
      //  print("List Size" + "\(fieldList[0].fieldName)")
        
        //  let jsonDecoder = JSONDecoder()
        //  self.fieldList = try jsonDecoder.decode(FieldModel.self, from: userDataArray[3])
        print(userDataArray[3])
        
        self.profileType = profileType
        self.isFavorite = isFavorite
        self.initialIsFavoriteValue = isFavorite
        
        switch profileType {
        case .createNew:
            
            self.isNameLblHidden = true
            self.isDateLblHidden = true
            self.isModifyBtnHidden = true

            self.isFirstNameTextFieldHidden = false
            self.isLastNameTextFieldHidden = false
            self.isDateOfBirthTextFieldHidden = false
            self.isSaveBtnHidden = false
            self.isChangeImageBtnHidden = true
            
            self.isTableViewEditable = true
            
            self.isFavoritesLblHidden = true
            self.isFavoritesBtnHidden = true
            self.isFavoritesIconImgHidden = true
            self.isFavoritesIconShadowViewHidden = true
            self.profileImage = profileImage
            
        case .view:
            
            self.isNameLblHidden = false
            self.isDateLblHidden = false
            self.isModifyBtnHidden = false
            
            self.isFirstNameTextFieldHidden = true
            self.isLastNameTextFieldHidden = true
            self.isDateOfBirthTextFieldHidden = true
            self.isSaveBtnHidden = true
            self.isChangeImageBtnHidden = true
            
            self.isTableViewEditable = false
            
            self.isFavoritesLblHidden = true
            self.isFavoritesBtnHidden = true
            
            switch isFavorite {
            case .no:
                self.isFavoritesIconImgHidden = true
                self.isFavoritesIconShadowViewHidden = true
            case .yes:
                self.isFavoritesIconImgHidden = false
                self.isFavoritesIconShadowViewHidden = false
            }
            
            self.firstNameString = firstName
            self.lastNameString = lastName
            self.dateOfBirthString = dateOfBirth
            self.profileImage = profileImage
        }
    }
    
    private func setupProfileVC() {
        firstNameTxtField.delegate = self
        lastNameTxtField.delegate = self
        dateOfBirthTextField.delegate = self
        
        //  profileTableView.delegate = self
        // profileTableView.dataSource = self
        
        if profileType == ProfileTypeEnum.createNew {
            addBtn.isHidden = false
            isEditable = true
            fieldtableView.reloadData()
        //    backgroundTableViewTopContraint.constant = 40
        } else if profileType == ProfileTypeEnum.view {
        //    backgroundTableViewTopContraint.constant = -10
        }
        
        nameLbl.isHidden = isNameLblHidden
        dateOfBirthLbl.isHidden = isDateLblHidden
        firstNameTxtField.isHidden = isFirstNameTextFieldHidden
        lastNameTxtField.isHidden = isLastNameTextFieldHidden
        dateOfBirthTextField.isHidden = isDateOfBirthTextFieldHidden
        saveBtn.isHidden = isSaveBtnHidden
        modifyBtn.isHidden = isModifyBtnHidden
        changeImageBtn.isHidden = isChangeImageBtnHidden
        
        favoritesBtn.isHidden = isFavoritesBtnHidden
        favoritesLbl.isHidden = isFavoritesLblHidden
        favoritesIconImg.isHidden = isFavoritesIconImgHidden
        favoritesIconShadowView.isHidden = isFavoritesIconShadowViewHidden
        
        nameLbl.text = "\(firstNameString) \(lastNameString)"
        dateOfBirthLbl.text = "Birthday: \(dateOfBirthString) 🎉"
        profileImg.image = profileImage
    }
    
     private func dateChanged(datePicker: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        dateOfBirthTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    private func appendUserData(text: String, section: Int) {
        
     //   fieldsArray.append(text)
        fieldList = PreferenceUtil.getAllFields().fields!
        fieldtableView.reloadData()
        if var array = userDataArray[section] {
            array.append(text)
            userDataArray[section] = array
        } else {
            userDataArray[section] = [text]
        }
        do{
            let somedata = Data(text.utf8)
            let jsonDecoder = JSONDecoder()
            let field = try jsonDecoder.decode(FieldModel.self, from: somedata)
//                               yPos += 22
//                               let tf = CustomTextField()
//                               tf.text = field.fieldValue
//                               tf.textColor = UIColor.black
//            tf.borderStyle = UITextField.BorderStyle.line
//                               tf.frame = CGRect(x: xPos, y: yPos, width: 200, height: 20)
//
//                               tf.backgroundColor = UIColor.white
                             //  self.stackview.addSubview(tf)
            
        } catch let jsError{
            print(jsError)
        }
         fieldtableView.reloadData()
        print("Reload calling")
//        profileTableView.reloadData()
    }
    
    @objc private func addUserDataText(button: UIButton) {
        
    //    userDataButtonInfo = button
      //  customField.showBulletin(above: self)
        
    }
    
    private func addFavoritePerson(isFavoritePerson: IsFavoriteEnum) {

        switch isFavoritePerson {
        case .no:
            isFavorite = .yes
            favoritesBtn.setImage(UIImage(named: "starFilled"), for: .normal)
            favoritesLbl.text = "Remove from favorites"
        case .yes:
            isFavorite = .no
            favoritesBtn.setImage(UIImage(named: "starUnfilled"), for: .normal)
            favoritesLbl.text = "Add to favorites"
        }
    }
}

//MARK: Validations, Error Cards, Boards  ----------------------------------------------------------------------------

extension ProfileVC {
    
    func isEmailValid(_ email: String) -> Bool {
        
        do {
            if try NSRegularExpression(pattern: "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$", options: .caseInsensitive).firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.count)) == nil {
                return false
            }
        } catch {
            return false
        }
        return true
    }
    
    func isPhoneNumberValid(_ phoneNumber: String) -> Bool {
        
        if phoneNumber.count < 10 {
            return false
        }
        
        var number = phoneNumber
        
        number.insert("-", at: number.index(number.startIndex, offsetBy: 3))
        number.insert("-", at: number.index(number.startIndex, offsetBy: 7))

        let regex = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", regex)
        let result =  phoneTest.evaluate(with: number)
        return result
        
    }
    
    private func showIncompleteFieldsErrorCard() {
        
        let view = MessageView.viewFromNib(layout: .cardView)
        
        view.configureTheme(.error)
        
        view.configureDropShadow()
        
        view.button?.isHidden = true
        let iconText = "😕"
        view.configureContent(title: "Incomplete Fields", body: "Make sure to fill out all the information, addresses are optional.", iconText: iconText)
        SwiftMessages.show(view: view)
    }
    
    private func showIncorrectPhoneNumberErrorCard() {
        let view = MessageView.viewFromNib(layout: .cardView)
        
        view.configureTheme(.error)
        
        view.configureDropShadow()
        
        view.button?.isHidden = true
        let iconText = "📱"
        view.configureContent(title: "Incorrect Phone Number", body: "Please enter a valid 10-digit phone number.", iconText: iconText)
        SwiftMessages.show(view: view)
    }
    
    private func showIncorrectEmailFormatErrorCard() {
        let view = MessageView.viewFromNib(layout: .cardView)
        
        view.configureTheme(.error)
        
        view.configureDropShadow()
        
        view.button?.isHidden = true
        let iconText = "✉️"
        view.configureContent(title: "Incorrect Email Format", body: "Please enter a valid email address.", iconText: iconText)
        SwiftMessages.show(view: view)
    }
    
    private func dismissDatePickerBoard() {
        datePickerBulletin.dismissBulletin()
    }
    

    
    private func dismissCustomBoard() {
        customField.dismissBulletin()
    }
}

//MARK: Coredata ----------------------------------------------------------------------------

extension ProfileVC {
    
    private func saveProfile(firstName: String, lastName: String, dateOfBirth: String, phoneNumbers: [String], emails: [String], addresses: [String],fields: [FieldModel], profileImage: UIImage, isFavoritePerson: IsFavoriteEnum, completion: (_ complete: Bool) -> ()) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let person = Person(context: managedContext)
        
        let profileImageData: Data = profileImage.pngData()!
        
        var isFavoriteBool = Bool()
        
        if isFavoritePerson == .no {
            isFavoriteBool = false
        } else if isFavoritePerson == .yes {
            isFavoriteBool = true
        }
        let fieldsString =  fields.toJSONString() as! String
        person.firstName = firstName.removeWhiteSpaces()
        person.lastName = lastName.removeWhiteSpaces()
        person.dateOfBirth = dateOfBirth
        person.profileImage = profileImageData
      //person.phoneNumbers = phoneNumbers as NSObject
      //person.emails = emails as NSObject
      //person.addresses = addresses as NSObject
        person.fields = fieldsString
        person.isFavorite = isFavoriteBool
        
        do {
            try managedContext.save()
            completion(true)
            print("successfully saved person in core data")
        } catch {
            print("Could not save. \(error.localizedDescription)")
            completion(false)
        }
    }
    
    private func modifyProfileInfo(searchFirstName: String, searchLastName: String, searchDateOfBirth: String, newFirstName: String, newLastName: String, newDateOfBirth: String, newProfileImage: UIImage, newPhonenumbers: [String], newEmails: [String], newAddresses: [String], newIsFavoritePerson: Bool,fields: [FieldModel],  completion: (_ complete: Bool) -> ()) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<Person>(entityName: "Person")
        
        do {
            
            let results = try managedContext.fetch(request)
            let fieldString = fields.toJSONString()!
            if results.count > 0 {
                for result in results as [NSManagedObject] {
                    if let firstName = result.value(forKey: "firstName") as? String, let lastName = result.value(forKey: "lastName") as? String, let dateOfBirth = result.value(forKey: "dateOfBirth") as? String {
                        if firstName == searchFirstName && lastName == searchLastName && dateOfBirth == searchDateOfBirth {
                            
                            let profileImageData: Data = newProfileImage.pngData()!
                            
                            result.setValue(newFirstName.removeWhiteSpaces(), forKey: "firstName")
                            result.setValue(newLastName.removeWhiteSpaces(), forKey: "lastName")
                            result.setValue(newDateOfBirth, forKey: "dateOfBirth")
                            result.setValue(profileImageData, forKey: "profileImage")
                            result.setValue(newPhonenumbers, forKey: "phoneNumbers")
                            result.setValue(newEmails, forKey: "emails")
                            result.setValue(newAddresses, forKey: "addresses")
                            result.setValue(fieldString, forKey: "fields")
                            result.setValue(newIsFavoritePerson, forKey: "isFavorite")
                            
                            do {
                                try managedContext.save()
                                completion(true)
                            } catch {
                                print("couldn't save profile")
                                completion(false)
                            }
                        }
                    }
                }
            }
        } catch {
            print("couldn't get core data results")
        }
    }
}

//MARK: TextField ------------------------------------------------------------------------------

extension ProfileVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == dateOfBirthTextField {
            datePickerBulletin.showBulletin(above: self)
            return false
        }
        
        return true
    }
    
}

//MARK: TableView ------------------------------------------------------------------------------
extension ProfileVC : TextFieldChangeDeleget {
    func fieldTableCell(index : Int, didChange text: String) {
        fieldList[index].fieldValue = text

    }
    
    
}
extension ProfileVC : RemoveFieldDeleget{
    func removeField(index: Int) {
        fieldsArray.remove(at: index)
        fieldtableView.reloadData()
    }
    
    
}
extension ProfileVC: UITableViewDelegate, UITableViewDataSource{
    
    
    
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //    return userDataArray[3]!.count
    return fieldList.count
    }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = fieldtableView.dequeueReusableCell(withIdentifier: "FieldTableViewCell") as! FieldTableViewCell
         cell.index = indexPath.row
         cell.textFieldChangeDeleget = self
         cell.removeFieldDeleget = self
        if(!isEditable){
            if(fieldList != nil){
                  
                cell.fieldName.text =  fieldList[indexPath.row].fieldName
                cell.fieldtext.text = fieldList[indexPath.row].fieldValue
                        cell.fieldtext.isUserInteractionEnabled = false
                        cell.removeButton.isHidden = true

                        
                }
            return cell
        }
        else{
            cell.index = indexPath.row
                              cell.textFieldChangeDeleget = self
            if(fieldList != nil){
                                             
                cell.fieldName.text =  fieldList[indexPath.row].fieldName
                cell.fieldtext.text = fieldList[indexPath.row].fieldValue
                                                   cell.fieldtext.isUserInteractionEnabled = true
                                                   cell.removeButton.isHidden = true

                                                   
                                           }
                                  return cell
        }
       
         
     }
}

//MARK: Image Picker -----------------------------------------------------------------

extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] {
            selectedImageFromPicker = editedImage as? UIImage
            
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] {
            selectedImageFromPicker = originalImage as? UIImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImg.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
}

//MARK: Email, Phone Number -----------------------------------------------------------------

extension ProfileVC: MFMailComposeViewControllerDelegate {
    
    private func sendEmail(recipient: String) {
    
       if MFMailComposeViewController.canSendMail() {
            
            let mailComposerVC = MFMailComposeViewController()
            mailComposerVC.mailComposeDelegate = self
        
            mailComposerVC.setToRecipients([recipient])
            mailComposerVC.setSubject("I want to hire Johnny Perdomo")
            mailComposerVC.setMessageBody("Johnny Perdomo is an awesome iOS developer, if I had my own tech company I would hire him on the spot. He would be the perfect candidate for the job because he’s a very skilled engineer, a talented designer, and always goes above and beyond when given tasks to do. He’s also a very productive programmer, getting more done in less time while developing safe, powerful code!", isHTML: false)
            self.present(mailComposerVC, animated: true, completion: nil)
        } else {
            showMailError()
        }
    }
    
    private func showMailError() {
        let sendMailErrorAlert = UIAlertController(title: "Could not send email", message: "Your device could not send email", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    private func makeAPhoneCall(number: String) {
        
        guard let url = URL(string: "tel://\(number)") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

//MARK: Maps -----------------------------------------------------------------

extension ProfileVC {
    
    private func openAddressInMaps(address: String) {
        
        let geoCoder = CLGeocoder()
        
        //Convert Address into GPS Coordinates
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            
            guard let placemarks = placemarks, let location = placemarks.first?.location else { return}
            
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            let regionDistance: CLLocationDistance = 10000
            let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
            let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
            let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
            let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            
            //Open Coordinates in Maps
            mapItem.name = "\(self.firstNameString)'s Address"
            mapItem.openInMaps(launchOptions: options)
        }
    }
}
