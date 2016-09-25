//
//  File.swift
//  rememberme
//
//  Created by Vineeth Vijayan on 19/09/16.
//  Copyright © 2016 Vineeth Vijayan. All rights reserved.
//

import Foundation
import UIKit
import Contacts

class Data {
    
    let name : String
    let detail : String
    let image : UIImage
    let contact : CNContact
    
    var contactDetails : [(label: String, value: String, type: ContactDetailType, image: UIImage?)]
    
    init(name : String, detail: String, image : UIImage, contact : CNContact) {
        self.image = image
        self.name = name
        self.detail = detail
        self.contact = contact
        
        contactDetails = [(label: String, value: String, type: ContactDetailType, image: UIImage?)] ()
        
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
                contactDetails.append((lbl, ph.value.stringValue, ContactDetailType.Phone, nil))
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
                
                contactDetails.append((lbl, em.value as String,ContactDetailType.Email, nil))
            }
        }
    }
    
}

enum ContactDetailType {
    case Phone
    case Email
}
