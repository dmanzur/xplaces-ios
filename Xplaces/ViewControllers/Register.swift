//
//  Register.swift
//  Explaces
//
//  Created by Danielle Glazer on 17/09/2018.
//  Copyright © 2018 Dror manzur. All rights reserved.
//

import UIKit



class Register: UIViewController,UITextFieldDelegate {
    

    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var retypedPasswordTextField: UITextField!
    
    @IBOutlet weak var registerBtnOutlet: UIButton!
    
     let myActivityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        // Do any additional setup after loading the view.
    }
    
    private func initView(){
        self.registerBtnOutlet.layer.cornerRadius = 20
        self.registerBtnOutlet.clipsToBounds = true
        
        self.nameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.retypedPasswordTextField.delegate = self
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.nameTextField {
            self.emailTextField.becomeFirstResponder()
        } else if textField == self.emailTextField {
            self.passwordTextField.becomeFirstResponder()
        }  else if textField == self.passwordTextField {
            self.retypedPasswordTextField.becomeFirstResponder()
        }  else if textField == self.retypedPasswordTextField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    private func isValidInput()->Bool {
        
        var isValidInput = true
        let userName = self.nameTextField.text!
        let email = self.emailTextField.text!
        let password = self.passwordTextField.text!
        let retypePassword = self.retypedPasswordTextField.text!
        
        if(userName.isEmpty || email.isEmpty ||  password.isEmpty || retypePassword.isEmpty){
            Utils.presentAlert(title:"Missing field error",msg: "All fields are required",vc:self)
            isValidInput = false
        }
            
        else if(!email.isValidEmail){
            Utils.presentAlert(title:"Invalid email error",msg: "Invalid email, please try again",vc:self)
            isValidInput = false
        }
        else if(password != retypePassword){
            Utils.presentAlert(title:"Passwords matching error",msg: "Passwords do not match",vc:self)
            isValidInput = false
        }
            
        else if(!password.isValidPassword){
            Utils.presentAlert(title:"Passwords characters length error",msg: "Passwords must contain at least 6 charachters",vc:self)
            isValidInput = false
        }
        
        return isValidInput
    }
    
    @IBAction func registerBtn(_ sender: Any) {
        
        if self.isValidInput() {
            
            let userName = self.nameTextField.text!
            let email = self.emailTextField.text!
            let password = self.passwordTextField.text!
            
            self.myActivityIndicator.create(vc: self)
            self.myActivityIndicator.startAnimating()
            UserService.sharedInstance.register(name: userName, email: email, password: password,callback: { (user) in
                DispatchQueue.main.async {
                    self.myActivityIndicator.stopAnimating()
                    if user != nil {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        Utils.presentAlert(title:"Register faild",msg: "Email or password cant be used",vc:self)
                    }
                }
            })
        }
    }
    
}
