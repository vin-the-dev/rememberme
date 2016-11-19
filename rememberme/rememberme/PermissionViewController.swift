//
//  AskPermissionViewController.swift
//  rememberme
//
//  Created by Vineeth Vijayan on 25/09/16.
//  Copyright © 2016 Vineeth Vijayan. All rights reserved.
//

import UIKit

class PermissionViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    internal var permissionType = PermissionType.Contacts

    // MARK: IB Outlets

    @IBOutlet weak var lblMainText: UILabel!
    @IBOutlet weak var lblSubText: UILabel!
    @IBOutlet weak var lblButtonText: UILabel!
    @IBOutlet weak var imgCenterImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        switch permissionType {
        case .Notification:
            lblMainText.text = "Please let us send you notifications"
            lblSubText.text = "You can turn it of any time you want"
            lblButtonText.text = "Ok Got it."
            imgCenterImage.image = #imageLiteral(resourceName: "Notification")
            break
        default:
            lblMainText.text = "Please give us access to your Contacts"
            lblSubText.text = "We will use it show you 3 contacts per day"
            lblButtonText.text = "Ok Got it."
            imgCenterImage.image = #imageLiteral(resourceName: "Contacts")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: IB Action
    
    @IBAction func btnActionClicked(_ sender: AnyObject) {
        switch permissionType {
        case .Notification:
            print("Notification")
            break
        default:
            appDelegate.requestForAccess { (accessGranted) -> Void in}
            break
        }
        self.dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

enum PermissionType{
    case Contacts
    case Notification
}
