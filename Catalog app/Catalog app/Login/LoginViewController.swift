//
//  ViewController.swift
//  testTask_ProductCatalog
//
//  Created by Macbook Pro on 04.11.2021.
//

import UIKit
import NotificationCenter

class LoginViewController: UIViewController {
    
    @IBOutlet weak var passwordValidationErrorStack: UIStackView!
    @IBOutlet weak var emailValidationErrorStack: UIStackView!
    
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var emailValidationErrorsLabel: UILabel!
    @IBOutlet weak var passwordValidationErrorsLabel: UILabel!
    
//    var isHidden = false
    private var isAuthorized = false
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        emailTextField.tag = 1
        passwordTextField.tag = 2
        
        loginButton.layer.cornerRadius = 6
        skipButton.layer.cornerRadius = 6
//        skipButton.isHidden = isHidden
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        self.view.frame.origin.y = 0 - keyboardSize.height/4
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    func validateEmail(enteredEmail:String?) -> Bool {
        guard enteredEmail != nil   else {
            emailValidationErrorsLabel.text = "Please, input your e-mail"
            emailValidationErrorStack.isHidden = false
            return false
        }
        if(enteredEmail != ""){
            
            let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
            
            if(emailPredicate.evaluate(with: enteredEmail)) {
                emailValidationErrorStack.isHidden = true
                return true
            }
            else {
                emailValidationErrorsLabel.text = "Incorrect e-mail. Please, try again"
                emailValidationErrorStack.isHidden = false
            }
        }
        else {
            emailValidationErrorsLabel.text = "Please, input your e-mail"
            emailValidationErrorStack.isHidden = false
            return false
        }
        return false
    }
    
    func validatePassword(enteredPassword: String?) -> Bool {
        guard enteredPassword != nil && enteredPassword != "" else {
            passwordValidationErrorsLabel.text = "Please, input your password"
            passwordValidationErrorStack.isHidden = false
            return false
        }
        
        if  passwordTextField.text?.count ?? 0 < 4 {
            passwordValidationErrorsLabel.text = "Password must be at least 4 symbols"
            passwordValidationErrorStack.isHidden = false
            return false
        }
        passwordValidationErrorStack.isHidden = true
        return true
    }
    
    
    
    @IBAction func LoginButtonAction(_ sender: Any) {
        if emailTextField.text != "" && passwordTextField.text != "" &&  validateEmail(enteredEmail:  emailTextField.text) && validatePassword(enteredPassword: passwordTextField.text){
            Login()
        }
        else {
            passwordValidationErrorsLabel.text = "Input email and password"
            passwordValidationErrorStack.isHidden = false
            isAuthorized = false
        }
    }
    
    
    func Login(){
        if emailTextField.text == "test@gmail.com" && passwordTextField.text == "1111" {
            passwordValidationErrorStack.isHidden = true
            isAuthorized = true
            goToMainScreen()
           
        }
        else {
            passwordValidationErrorsLabel.text = "Wrong password or email"
            passwordValidationErrorStack.isHidden = false
        }
    }
    
    
   
    func goToMainScreen() {
        if isAuthorized == true {
            let storyboard = UIStoryboard(name: "Catalog", bundle: nil)
            let secondVC = storyboard.instantiateViewController(identifier: "tabBar")
            self.navigationController?.pushViewController(secondVC, animated: true)
        }

    }
}
extension LoginViewController: UITextFieldDelegate {
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField.tag {
        
        case 1:
            validateEmail(enteredEmail:  emailTextField.text)
        case 2:
            validatePassword(enteredPassword: passwordTextField.text)
            
        default: break
        }
        
    }
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
