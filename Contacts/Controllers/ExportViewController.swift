//
//  ExportViewController.swift
//  Contacts
//
//  Created by Noban Aits on 23/2/20.
//  Copyright © 2020 Johnny Perdomo. All rights reserved.
//

import UIKit
import CoreData
class ExportViewController: UIViewController {

    
    private var personArray: [Person] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        print("Export")
        let fetchRequest = NSFetchRequest<Person>(entityName: "Person")
      
        do {
            personArray = try managedContext.fetch(fetchRequest)
            print("fetched data new")
                 
        } catch {
            print("error fetching data")
                   
        }
        
        let exportString = createExportString()
        print(exportString)
        saveAndExport(exportString: exportString)
       //  Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func createExportString() -> String {
          var fname : String?
          var lname : String?
          var mobile : NSArray?
          var email : NSArray?
          var address : NSArray?
          var fields : NSArray?
          var dob : String?
       
          
          var export : String = NSLocalizedString("First Name, Last Name, Mobile, Email, address, Date of birth, Custom Fields \n", comment: "")
         
          for (index, contacts) in personArray.enumerated() {
            
              fname = contacts.firstName
              lname = contacts.lastName
              mobile = contacts.phoneNumbers as! NSArray
              email = contacts.emails as! NSArray
              address = contacts.addresses as! NSArray
              fields = contacts.fields as! NSArray
              dob = "\(contacts.dateOfBirth)"
              //  let mobileString = (mobile as! NSArray).mutableCopy() as! NSMutableArray
              let mobileString = mobile?.componentsJoined(by: ";")
              // let emailString = String(email! as! Substring)
              let emailString = email?.componentsJoined(by: ";")
              //let addressString = String(address! as! Substring)
              let addressString = address?.componentsJoined(by: ";")
              //let fieldsString = String(fields! as! Substring)+"\n"
              let fieldsString = fields?.componentsJoined(by: ";")
              let fline =  fname! + "," + lname! + "," + mobileString! + "," + emailString! + ","
            
              let perline = fline + addressString! + "," + dob! + "," + fieldsString! + "\n"
              export += perline
              
          }
              //   print(export)
              return export
      }
      
     func saveAndExport(exportString: String) {
          let exportFilePath = NSTemporaryDirectory() + "contacts.csv"
          let exportFileURL = NSURL(fileURLWithPath: exportFilePath)
          FileManager.default.createFile(atPath: exportFilePath, contents: NSData() as Data, attributes: nil)
          var fileHandleError: NSError? = nil
          var fileHandle: FileHandle? = nil
          do {
            fileHandle = try FileHandle(forWritingTo: exportFileURL as URL)
          } catch {
              print("Error with fileHandle")
          }
          
          if fileHandle != nil {
              fileHandle!.seekToEndOfFile()
              let csvData = exportString.data(using: String.Encoding.utf8, allowLossyConversion: false)
            fileHandle!.write(csvData!)
              
              fileHandle!.closeFile()
              
              let firstActivityItem = NSURL(fileURLWithPath: exportFilePath)
              let activityViewController : UIActivityViewController = UIActivityViewController(
                  activityItems: [firstActivityItem], applicationActivities: nil)
              
              activityViewController.excludedActivityTypes = [
                UIActivity.ActivityType.assignToContact,
                UIActivity.ActivityType.saveToCameraRoll,
                UIActivity.ActivityType.postToFlickr,
                UIActivity.ActivityType.postToVimeo,
                UIActivity.ActivityType.postToTencentWeibo
              ]
              
              self.present(activityViewController, animated: true, completion: nil)
          }
      }
    
    private func fetchContacts(completion: (_ complete: Bool) -> ()) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Person>(entityName: "Person")
        
        do {
            personArray = try managedContext.fetch(fetchRequest)
            
            print("fetched data")
            
            completion(true)
        } catch {
            print("error fetching data")
            completion(false)
        }
    }
   

}
