//
//  ChangePasswordViewController.swift
//  Catalog app
//
//  Created by Macbook Pro on 08.11.2021.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    @IBOutlet weak var newPasswordValodationErrorsStack: UIStackView!
    @IBOutlet weak var newPasswordValisationErrorsLabel: UILabel!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordValidationErrorsStack: UIStackView!
    @IBOutlet weak var confirmPasswordValidationErrorsLabel: UILabel!
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var changePasswordButton: UIButton!
    
    var user: User?
    let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        configureView()
    }
    
    
    //MARK:- Configuration
    
    func configureView() {
        changePasswordButton.layer.cornerRadius = 5
        newPasswordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        newPasswordTextField.tag = 1
        confirmPasswordTextField.tag = 2
        
    }
    
    
    //MARK:- Validation
    
    func validatePassword(enteredPassword: String?) -> Bool {
        guard enteredPassword != nil && enteredPassword != "" else {
            newPasswordValisationErrorsLabel.text = "Please, input your password"
            newPasswordValodationErrorsStack.isHidden = false
            
            return false
        }
        if  enteredPassword?.count ?? 0 < 4 {
            newPasswordValisationErrorsLabel.text = "Password must be at least 4 symbols"
            newPasswordValodationErrorsStack.isHidden = false
            
            return false
        } else {
            return true
        }
    }
    
    func isPasswordsFit(password:String?,confirmPassword:String?) -> Bool {
        guard password != nil && confirmPassword != nil else {
            confirmPasswordValidationErrorsLabel.text = "Please, input your password"
            confirmPasswordValidationErrorsStack.isHidden = false
            return false
        }
        
        if password == confirmPassword {
            return true
        } else {
            confirmPasswordValidationErrorsLabel.text = "Passwords don`t match"
            confirmPasswordValidationErrorsStack.isHidden = false
            return false
            
        }
    }
    func checkData() -> Bool {
        if  newPasswordValodationErrorsStack.isHidden == false || confirmPasswordValidationErrorsStack.isHidden ==  false {
            showAlert(title: "Warning", text: "Please, check if the data is correct")
            return false
        } else  if newPasswordTextField.text == nil || confirmPasswordTextField.text == nil || newPasswordTextField.text == "" || confirmPasswordTextField.text == "" {
            showAlert(title: "Warning", text: "Please, fill data to create an account")
            return false
        } else {
            return true
        }
        
    }
    
    
    //MARK:- Buttons action
    
    @IBAction func changePasswordButtonTapped(_ sender: Any) {
        if checkData() {
            user?.password = newPasswordTextField.text
            do {
                try context.save()
            }
            catch {
                showAlert(title: "Warning", text: "Can`t save data. Please, try again later. ")
            }
            showAlert(title: "Succsess", text: "Your password succsesfully changed")
            self.dismiss(animated: true)
            
        }
    }
    
    
    func showAlert(title: String, text: String) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
}


//MARK:- Extensions

extension ChangePasswordViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 1:
            if validatePassword(enteredPassword: newPasswordTextField.text) {
                newPasswordValodationErrorsStack.isHidden = true
            }
        case 2:
            if isPasswordsFit(password: newPasswordTextField.text, confirmPassword: confirmPasswordTextField.text) {
                confirmPasswordValidationErrorsStack.isHidden = true
            }
        default: break
        }
    }
    
}
