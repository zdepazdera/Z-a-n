//
//  HomePageViewController.swift
//  Žán
//
//  Created by Zdeněk Pazdera on 20.05.18.
//  Copyright © 2018 Zdeněk Pazdera. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class HomePageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenu(hamburgerButton: menuButton)
        customizeNavBar()
        updateSegmentedControl(segmentedController: segmentedControl)
    }
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func segmentSelected(_ sender: UISegmentedControl) {
        
        let lastSelectedSegment = segmentedControl.selectedSegmentIndex
        
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            let newYear = String(Int(KeychainWrapper.standard.string(forKey: "school_year")!)! - 1)
            KeychainWrapper.standard.set(newYear, forKey: "school_year")
            
            segmentedControl.selectedSegmentIndex = lastSelectedSegment
            
        case 1:
            KeychainWrapper.standard.set("1", forKey: "semester")
            
        case 2:
            KeychainWrapper.standard.set("2", forKey: "semester")
            
        case 3:
            let newYear = String(Int(KeychainWrapper.standard.string(forKey: "school_year")!)! + 1)
            KeychainWrapper.standard.set(newYear, forKey: "school_year")
            
            segmentedControl.selectedSegmentIndex = lastSelectedSegment
            
        default:
            break
        }
        
        updateSegmentedControl(segmentedController: segmentedControl)
    }
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
    let studentName: String? = KeychainWrapper.standard.string(forKey: "studentName")
    
    @IBAction func signOutButtonPressed(_ sender: Any) {
        logOut()
    }

    
}

