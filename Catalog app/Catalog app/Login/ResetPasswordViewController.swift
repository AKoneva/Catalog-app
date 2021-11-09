//
//  ResetPasswordViewController.swift
//  testTask_ProductCatalog
//
//  Created by Macbook Pro on 04.11.2021.
//

import UIKit
import CoreData

class ResetPasswordViewController: UIViewController {
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var emailValidationErrorStack: UIStackView!
    @IBOutlet weak var emailValidationErrorLabel: UILabel!
    @IBOutlet weak var userEmailTextField: UITextField!
    
    
    var user: User?
    let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        userEmailTextField.delegate = self
        resetButton.layer.cornerRadius = 6
    }
    
    
    //MARK:- Validation
    
    func validateEmail(enteredEmail:String?) -> Bool {
        guard enteredEmail != nil else {
            emailValidationErrorLabel.text = "Please, input your e-mail"
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
                emailValidationErrorLabel.text = "Incorrect e-mail. Please, try again"
                emailValidationErrorStack.isHidden = false
            }
        }
        else {
            emailValidationErrorLabel.text = "Please, input your e-mail"
            emailValidationErrorStack.isHidden = false
            return false
            
        }
        return false
    }
    
    
    //MARK:- Buttons action
    
    @IBAction func resetPasswordButtonTapped(_ sender: Any) {
        if validateEmail(enteredEmail: userEmailTextField.text) {
            user?.password = "1111"
            do {
                try context.save()
            }
            catch {
                showAlert(title: "Warning", text: "Can`t save data. Please, try again later. ")
            }
            showAlert(title: "Successfully", text:  "We send you email with your new password. You can change it in your personal cabinet (this is stub, password is \"1111\")")
        }
        else {
            showAlert(title: "Warning", text: "Please, check your email. No such user was found")
        }
    }
    
    func showAlert(title: String, text: String) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}


//MARK:- Extensions

extension ResetPasswordViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        validateEmail(enteredEmail: userEmailTextField.text)
        
    }
}

extension ResetPasswordViewController {
    func fetchUser(){
        do{
            let request = User.fetchRequest() as  NSFetchRequest<User>
            request.predicate = NSPredicate(format: "email CONTAINS %@", userEmailTextField.text!)
            self.user = try context.fetch(request).first ?? nil
        }
        catch {
            
        }
    }
}
