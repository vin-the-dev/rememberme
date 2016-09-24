//
//  ViewController.swift
//  rememberme
//
//  Created by Vineeth Vijayan on 23/08/16.
//  Copyright © 2016 Vineeth Vijayan. All rights reserved.
//

import UIKit
import Contacts
import paper_onboarding

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PaperOnboardingDataSource {
    
    let onboarding = PaperOnboarding(itemsCount: 3)
    
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
    
    @IBOutlet weak var btnSkip: UIButton!
    
    // Contact Details
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        checkIfUserAccessGranted()
        
        fetchContacts()
        
        loadContacts()
        
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
        
        onboarding.dataSource = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(onboarding, belowSubview: btnSkip) //addSubview(onboarding)
        
        // add constraints
        for attribute: NSLayoutAttribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboarding,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.addConstraint(constraint)
        }
        
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
    
    // MARK: IB Actions
    
    @IBAction func btnSkipTapped(_ sender: AnyObject) {
        onboarding.removeFromSuperview()
        btnSkip.removeFromSuperview()
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
    
    //MARK: Paper On Borading
    
    func onboardingItemsCount() -> Int {
        return 3
    }
    
    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo {
        let titleFont = UIFont(name: "Nunito-Bold", size: 36.0) ?? UIFont.boldSystemFont(ofSize: 36.0)
        let descriptionFont = UIFont(name: "OpenSans-Regular", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
        
        //(imageName: String, title: String, description: String, iconName: String, color: UIColor, titleColor: UIColor, descriptionColor: UIColor, titleFont: UIFont, descriptionFont: UIFont)
        
        return [
            ("theme", "Remember Me!", "We have more than on an average of more than 500 contacts. Most of them from facebook, outlook etc. But how many of them we contact on a weekly basis. Not more have 10-20. Rest is just there in the contact list and we never know most of them. Remember Me! will select randomly set of three contacts", "", UIColor(red:0.40, green:0.56, blue:0.71, alpha:1.00), UIColor.white, UIColor.white, titleFont,descriptionFont),
            ("Contact Card", "Contacts", "Swipe Left/Right to refresh the list, You may find your old friend or an old colleague. Tap the contact and see more details. You can directlycall, sms or e-mail them for here.I bet you will find a person you long forgot if the first few swipes.Hope this will help you to get aqquiented with some one you forgot.", "", UIColor(red:0.40, green:0.69, blue:0.71, alpha:1.00), UIColor.white, UIColor.white, titleFont,descriptionFont),
            ("thank you", "Thank You", "A big shout out to you for downloading this app. Hope we help you reconnect with your loved ones and bring you good memories.", "", UIColor(red:0.61, green:0.56, blue:0.74, alpha:1.00), UIColor.white, UIColor.white, titleFont,descriptionFont)
            ][index]
    }
    
    //MARK: Custom Functions
    
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
        self.view.backgroundColor = 
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
