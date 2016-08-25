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
    
    // MARK: IBOutlets
    
    @IBOutlet weak var mainStackView: UIStackView!
    
    @IBOutlet weak var firstStackView: UIStackView!
    @IBOutlet weak var secondStackView: UIStackView!
    @IBOutlet weak var thirdStackView: UIStackView!
    
    @IBOutlet weak var imgFirstContactImage: UIImageView!
    @IBOutlet weak var lblFirstContactName: UILabel!
    
    @IBOutlet weak var imgSecondContactImage: UIImageView!
    @IBOutlet weak var lblSecondContactName: UILabel!
    
    @IBOutlet weak var imgThirdContactImage: UIImageView!
    @IBOutlet weak var lblThirdContactName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        checkIfUserAccessGranted()
        
        fetchContacts()
        
        loadContacts()
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.viewTapped))
        self.view.addGestureRecognizer(swipe)
        
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
//        gradient.colors = [UIColor(hexString: "#fceabb")?.cgColor, UIColor(hexString: "#f8b500")?.cgColor]
        let color1 = UIColor.orange.cgColor
        let color2 = UIColor.purple.cgColor
        gradient.colors = [color1, color2]
        
        self.view.layer.insertSublayer(gradient, at: 0)
//        self.view.backgroundColor = UIColor(hexString: "#f8b500")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let borderColor = UIColor.green.cgColor
        let borderWidth:CGFloat = 2.0
//        let shadowRadius: CGFloat = 5
//        let shadowColor = UIColor.lightGray.cgColor
        
        
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
        
        let toFetch = [CNContactGivenNameKey, CNContactImageDataKey, CNContactFamilyNameKey, CNContactImageDataAvailableKey]
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
                
                let data = Data(name: contact.givenName, image: userImage)
                self.dataArray?.add(data)
                
            }
        } catch let err{
            print(err)
            
        }
        
        print(dataArray?.count)
        
        //self.tableView.reloadData()
        
    }

    func loadContacts(){
        for i in 0..<3 {
            let randomInt = Int32.random(lower: 0, ((dataArray?.count)! - 1) )
            
            let contact = dataArray![Int(randomInt)] as! Data
            
            print(contact.name)
            
            switch i {
            case 0:
                imgFirstContactImage.image = contact.image
                lblFirstContactName.text = contact.name
            case 1:
                imgSecondContactImage.image = contact.image
                lblSecondContactName.text = contact.name
            case 2:
                imgThirdContactImage.image = contact.image
                lblThirdContactName.text = contact.name
            default:
                print("invalid case")
            }
            
        }
    }
    
    func viewTapped() {
        loadContacts()
    }
    
}

import UIKit

class Data {
    
    
    let name : String
    let image : UIImage
    
    init(name : String, image : UIImage) {
        self.image = image
        self.name = name
    }
    
}
