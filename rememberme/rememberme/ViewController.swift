//
//  ViewController.swift
//  rememberme
//
//  Created by Vineeth Vijayan on 23/08/16.
//  Copyright © 2016 Vineeth Vijayan. All rights reserved.
//

import UIKit
import Contacts

class ViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var userAccessGranted : Bool = false
    var dataArray : NSMutableArray?
    
    var intSelectedContacts = (first: 0, second: 0, third: 0)
    
    // MARK: IBOutlets
    
    @IBOutlet weak var mainStackView: UIStackView!
    
    @IBOutlet weak var firstStackView: UIStackView!
    @IBOutlet weak var secondStackView: UIStackView!
    @IBOutlet weak var thirdStackView: UIStackView!
    @IBOutlet weak var contactDetailStackView: UIStackView!
    
    @IBOutlet weak var imgFirstContactImage: UIImageView!
    @IBOutlet weak var lblFirstContactName: UILabel!
    
    @IBOutlet weak var imgSecondContactImage: UIImageView!
    @IBOutlet weak var lblSecondContactName: UILabel!
    
    @IBOutlet weak var imgThirdContactImage: UIImageView!
    @IBOutlet weak var lblThirdContactName: UILabel!
    
    // Contact Details
    @IBOutlet weak var lblPhoneNumbers: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        checkIfUserAccessGranted()
        
        fetchContacts()
        
        loadContacts()
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.viewTapped))
        self.view.addGestureRecognizer(swipe)
        
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(ViewController.firstStackViewTapped))
        self.firstStackView.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(ViewController.secondStackViewTapped))
        self.secondStackView.addGestureRecognizer(tap2)
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(ViewController.thirdStackViewTapped))
        self.thirdStackView.addGestureRecognizer(tap3)
        
        self.contactDetailStackView.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        loadBackGroundColor()
        
        let borderColor = UIColor.lightGray.withAlphaComponent(0.8).cgColor
        let borderWidth:CGFloat = 5.0
        
        imgFirstContactImage.layer.cornerRadius = imgFirstContactImage.layer.frame.height / 2
        imgFirstContactImage.layer.borderWidth = borderWidth
        imgFirstContactImage.layer.borderColor = borderColor
        imgFirstContactImage.clipsToBounds = true
        
        imgSecondContactImage.layer.cornerRadius = imgSecondContactImage.layer.frame.height / 2
        imgSecondContactImage.layer.borderWidth = borderWidth
        imgSecondContactImage.layer.borderColor = borderColor
        imgSecondContactImage.clipsToBounds = true
        
        imgThirdContactImage.layer.cornerRadius = imgThirdContactImage.layer.frame.height / 2
        imgThirdContactImage.layer.borderWidth = borderWidth
        imgThirdContactImage.layer.borderColor = borderColor
        imgThirdContactImage.clipsToBounds = true

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Custom Functions
    
    func checkIfUserAccessGranted()
    {
        appDelegate.requestForAccess { (accessGranted) -> Void in
            if accessGranted {
                self.userAccessGranted = true;
            }else{
                self.userAccessGranted = false;
            }
        }
    }
    
    func fetchContacts()
    {
        
        dataArray = NSMutableArray()
        
        let toFetch = [CNContactGivenNameKey, CNContactImageDataKey, CNContactFamilyNameKey, CNContactImageDataAvailableKey, CNContactPhoneNumbersKey]
        let request = CNContactFetchRequest(keysToFetch: toFetch as [CNKeyDescriptor])
        
        do{
            try appDelegate.contactStore.enumerateContacts(with: request) {
                contact, stop in
//                print(contact.givenName)
//                print(contact.familyName)
//                print(contact.identifier)
                
                var userImage : UIImage;
                // See if we can get image data
                if let imageData = contact.imageData {
                    //If so create the image
                    userImage = UIImage(data: imageData)!
                }else{
                    userImage = UIImage(named: "avatar-male")!
                }
                var name = "No Name"
                if contact.givenName != "" {
                    name = contact.givenName
                }
                
                let data = Data(name: name, image: userImage, contact: contact)
                self.dataArray?.add(data)
                
            }
        } catch let err{
            print(err)
            
        }
        
        print(dataArray?.count)
        
        //self.tableView.reloadData()
        
    }

    func loadContacts(){
        intSelectedContacts = (Int.random(lower: 0, ((dataArray?.count)! - 1) ), Int.random(lower: 0, ((dataArray?.count)! - 1) ), Int.random(lower: 0, ((dataArray?.count)! - 1) ))
        
        imgFirstContactImage.image = (dataArray?[intSelectedContacts.first] as! Data).image
        lblFirstContactName.text = (dataArray?[intSelectedContacts.first] as! Data).name
        
        imgSecondContactImage.image = (dataArray?[intSelectedContacts.second] as! Data).image
        lblSecondContactName.text = (dataArray?[intSelectedContacts.second] as! Data).name
        
        imgThirdContactImage.image = (dataArray?[intSelectedContacts.third] as! Data).image
        lblThirdContactName.text = (dataArray?[intSelectedContacts.third] as! Data).name
        
    }
    
    func viewTapped() {
        loadContacts()
    }
    
    func loadBackGroundColor() {
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        
        let c1 = UIColor(hexString: "#fceabb")!.cgColor
        let c2 = UIColor(hexString: "#f8b500")!.cgColor
        
        gradient.colors = [c1, c2]
        gradient.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradient, at: 0)
        
    }
    
    func firstStackViewTapped() {
        _ = secondStackView.isHidden.toggle()
        _ = thirdStackView.isHidden.toggle()
        
        contactDetailStackView.isHidden = !secondStackView.isHidden
        
        loadContactDetails(intContact: intSelectedContacts.first)

        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    func secondStackViewTapped() {
        _ = firstStackView.isHidden.toggle()
        _ = thirdStackView.isHidden.toggle()
        
        contactDetailStackView.isHidden = !firstStackView.isHidden
        
        loadContactDetails(intContact: intSelectedContacts.second)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    func thirdStackViewTapped() {
        _ = firstStackView.isHidden.toggle()
        _ = secondStackView.isHidden.toggle()
        
        contactDetailStackView.isHidden = !firstStackView.isHidden
        
        loadContactDetails(intContact: intSelectedContacts.third)
        
        loadContactDetails(intContact: intSelectedContacts.third)
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func loadContactDetails(intContact: Int) {
        if contactDetailStackView.isHidden {
            return
        }
        let contact = (dataArray?[intContact] as! Data).contact
        if contact.phoneNumbers.count > 0 {
            lblPhoneNumbers.text = contact.phoneNumbers[0].value.stringValue
        }
    }
    
}

import UIKit

class Data {
    
    
    let name : String
    let image : UIImage
    let contact : CNContact
    
    init(name : String, image : UIImage, contact : CNContact) {
        self.image = image
        self.name = name
        self.contact = contact
    }
    
}
