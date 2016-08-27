//
//  ViewController.swift
//  rememberme
//
//  Created by Vineeth Vijayan on 23/08/16.
//  Copyright © 2016 Vineeth Vijayan. All rights reserved.
//

import UIKit
import Contacts

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var userAccessGranted : Bool = false
    var dataArray : NSMutableArray?
    
    var intSelectedContacts = (first: 0, second: 0, third: 0)
    var selectedDetailContact : Data!
    
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
    @IBOutlet weak var tableView: UITableView!
    
    // Contact Details
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        checkIfUserAccessGranted()
        
        fetchContacts()
        
        loadContacts()
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.viewSwiped))
        self.view.addGestureRecognizer(swipe)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(ViewController.firstStackViewTapped))
        self.firstStackView.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(ViewController.secondStackViewTapped))
        self.secondStackView.addGestureRecognizer(tap2)
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(ViewController.thirdStackViewTapped))
        self.thirdStackView.addGestureRecognizer(tap3)
        
        self.contactDetailStackView.isHidden = true
        
        self.tableView.separatorColor = UIColor.clear
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        loadBackGroundColor()
        
        let borderColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
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
    
    // MARK: Table View Functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedDetailContact == nil {
            return 0
        }
        return selectedDetailContact.contactDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        
        cell.textLabel?.text = selectedDetailContact.contactDetails[indexPath.row].label
        cell.detailTextLabel?.text = selectedDetailContact.contactDetails[indexPath.row].value
        
        return cell
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
        
        let toFetch = [CNContactGivenNameKey, CNContactImageDataKey, CNContactFamilyNameKey, CNContactImageDataAvailableKey, CNContactPhoneNumbersKey, CNContactEmailAddressesKey, CNContactMiddleNameKey, CNContactOrganizationNameKey]
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
                    if contact.middleName  != "" {
                        name += " " + contact.middleName
                    }
                    if contact.organizationName != "" {
                        name += ", " + contact.organizationName
                    }
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
    
    func viewSwiped() {
        loadContacts()
        loadContactDetails()
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
        
        loadContactDetails()

        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    func secondStackViewTapped() {
        _ = firstStackView.isHidden.toggle()
        _ = thirdStackView.isHidden.toggle()
        
        contactDetailStackView.isHidden = !firstStackView.isHidden
        
        loadContactDetails()
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    func thirdStackViewTapped() {
        _ = firstStackView.isHidden.toggle()
        _ = secondStackView.isHidden.toggle()
        
        contactDetailStackView.isHidden = !firstStackView.isHidden
        
        loadContactDetails()
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func loadContactDetails() {
        if contactDetailStackView.isHidden {
            return
        }
        
        if !firstStackView.isHidden{
            selectedDetailContact = (dataArray?[intSelectedContacts.first] as! Data)
        }
        else if !secondStackView.isHidden{
            selectedDetailContact = (dataArray?[intSelectedContacts.second] as! Data)
        }
        else if !thirdStackView.isHidden{
            selectedDetailContact = (dataArray?[intSelectedContacts.third] as! Data)
        }
        
        tableView.reloadData()
    }
    
}

import UIKit

class Data {
    
    let name : String
    let image : UIImage
    let contact : CNContact
    
    var contactDetails : [(label: String, value: String, image: UIImage?)]
    
    init(name : String, image : UIImage, contact : CNContact) {
        self.image = image
        self.name = name
        self.contact = contact
        
        contactDetails = [(label: String, value: String, image: UIImage?)] ()
        
        if contact.phoneNumbers.count > 0 {
            for ph in contact.phoneNumbers {
                var lbl = ""
                if ph.label != nil {
                    switch ph.label! {
                    case CNLabelPhoneNumberiPhone:
                        lbl = "iPhone"
                        break
                    case CNLabelPhoneNumberMobile:
                        lbl = "Mobile"
                        break
                    case CNLabelPhoneNumberMain:
                        lbl = "Main"
                        break
                    case CNLabelPhoneNumberHomeFax:
                        lbl = "Home Fax"
                        break
                    case CNLabelPhoneNumberWorkFax:
                        lbl = "Work Fax"
                        break
                    case CNLabelPhoneNumberOtherFax:
                        lbl = "Other Fax"
                        break
                    case CNLabelPhoneNumberPager:
                        lbl = "Number Pager"
                        break
                    case CNLabelHome:
                        lbl = "Home"
                        break
                    case CNLabelWork:
                        lbl = "Work"
                        break
                    case CNLabelOther:
                        lbl = "Other"
                        break
                    default:
                        lbl = ph.label!
                        break
                    }
                }
                contactDetails.append((lbl, ph.value.stringValue, nil))
            }
        }
        if contact.emailAddresses.count > 0 {
            for em in contact.emailAddresses {
                
                var lbl = "Email"
                if em.label != nil {
                    switch em.label! {
                    case CNLabelHome:
                        lbl = "Home"
                        break
                    case CNLabelWork:
                        lbl = "Work"
                        break
                    case CNLabelOther:
                        lbl = "Other"
                        break
                    default:
                        lbl = em.label!
                        break
                    }
                }
                
                contactDetails.append((lbl, em.value as String, nil))
            }
        }
    }
    
}
