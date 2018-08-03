//
//  GlobalExtensions.swift
//  Žán
//
//  Created by Zdeněk Pazdera on 25.07.18.
//  Copyright © 2018 Zdeněk Pazdera. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

public extension UIViewController {
    
    func updateSegmentedControl(segmentedController: UISegmentedControl) {
        
        let currentSchoolYear = KeychainWrapper.standard.string(forKey: "school_year")
        
        if (KeychainWrapper.standard.string(forKey: "semester") == "1") {
            segmentedController.selectedSegmentIndex = 1
        } else {
            segmentedController.selectedSegmentIndex = 2
        }
        
        let previousYear = ("\(Int(currentSchoolYear!)! - 1)/\(Int(currentSchoolYear!)!)")
        let followingYear = ("\(Int(currentSchoolYear!)! + 1)/\(Int(currentSchoolYear!)! + 2)")
        
        segmentedController.setTitle(previousYear, forSegmentAt: 0)
        segmentedController.setTitle(followingYear, forSegmentAt: 3)
        
        let dateCurrent = Date()
        
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([Calendar.Component.month, Calendar.Component.year], from: dateCurrent)
        
        if (components.year! == (Int(currentSchoolYear!)! + 1)) && components.month! < 9 {
            segmentedController.setEnabled(false, forSegmentAt: 3)
        } else if (components.year! == (Int(currentSchoolYear!)! + 1)) && components.month! >= 9 {
            segmentedController.setEnabled(true, forSegmentAt: 3)
            segmentedController.setEnabled(false, forSegmentAt: 2)
        } else {
            segmentedController.setEnabled(true, forSegmentAt: 3)
            segmentedController.setEnabled(true, forSegmentAt: 2)
        }
    }
    
    func customizeNavBar() {
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1171272649, green: 0.3560636104, blue: 0.256238142, alpha: 1)
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.9803695448, blue: 0.9856239591, alpha: 1)
    }
    
    func sideMenu(hamburgerButton: UIBarButtonItem) {
        
        if revealViewController() != nil {
            
            hamburgerButton.target = revealViewController()
            hamburgerButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 260
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func logOut() {
        KeychainWrapper.standard.removeObject(forKey: "accessToken")
    
        let homePage = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = homePage
    }
    
    func createFormDataBody(parameters: [String: String], boundary: String) -> String {
        var body = ""
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            body += (boundaryPrefix)
            body += ("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body += ("\(value)\r\n")
        }
        
        body += "--\(boundary)--"
        
        return body
    }

}



