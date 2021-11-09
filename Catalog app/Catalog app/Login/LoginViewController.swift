//
//  ViewController.swift
//  testTask_ProductCatalog
//
//  Created by Macbook Pro on 04.11.2021.
//

import UIKit
import NotificationCenter
import CoreData

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
    
    let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureKeyboard()
        
    }
    
    
    //MARK:- Configuration
    
    func configureView(){
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        emailTextField.tag = 1
        passwordTextField.tag = 2
        
        loginButton.layer.cornerRadius = 6
        skipButton.layer.cornerRadius = 6
    }
    
    func configureKeyboard(){
        hideKeyboardWhenTappedAround()
        
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
    
    
    //MARK:- Validation
    
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
    
    func checkData() -> Bool {
        guard let email = emailTextField.text else {
            return false
        }
        guard let password = passwordTextField.text else {
            return false
        }
        if emailValidationErrorStack.isHidden == false || passwordValidationErrorStack.isHidden == false  {
            showAlert(title: "Warning", text: "Please, check data")
            return false
        }
        else  if emailTextField.text == nil || passwordTextField.text == nil || emailTextField.text == "" || passwordTextField.text == ""  {
            showAlert(title: "Warning", text: "Please, fill data to lohin")
            return false
        }
        else {
            return true
        }
        
    }
    
    func Login(){
        
        fetchUser()
        guard let  user = user else {
            passwordValidationErrorsLabel.text = "No such user found"
            passwordValidationErrorStack.isHidden = false
            return
        }
        
        if user.password != "" && passwordTextField.text == user.password {
            passwordValidationErrorStack.isHidden = true
            print("## logged user", user)
            performSegue(withIdentifier: "goToHomePage", sender: self)
        }
        else {
            passwordValidationErrorsLabel.text = "Wrong password or email"
            passwordValidationErrorStack.isHidden = false
        }
        
    }
    
    
    //MARK:- Buttons action
    
    @IBAction func LoginButtonAction(_ sender: Any) {
        if validateEmail(enteredEmail:  emailTextField.text) && validatePassword(enteredPassword: passwordTextField.text) {
            Login()
        }
        else {
            passwordValidationErrorsLabel.text = "Chek your email and password"
            passwordValidationErrorStack.isHidden = false
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToHomePage" {
            if checkData() {
                let navigationController = segue.destination as! UINavigationController
                let tabBarController = navigationController.topViewController as! BaseTabBarController
                tabBarController.user = self.user
            }
            else {
                return
            }
        }
        
    }
    
    func showAlert(title: String, text: String) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
}



//MARK:- Extensions

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
extension LoginViewController {
    func fetchUser(){
        do{
            let request = User.fetchRequest() as  NSFetchRequest<User>
            let filter = NSPredicate(format: "email CONTAINS %@", emailTextField.text!)
            request.predicate = filter
            self.user = try context.fetch(request).first ?? nil
        }
        catch {
            
        }
    }
}
