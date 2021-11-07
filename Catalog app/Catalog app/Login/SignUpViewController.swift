//
//  SignUpViewController.swift
//  testTask_ProductCatalog
//
//  Created by Macbook Pro on 04.11.2021.
//

import UIKit
import NotificationCenter

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var passwordValidationLabel: UILabel!
    @IBOutlet weak var passwordValidationStack: UIStackView!
    @IBOutlet weak var passwordValidationErrorStack: UIStackView!
    @IBOutlet weak var switchErrorsStack: UIStackView!
    @IBOutlet weak var emailValidationErrorStack: UIStackView!
    
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var isAgreedWithTermsAndPrivacyPolicy: UISwitch!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var passwordValidationErrorsLabel: UILabel!
    @IBOutlet weak var emailValidationErrorsLabel: UILabel!
    @IBOutlet weak var switchErrorsLabel: UILabel!
    
    private  var user = UserData(email: "", password: "", isAuthorized: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        createAccountButton.layer.cornerRadius = 6
        // tags
        emailTextField.tag = 1
        passwordTextField.tag = 2
        confirmPasswordTextField.tag = 3
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
//        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
//            return
//        }
        
        self.view.frame.origin.y = 0 - 150//- keyboardSize.height
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    func validateEmail(enteredEmail: String?) -> Bool {
        guard enteredEmail != nil else {
            emailValidationErrorsLabel.text = "Please, input your e-mail"
            emailValidationErrorStack.isHidden = false
            return false
        }
        if enteredEmail != "" {
            
            let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
            
            if(emailPredicate.evaluate(with: enteredEmail)) {
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
    
    func validatePassword(enteredPassword: String?, type: String) -> Bool {
        
        guard enteredPassword != nil && enteredPassword != "" else {
            if type == "pass" {
                passwordValidationLabel.text = "Please, input your password"
                passwordValidationStack.isHidden = false
            }
            else {
                passwordValidationErrorsLabel.text = "Please, input your password"
                passwordValidationErrorStack.isHidden = false
            }
            return false
        }
        
        if  passwordTextField.text?.count ?? 0 < 4 {
            if type == "pass" {
                passwordValidationLabel.text = "Password must be at least 4 symbols"
                passwordValidationStack.isHidden = false
            }
            else {
                passwordValidationErrorsLabel.text = "Password must be at least 4 symbols"
                passwordValidationErrorStack.isHidden = false
            }
            return false
        }
        else {
            return true
        }
    }
    
    func isPasswordsFit(password:String?,confirmPassword:String?) -> Bool {
        guard password != nil && confirmPassword != nil else {
            passwordValidationErrorsLabel.text = "Please, input your password"
            passwordValidationErrorStack.isHidden = false
            return false
        }
        if password == confirmPassword {
            return true
        }
        else {
            passwordValidationErrorsLabel.text = "Passwords don`t match"
            passwordValidationErrorStack.isHidden = false
            return false
            
        }
    }
    
    func checkData() -> Bool {
        
        if isAgreedWithTermsAndPrivacyPolicy.isOn {
            switchErrorsStack.isHidden = true
        }
        else {
            switchErrorsLabel.text = "You have to agree with terms and privacy policy to continue"
            switchErrorsStack.isHidden = false
            showErrorAlert(text: "Please, check if the data is correct")
            return false
        }
        if emailValidationErrorStack.isHidden == false || passwordValidationStack.isHidden == false || passwordValidationErrorStack.isHidden ==  false ||  switchErrorsStack.isHidden == false  {
            let alert = UIAlertController(title: "Error", message: "Please, check if the data is correct", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            showErrorAlert(text: "Please, check if the data is correct")
            return false
        }
        else  if emailTextField.text == nil || passwordTextField.text == nil || confirmPasswordTextField.text == nil || emailTextField.text == "" || passwordTextField.text == "" || confirmPasswordTextField.text == "" {
            showErrorAlert(text: "Please, fill data to create an account")
            return false
        }
        else {
            return true
        }
        
    }
    
    func showErrorAlert(text: String) {
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func changedSwitchState(_ sender: Any) {
        if isAgreedWithTermsAndPrivacyPolicy.isOn {
            switchErrorsStack.isHidden = true
        }
        else {
            switchErrorsStack.isHidden = false
        }
    }
    
    @IBAction func CreateAccountButtonAction(_ sender: Any) {
        if  checkData() {
            createAccount()
            goToMainScreen()
        }
        
    }
    
    
    func createAccount(){
        guard let email = emailTextField.text else {
            return
        }
        guard let password = passwordTextField.text else {
            return
        }
        self.user = UserData(email: email, password: password, isAuthorized: true)
        // add to DB
        let alert = UIAlertController(title: "Done", message: "Thank you for join us", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
        
        
    }
    
    func goToMainScreen() {
        if user.isAuthorized == true {
            let storyboard = UIStoryboard(name: "Catalog", bundle: nil)
            let secondVC = storyboard.instantiateViewController(identifier: "Home")
            show(secondVC, sender: self)
        }
        
    }
    
}
extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField.tag {
        
        case 1:
            if  validateEmail(enteredEmail:  emailTextField.text) {
                emailValidationErrorStack.isHidden = true
            }
        case 2:
            if validatePassword(enteredPassword: passwordTextField.text, type: "pass") {
                passwordValidationStack.isHidden = true
            }
        case 3:
            if isPasswordsFit(password: passwordTextField.text, confirmPassword: confirmPasswordTextField.text) {
                passwordValidationErrorStack.isHidden = true
            }
        default: break
        }
        
    }
    
}

struct UserData {
    var email: String
    var password: String
    var isAuthorized: Bool
    
}
