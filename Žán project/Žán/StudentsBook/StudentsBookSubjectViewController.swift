//
//  StudentsBookSubjectViewController.swift
//  Žán
//
//  Created by Zdeněk Pazdera on 13.06.18.
//  Copyright © 2018 Zdeněk Pazdera. All rights reserved.
//

import UIKit
import Foundation
import SwiftKeychainWrapper

class StudentsBookSubjectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet var evaluationTableView: UITableView!
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        waitForServerResponseForEvaluation.wait()
        waitForServerResponseForLessonDetail.wait()
        return arrayOfDescriptions.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "evaluationHeaderCell") as! LessonEvaluationTableViewCell
        
        headerCell.layer.borderWidth = 1
        
        headerCell.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        headerCell.changeFontSize(fontSize: 25)
        headerCell.displayCellContent(descriptionText: "Popis", mark: "Známka", date: "Zadáno")
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "evaluationTableViewCell", for: indexPath) as! LessonEvaluationTableViewCell
        
        cell.layer.borderWidth = 1
        
        cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.displayCellContent(descriptionText: arrayOfDescriptions[indexPath.row], mark: arrayOfMarks[indexPath.row], date: arrayOfDates[indexPath.row])
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        }
        
        return cell
    }
    
    var headerIsNotSetUp = true
    
    var arrayOfDescriptions = [String]()
    var arrayOfMarks = [String]()
    var arrayOfDates = [String]()
    
    var subjectId = String()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    @IBOutlet weak var subjectNameLabel: UILabel!
    
    @IBOutlet weak var subjectTeacherNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getLessonDetailAndEvaluationAPI()
        
        self.navigationItem.title = "Předmět"
        
        evaluationTableView?.isScrollEnabled = true
        
        sideMenu(hamburgerButton: menuButton)
        customizeNavBar()
    }
    
    //
    // API related part
    //
    
    let waitForServerResponseForEvaluation = DispatchGroup()
    let waitForServerResponseForLessonDetail = DispatchGroup()
    
    private func getLessonDetailAndEvaluationAPI() {
        
        let parameters = [
            "token": KeychainWrapper.standard.string(forKey: "accessToken"),
            "school_year": KeychainWrapper.standard.string(forKey: "school_year"),
            "semester": KeychainWrapper.standard.string(forKey: "semester"),
            "id_subject": subjectId
        ]
        
        let url = URL(string: "https://classis.cgnr.cz/api/get_lesson_info")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = "----WebKitFormBoundary7MA4YWxkTrZu0gW"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = createFormDataBody(parameters: parameters as! [String : String], boundary: boundary).data(using: String.Encoding.utf8)
        
        waitForServerResponseForEvaluation.enter()
        waitForServerResponseForLessonDetail.enter()
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil {
                print("Could not successfully perform this request. Please try again later")
                return
            }
            
            if let decodedLessonDetail = try? JSONDecoder().decode(LessonDetailDecoder.self, from: data!) {
                
                DispatchQueue.main.async {
                    self.subjectNameLabel.text = decodedLessonDetail.lesson.subject
                    self.subjectTeacherNameLabel.text = ("Vyučující: \(decodedLessonDetail.lesson.teachers[0])")
                    for teacher in decodedLessonDetail.lesson.teachers {
                        if teacher != decodedLessonDetail.lesson.teachers[0]{
                            self.subjectTeacherNameLabel.text = self.subjectTeacherNameLabel.text! + (", \(teacher)")
                        }
                    }
                }
                
                print("Lesson detail: \(decodedLessonDetail)")
                self.waitForServerResponseForLessonDetail.leave()
            } else {
                
                self.waitForServerResponseForLessonDetail.leave()
                
                DispatchQueue.main.async {
                    self.logOut()
                }
                return
            }
        }
        task.resume()
        
        let evaluationUrl = URL(string: "https://classis.cgnr.cz/api/get_evaluation")!
        var evaluationRequest = URLRequest(url: evaluationUrl)
        evaluationRequest.httpMethod = "POST"
        evaluationRequest.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        evaluationRequest.httpBody = createFormDataBody(parameters: parameters as! [String : String], boundary: boundary).data(using: String.Encoding.utf8)
        
        let evaluationTask = URLSession.shared.dataTask(with: evaluationRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil {
                print("Could not successfully perform this request. Please try again later")
                return
            }
            
            if let decodedLessonEvaluation = try? JSONDecoder().decode(LessonEvaluationDecoder.self, from: data!) {
                
                for evaluation in decodedLessonEvaluation.evaluation {
                    self.arrayOfDescriptions.append(evaluation.description)
                    self.arrayOfMarks.append(evaluation.mark)
                    self.arrayOfDates.append(evaluation.inserted)
                }
                
                print(self.arrayOfDescriptions)
                
                self.waitForServerResponseForEvaluation.leave()
            } else {
                
                self.waitForServerResponseForEvaluation.leave()
                return
            }
        }
        evaluationTask.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
