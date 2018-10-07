//
//  Login.swift
//  Explaces
//
//  Created by Danielle Glazer on 17/09/2018.
//  Copyright © 2018 Dror manzur. All rights reserved.
//

import UIKit



class Login: UIViewController ,UITextFieldDelegate {
    
    let myActivityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginBtnOutlet: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        
        // Do any additional setup after loading the view.
    }
    
    private func initView(){
        
        self.loginBtnOutlet.layer.cornerRadius = 20
        self.loginBtnOutlet.clipsToBounds = true
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTextField {
            self.passwordTextField.becomeFirstResponder()
        } else if textField == self.passwordTextField {
            textField.resignFirstResponder()
        }
        return true
    }
    

    
    @IBAction func loginBtn(_ sender: Any) {
        if isValidInput() {
            let email = self.emailTextField.text!
            let password = self.passwordTextField.text!
            self.myActivityIndicator.create(vc: self)
            self.myActivityIndicator.startAnimating()
            UserService.sharedInstance.login(email: email, password: password) { (user) in
                DispatchQueue.main.async {
                    self.myActivityIndicator.stopAnimating()
                    if user != nil {
                        self.performSegue(withIdentifier: "unwindToStart", sender: self)
                    } else {
                        print("user is nil")
                        Utils.presentAlert(title:"Login faild",msg: "Email or password are incorrect",vc:self)
                    }
                }
            }
        }
    }
    
    private func isValidInput() -> Bool {
        
        var isValidInput = true
        let email = self.emailTextField.text!
        let password = self.passwordTextField.text!
        
        if (password.isEmpty || email.isEmpty) {
            Utils.presentAlert(title:"Missing input error",msg: "All fields are required",vc:self)
            isValidInput = false
        }
        else if !email.isValidEmail {
            Utils.presentAlert(title:"Invalid Email",msg: "Retype email",vc:self)
            isValidInput = false
        }
        else if !password.isValidPassword {
            Utils.presentAlert(title:"Invalid password",msg: "Password must contains at least 6 characters",vc:self)
            isValidInput = false
        }
        
        return isValidInput
    }
    
    
}
