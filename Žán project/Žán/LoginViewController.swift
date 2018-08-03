//
//  LoginViewController.swift
//  Žán
//
//  Created by Zdeněk Pazdera on 20.05.18.
//  Copyright © 2018 Zdeněk Pazdera. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class LoginViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    @IBOutlet weak var loginBorderView: UIView!
    
    @IBOutlet weak var holdToShowPassword: UIButton!
    
    @IBAction func loginButton(_ sender: Any) {
        
        // Vezme hodnoty z textových polí
        let userName = userNameTextField.text
        let userPassword = userPasswordTextField.text
        
        // Zkontroluje jestli jsou hodnoty prázdné
        if (userName?.isEmpty)! || (userPassword?.isEmpty)!
        {
            print("User name \(String(describing: userName)) or password \(String(describing: userPassword)) is empty")
            self.errorMessageLabel.text = "Zadejte prosím přihlašovací jméno i heslo"
            return
        }
        
        
        let loginUrl = URL(string: "https://classis.cgnr.cz/api/login")!
        var request = URLRequest(url: loginUrl)
        
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = ("username=\(String(describing: userName!))" + "&" + "password=\(String(describing: userPassword!))").data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            
            if error != nil {
                DispatchQueue.main.async {
                    self.errorMessageLabel.text = "Došlo k chybě"
                }
                print("error=\(String(describing: error))")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = json {
                    
                    let accessToken = parseJSON["token"] as? String
                    let studentName = parseJSON["student"] as? String
                    
                    if (accessToken != nil)
                    {
                        print("Access Token: \(String(describing: accessToken!))")
                        print("Student name: \(String(describing: studentName!))")
                        let saveAccessToken: Bool = KeychainWrapper.standard.set(accessToken!, forKey: "accessToken")
                        let saveStudentName: Bool = KeychainWrapper.standard.set(studentName!, forKey: "studentName")
                        
                        self.setStandardDateRelatedValues()
                        
                        print("Keychains: \(saveAccessToken), \(saveStudentName)")
                    } else {
                        DispatchQueue.main.async {
                            self.errorMessageLabel.text = "Zadané přihlašovací jméno nebo heslo je nesprávné"
                        }
                        return
                    }
                    
                    DispatchQueue.main.async {
                        let homePage = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController")
                        let appDelegate = UIApplication.shared.delegate
                        appDelegate?.window??.rootViewController = homePage
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        self.errorMessageLabel.text = "Došlo k chybě"
                    }
                }
                
                
            } catch {
                
                DispatchQueue.main.async {
                    self.errorMessageLabel.text = "Nelze navázat připojení k serveru"
                }
            }
        }
        task.resume()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginBorderView.layer.borderWidth = 1.25
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        self.loginBorderView.addGestureRecognizer(tap)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(showPassword(press:)))
        holdToShowPassword.addGestureRecognizer(longPressGesture)
    }
    
    @objc func showPassword(press: UILongPressGestureRecognizer) {
        if press.state == .began {
            userPasswordTextField.isSecureTextEntry = false
        }
        if press.state == .ended {
            userPasswordTextField.isSecureTextEntry = true
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setStandardDateRelatedValues() {
        
        let dateCurrent = Date()
        
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([Calendar.Component.month, Calendar.Component.year], from: dateCurrent)
        
        if (components.month! > 8 || components.month! == 1) {
            KeychainWrapper.standard.set("1", forKey: "semester")
            KeychainWrapper.standard.set(String(components.year!), forKey: "school_year")
        } else {
            KeychainWrapper.standard.set("2", forKey: "semester")
            KeychainWrapper.standard.set(String(components.year! - 1), forKey: "school_year")
        }
    }

}
