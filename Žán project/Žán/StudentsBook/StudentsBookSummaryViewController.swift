//
//  StudentsBookSummaryViewController.swift
//  Žán
//
//  Created by Zdeněk Pazdera on 28.05.18.
//  Copyright © 2018 Zdeněk Pazdera. All rights reserved.
//

import UIKit
import Foundation
import SwiftKeychainWrapper

class StudentsBookSummaryViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var overallEvaluationTableView: UITableView!
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        waitForServerResponse.wait()
        return (arrayOfSubjects.count + 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "overallEvaluationTableViewCell", for: indexPath) as! OverallEvaluationTableViewCell
      
        
        if indexPath.row == 0 {
            cell.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            cell.changeFontSize(fontSize: 25)
            cell.displayCellContent(teacher: "Vyučující", subject: "Předmět", quarter_mark: "Čtvrtletí", semester_mark: "Pololetí")
        } else {
            cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
                cell.displayCellContent(teacher: arrayOfTeachers[indexPath.row - 1], subject: arrayOfSubjects[indexPath.row - 1], quarter_mark: arrayOfQuarterMarks[indexPath.row - 1], semester_mark: arrayOfSemesterMarks[indexPath.row - 1])
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
            }
        }
        
        return cell
    }
    
    var headerIsNotSetUp = true
    
    var arrayOfSubjects = Array<String>()
    
    var arrayOfTeachers = Array<String>()
    
    var arrayOfQuarterMarks = Array<String>()
    
    var arrayOfSemesterMarks = Array<String>()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
      
        
        getOverallEvaluationAPI()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Celkové hodnocení"
        
        overallEvaluationTableView?.isScrollEnabled = true
        
        sideMenu(hamburgerButton: menuButton)
        customizeNavBar()
    }
    
    
    
    //
    // API related part
    //
    
    let waitForServerResponse = DispatchGroup()
    
    private func getOverallEvaluationAPI() {
        
        let parameters = [
            "token": KeychainWrapper.standard.string(forKey: "accessToken"),
            "school_year": KeychainWrapper.standard.string(forKey: "school_year"),
            "semester": KeychainWrapper.standard.string(forKey: "semester")
            ]
        
        let evaluationUrl = URL(string: "https://classis.cgnr.cz/api/get_overall_evaluation")!
        var evaluationRequest = URLRequest(url: evaluationUrl)
        evaluationRequest.httpMethod = "POST"
        let boundary = "----WebKitFormBoundary7MA4YWxkTrZu0gW"
        evaluationRequest.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        evaluationRequest.httpBody = createFormDataBody(parameters: parameters as! [String : String], boundary: boundary).data(using: String.Encoding.utf8)
        
        waitForServerResponse.enter()
        
        let evaluationTask = URLSession.shared.dataTask(with: evaluationRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil {
                print("Could not successfully perform this request. Please try again later")
                return
            }
            
            if let decodedOverallEvaluation = try? JSONDecoder().decode(OverallEvaluationDecoder.self, from: data!) {
                
                for evaluation in decodedOverallEvaluation.evaluation {
                    self.arrayOfTeachers.append(evaluation.teacher)
                    self.arrayOfSubjects.append(evaluation.subject)
                    self.arrayOfQuarterMarks.append(evaluation.quarter_mark)
                    self.arrayOfSemesterMarks.append(evaluation.semester_mark)
                }
                
                print(self.arrayOfTeachers)
                
                
                self.waitForServerResponse.leave()
            } else {
                
                self.waitForServerResponse.leave()
                
                DispatchQueue.main.async {
                    self.logOut()
                }
                return
            }
        }
        evaluationTask.resume()
    }
    
}
/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */


