//
//  ViewController.swift
//  rememberme
//
//  Created by Vineeth Vijayan on 23/08/16.
//  Copyright © 2016 Vineeth Vijayan. All rights reserved.
//

import UIKit
import Contacts

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var userAccessGranted : Bool = false
    var dataArray : NSMutableArray?
    
    var intSelectedContacts = (first: 0, second: 0, third: 0)
    var selectedDetailContact : Data!
    
    var boolOnBoardingShown = false
    var boolAskContactsPermissionShown = false
    
    // MARK: IBOutlets
    
    @IBOutlet weak var mainStackView: UIStackView!
    
    @IBOutlet weak var firstStackView: UIStackView!
    @IBOutlet weak var secondStackView: UIStackView!
    @IBOutlet weak var thirdStackView: UIStackView!
    @IBOutlet weak var contactDetailStackView: UIStackView!
    
    @IBOutlet weak var imgFirstContactImage: UIImageView!
    @IBOutlet weak var lblFirstContactName: UILabel!
    @IBOutlet weak var lblFirstContactDetail: UILabel!
    
    @IBOutlet weak var imgSecondContactImage: UIImageView!
    @IBOutlet weak var lblSecondContactName: UILabel!
    @IBOutlet weak var lblSecondContactDetail: UILabel!
    
    @IBOutlet weak var imgThirdContactImage: UIImageView!
    @IBOutlet weak var lblThirdContactName: UILabel!
    @IBOutlet weak var lblThirdContactDetail: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    // Contact Details
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        checkIfUserAccessGranted()
        
        var swipe = UISwipeGestureRecognizer(target: self, action: #selector(MainViewController.viewSwiped))
        swipe.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipe)
        
        swipe = UISwipeGestureRecognizer(target: self, action: #selector(MainViewController.viewSwiped))
        swipe.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipe)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(MainViewController.firstStackViewTapped))
        self.firstStackView.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(MainViewController.secondStackViewTapped))
        self.secondStackView.addGestureRecognizer(tap2)
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(MainViewController.thirdStackViewTapped))
        self.thirdStackView.addGestureRecognizer(tap3)
        
        self.contactDetailStackView.isHidden = true
        
        self.tableView.separatorColor = UIColor.clear
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
//        if !boolOnBoardingShown {
//            let onBoarding = self.storyboard?.instantiateViewController(withIdentifier: "OnBoardingViewController") as! OnBoardingViewController
//            self.present(onBoarding, animated: true, completion: {
//                self.boolOnBoardingShown = true
//            })
//        }
//        
//        if !boolAskContactsPermissionShown {
//            let askContactsPermission = self.storyboard?.instantiateViewController(withIdentifier: "PermissionViewController") as! PermissionViewController
//            self.present(askContactsPermission, animated: true, completion: {
//                self.boolAskContactsPermissionShown = true
//            })
//        }
        
        if userAccessGranted {
        
            fetchContacts()
        
            loadContacts()
        }
        
        
        loadBackGroundColor()
        
        let borderColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
        let borderWidth:CGFloat = 0
        
        imgFirstContactImage.layer.cornerRadius = imgFirstContactImage.layer.frame.height / 4
        imgFirstContactImage.layer.borderWidth = borderWidth
        imgFirstContactImage.layer.borderColor = borderColor
        imgFirstContactImage.clipsToBounds = true
        
        imgSecondContactImage.layer.cornerRadius = imgSecondContactImage.layer.frame.height / 4
        imgSecondContactImage.layer.borderWidth = borderWidth
        imgSecondContactImage.layer.borderColor = borderColor
        imgSecondContactImage.clipsToBounds = true
        
        imgThirdContactImage.layer.cornerRadius = imgThirdContactImage.layer.frame.height / 4
        imgThirdContactImage.layer.borderWidth = borderWidth
        imgThirdContactImage.layer.borderColor = borderColor
        imgThirdContactImage.clipsToBounds = true

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        if event?.subtype == UIEventSubtype.motionShake {
            loadContacts()
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedDetailContact.contactDetails[indexPath.row].type == ContactDetailType.Phone {
            if let url = NSURL(string: "tel://\(selectedDetailContact.contactDetails[indexPath.row].value)") {
                UIApplication.shared.openURL(url as URL)
            }
        }
        else {
            
            let email = selectedDetailContact.contactDetails[indexPath.row].value
            let subject = "Remember me?".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            let body = "Remembering your through this amazing app Remember me?".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let url = URL(string: "mailto:\(email)?subject=\(subject!)&body=\(body!)")
            UIApplication.shared.openURL(url!)
            
        }
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
                var detail = " "
                if contact.givenName != "" {
                    name = contact.givenName
                    if contact.middleName  != "" {
                        name += " " + contact.middleName
                    }
                    if contact.organizationName != "" {
                        detail = contact.organizationName
                    }
                }
                
            let data = Data(name: name, detail: detail, image: userImage, contact: contact)
                self.dataArray?.add(data)
                
            }
        } catch let err{
            print(err)
            
        }
        
        print(dataArray?.count)
        
        //self.tableView.reloadData()
        
    }
    
    //MARK: Custom Functions
    
    func viewSwiped() {
        loadContacts()
        loadContactDetails()
    }

    func loadContacts(){
        intSelectedContacts = (Int.random(lower: 0, ((dataArray?.count)! - 1) ), Int.random(lower: 0, ((dataArray?.count)! - 1) ), Int.random(lower: 0, ((dataArray?.count)! - 1) ))
        
//        imgFirstContactImage.image = (dataArray?[intSelectedContacts.first] as! Data).image
        imgFirstContactImage.setImage((dataArray?[intSelectedContacts.first] as! Data).image, animated: true, duration: commonAnimationTime)
        lblFirstContactName.setText((dataArray?[intSelectedContacts.first] as! Data).name, animated: true, duration: commonAnimationTime)
        lblFirstContactDetail.setText((dataArray?[intSelectedContacts.first] as! Data).detail, animated: true, duration: commonAnimationTime)
        
        imgSecondContactImage.setImage((dataArray?[intSelectedContacts.second] as! Data).image, animated: true, duration: commonAnimationTime)
        lblSecondContactName.setText((dataArray?[intSelectedContacts.second] as! Data).name, animated: true, duration: commonAnimationTime)
        lblSecondContactDetail.setText((dataArray?[intSelectedContacts.second] as! Data).detail, animated: true, duration: commonAnimationTime)
        
        imgThirdContactImage.setImage((dataArray?[intSelectedContacts.third] as! Data).image, animated: true, duration: commonAnimationTime)
        lblThirdContactName.setText((dataArray?[intSelectedContacts.third] as! Data).name, animated: true, duration: commonAnimationTime)
        lblThirdContactDetail.setText((dataArray?[intSelectedContacts.third] as! Data).detail, animated: true, duration: commonAnimationTime) 
        
    }
    
    func loadBackGroundColor() {
//        
//        let gradient: CAGradientLayer = CAGradientLayer()
//        gradient.frame = view.bounds
//        
//        let c1 = UIColor(hexString: "#fceabb")!.cgColor
//        let c2 = UIColor(hexString: "#f8b500")!.cgColor
//        
//        gradient.colors = [c1, c2]
//        gradient.frame = self.view.bounds
//        
//        self.view.layer.insertSublayer(gradient, at: 0)
        self.view.backgroundColor = UIColor.green
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
