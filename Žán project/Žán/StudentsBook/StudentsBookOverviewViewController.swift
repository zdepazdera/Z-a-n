//
//  StudentsBookOverviewViewController.swift
//  Žán
//
//  Created by Zdeněk Pazdera on 28.05.18.
//  Copyright © 2018 Zdeněk Pazdera. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class StudentsBookOverviewViewController: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var arrayOfMarks = [String]()
    var arrayOfSubjects = [String]()
    var arrayOfDescriptions = [String]()
    var arrayOfDates = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getEvaluationOverviewAPI()
        
        self.navigationItem.title = "Pololetní přehled"
        
        sideMenu(hamburgerButton: menuButton)
        customizeNavBar()
    }

    
    //
    // API related part
    //
    
    let waitForServerResponse = DispatchGroup()
    
    private func getEvaluationOverviewAPI() {
        
        let url = URL(string: "https://classis.cgnr.cz/api/get_evaluation")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody =
            ("token=\(KeychainWrapper.standard.string(forKey: "accessToken")!)&school_year=\(KeychainWrapper.standard.string(forKey: "school_year")!)&semester=\(KeychainWrapper.standard.string(forKey: "semester")!)").data(using: String.Encoding.utf8)
        
        waitForServerResponse.enter()
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil {
                print("Could not successfully perform this request. Please try again later")
                return
            }
            
            if let decodedLessonDetail = try? JSONDecoder().decode(EvaluationOverviewDecoder.self, from: data!) {
                
                for evaluation in decodedLessonDetail.evaluation {
                    self.arrayOfSubjects.append(evaluation.subject)
                    self.arrayOfMarks.append(evaluation.mark)
                    self.arrayOfDescriptions.append(evaluation.description)
                    self.arrayOfDates.append(evaluation.inserted)
                }
                
                print("Evaluation Overview: \(decodedLessonDetail)")
                self.waitForServerResponse.leave()
            } else {
                
                self.waitForServerResponse.leave()
                
                DispatchQueue.main.async {
                    self.logOut()
                }
                return
            }
        }
        task.resume()
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
