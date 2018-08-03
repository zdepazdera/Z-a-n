//
//  StudentsBookViewController.swift
//  Žán
//
//  Created by Zdeněk Pazdera on 28.05.18.
//  Copyright © 2018 Zdeněk Pazdera. All rights reserved.
//

import UIKit
import Foundation
import SwiftKeychainWrapper

class StudentsBookViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var listOfSubjectsWithId = [String:String]()
    
    var arrayOfSubjects = [String]()
    
    var subjectIdForSegue = String()
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getListOfSubjectsAPI()
        
        self.navigationItem.title = "Žákovská knížka"
        
        sideMenu(hamburgerButton: menuButton)
        customizeNavBar()
    }
    
    //
    // Collection View Set-Up
    //
    
    @IBOutlet var subjectCollectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        waitForServerResponse.wait()
        return listOfSubjectsWithId.keys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! SubjectCollectionViewCell
        
        cell.subjectButton.tag = indexPath.row
        cell.subjectButton.addTarget(self,
                                     action: #selector(passSubject),
                                     for: .touchUpInside)
        
        let i = indexPath.row
        
        cell.displayCellContent(image: #imageLiteral(resourceName: "placeholder"), title: arrayOfSubjects[i])
        
        return cell
    }
    
    @objc private func passSubject(sender: UIButton) {
        
        let subjectName = arrayOfSubjects[sender.tag]
        
        let subjectId = listOfSubjectsWithId[subjectName]
        
        subjectIdForSegue = subjectId!
        
        performSegue(withIdentifier: "showSubjectSegue", sender: self)
    }
    
    //
    // API related part
    //
    
    let waitForServerResponse = DispatchGroup()
    
    private func getListOfSubjectsAPI() {
        
        let parameters = [
            "token": KeychainWrapper.standard.string(forKey: "accessToken"),
            "school_year": KeychainWrapper.standard.string(forKey: "school_year"),
            "semester": KeychainWrapper.standard.string(forKey: "semester")
        ]
        
        let url = URL(string: "https://classis.cgnr.cz/api/get_subjects")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = "----WebKitFormBoundary7MA4YWxkTrZu0gW"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpBody = createFormDataBody(parameters: parameters as! [String : String], boundary: boundary).data(using: String.Encoding.utf8)
        
        waitForServerResponse.enter()
        
         let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil {
                print("Could not successfully perform this request. Please try again later")
                return
            }
            
            if let decodedListOfSubjects = try? JSONDecoder().decode(ListOfSubjectsDecoder.self, from: data!) {
                
                print(decodedListOfSubjects.subjects)
                
                for subject in decodedListOfSubjects.subjects {
                    self.listOfSubjectsWithId[subject.subject] = subject.id_subject
                    self.arrayOfSubjects.append(subject.subject)
                }
                
                print(self.listOfSubjectsWithId)
                
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSubjectSegue" {
            if let destinationVC = segue.destination as? StudentsBookSubjectViewController {
                destinationVC.subjectId = subjectIdForSegue
            }
        }
    }
    
}





