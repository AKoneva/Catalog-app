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
    
    private  var user = User()
    let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureKeyboard()
    }
    
    
    //MARK:- Configuration
    
    func configureView() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        createAccountButton.layer.cornerRadius = 6
        
        emailTextField.tag = 1
        passwordTextField.tag = 2
        confirmPasswordTextField.tag = 3
    }
    
    func configureKeyboard() {
        hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y = 0 - 150
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
        
    }
    
    
    //MARK:- Validation
    
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
    
    func validatePassword(enteredPassword: String?) -> Bool {
        
        guard enteredPassword != nil && enteredPassword != "" else {
            passwordValidationLabel.text = "Please, input your password"
            passwordValidationStack.isHidden = false
            return false
        }
        
        if  enteredPassword?.count ?? 0 < 4 {
            
            passwordValidationLabel.text = "Password must be at least 4 symbols"
            passwordValidationStack.isHidden = false
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
            showAlert(title: "Warning", text: "Please, check if the data is correct")
            return false
        }
        if emailValidationErrorStack.isHidden == false || passwordValidationStack.isHidden == false || passwordValidationErrorStack.isHidden ==  false ||  switchErrorsStack.isHidden == false  {
            
            showAlert(title: "Warning", text: "Please, check if the data is correct")
            return false
        }
        else  if emailTextField.text == nil || passwordTextField.text == nil || confirmPasswordTextField.text == nil || emailTextField.text == "" || passwordTextField.text == "" || confirmPasswordTextField.text == "" {
            showAlert(title: "Warning", text: "Please, fill data to create an account")
            return false
        }
        else {
            return true
        }
        
    }
    
    
    //MARK:- Buttons action
    
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
        }
    }
    
    func createAccount(){
        guard let email = emailTextField.text else {
            return
        }
        guard let password = passwordTextField.text else {
            return
        }
        let newUser = User(context: self.context)
        newUser.email = email
        newUser.password = password
        newUser.image = UIImage(named: "noPhotoIcon")?.jpegData(compressionQuality: 1.0)
        newUser.name = "Unknown name"
        newUser.commentsCount = 0
        newUser.id = UUID()
        user = newUser
        do {
            try self.context.save()
        }
        catch {
            showAlert(title: "Warning", text: "Can`t save data. Please, try again later. ")
        }
        performSegue(withIdentifier: "goToCatalogFromSignUp", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCatalogFromSignUp" {
            let navigationController = segue.destination as! UINavigationController
            let tabBarController = navigationController.topViewController as! BaseTabBarController
            tabBarController.user = user
        }
    }
    
    func showAlert(title: String, text: String) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    
}


//MARK:- Extensions

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField.tag {
        
        case 1:
            if  validateEmail(enteredEmail:  emailTextField.text) {
                emailValidationErrorStack.isHidden = true
            }
        case 2:
            if validatePassword(enteredPassword: passwordTextField.text) {
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
