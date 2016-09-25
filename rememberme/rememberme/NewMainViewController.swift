//
//  NewMainViewController.swift
//  rememberme
//
//  Created by Vineeth Vijayan on 25/09/16.
//  Copyright © 2016 Vineeth Vijayan. All rights reserved.
//

import UIKit

class NewMainViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var mainStackView: UIStackView!
    
    @IBOutlet weak var firstContactView: UIView!
    
    @IBOutlet weak var secondContactView: UIView!
    
    @IBOutlet weak var thirdContactView: UIView!
    
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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
