//
//  ViewController.swift
//  StockApp
//
//  Created by Field Employee on 12/4/20.
//

import UIKit

class ViewController: UIViewController {

    var user:String = ""
    var pass:String = ""
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signOutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.password.isSecureTextEntry = true
        let backButton = UIBarButtonItem()
        backButton.title = "Log Out"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        username.text = ""
        password.text = ""
        signInBtn.layer.cornerRadius = 10
        signOutBtn.layer.cornerRadius = 10
    }
    
    @IBAction func logIn(_ sender: UIButton) {
        self.user = self.username.text ?? ""
        self.pass = self.password.text ?? ""
        FirebaseManager.shared.login(email: self.user, password: self.pass) { result in
            if(result == "success")
            {
                let vc = self.storyboard?.instantiateViewController(identifier: "stockView") as! stockListViewController
                vc.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                let errorAlert = UIAlertController(title: "Error", message: "Incorrect Username or Password", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(errorAlert, animated:true)
            }
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        let alert = UIAlertController(title: "New User Registration", message: "Enter your information:", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "John"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Smith"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Example@gmail.com"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }
        
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak alert] (_) in
            let firstName = alert?.textFields![0]
            let lastName = alert?.textFields![1]
            let username = alert?.textFields![2]
            let password = alert?.textFields![3]
            if(username!.text == "" || password!.text == "" || firstName!.text == "" || lastName!.text == "")
            {
                let errorAlert = UIAlertController(title: "Error", message: "Insufficient Information", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(errorAlert, animated:true)
            }
            else{
                FirebaseManager.shared.checkForUser(user: username?.text ?? "") { result in
                    if(result == ""){
                        FirebaseManager.shared.registerUser(username: username!.text!, password: password!.text!, firstName: firstName!.text!, lastName: lastName!.text!)
                        let successAlert = UIAlertController(title: "Success!", message: "Account creation successful!\nPlease Log in", preferredStyle: .alert)
                        successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(successAlert, animated:true)
                    }
                    else{
                        let errorAlert = UIAlertController(title: "Error", message: "Account already exists", preferredStyle: .alert)
                        errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(errorAlert, animated:true)
                    }
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        
        self.present(alert, animated: true, completion: nil)
    }
}


