//
//  PerconalCabinetViewController.swift
//  testTask_ProductCatalog
//
//  Created by Macbook Pro on 05.11.2021.
//

import UIKit
import NotificationCenter

class ProfileViewController: UIViewController{
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var emailValidationErrorsLabel: UILabel!
    @IBOutlet weak var nameValidationErrorsLabel: UILabel!
    @IBOutlet weak var nameValidationErrorStack: UIStackView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var saveValidationErrorsLabel: UILabel!
    @IBOutlet weak var saveValidationErrorsStack: UIStackView!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var emailValidationErrorStack: UIStackView!
    @IBOutlet weak var editeProfileButton: UIButton!
    @IBOutlet weak var numberOfCommentsLabel: UILabel!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var editEmailTextField: UITextField!
    @IBOutlet weak var editNameTextField: UITextField!
    @IBOutlet weak var editPhotoButton: UIButton!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    
    private var imagePicker = UIImagePickerController()
    var user: User?
    let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        print("##", user)
        configureView()
    }
    
    func configureView(){
        

        logOutButton.layer.cornerRadius = 5
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width/2
        avatarImageView.layer.borderWidth = 5
        avatarImageView.layer.borderColor = #colorLiteral(red: 0.9764705882, green: 0.968627451, blue: 0.9137254902, alpha: 1)
        
        editPhotoButton.layer.cornerRadius = 5
        changePasswordButton.layer.cornerRadius = 5
        saveButton.layer.cornerRadius = 5
        
        editEmailTextField.delegate = self
        editNameTextField.delegate = self
        editNameTextField.tag = 1
        editEmailTextField.tag = 2
        
        if user != nil {
            let defaultImage = UIImage(named: "noPhotoIcon")!.pngData()
            avatarImageView.image = UIImage(data: (user?.image ?? defaultImage)!)
            nameLabel.text = user?.name
            numberOfCommentsLabel.text = String(user?.commentsCount ?? 0)
            emailLabel.text = user?.email
        }
        else {
            avatarImageView.image  = UIImage(named: "noPhotoIcon")
            nameLabel.text = "Unknown"
            numberOfCommentsLabel.text = "0"
            emailLabel.text = ""
            changePasswordButton.isHidden = true
            editeProfileButton.isHidden = true
            logOutButton.setTitle("Log in", for: .normal)
        }
    }
    
    
    @IBAction func editProfileButtonTapped(_ sender: Any) {
        editNameTextField.text = nameLabel.text
        editEmailTextField.text = emailLabel.text
        editView.isHidden = false
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if checkData() {
            user?.name = editNameTextField.text
            user?.email = editEmailTextField.text
            user?.image = avatarImageView.image!.jpegData(compressionQuality: 1.0)

            do {
                try context.save()
            }
            catch {
                showAlert(title: "Warning", text: "Can`t save data. Please, try again later. ")
            }
            editView.isHidden = true
        }
        
        
    }
    
    @IBAction func editPhotoButtonTapped(_ sender: Any) {
        openImagePicker()
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        user = nil
        showLogin()
    }
    
    func showLogin()  {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: "login")
        
        secondVC.modalPresentationStyle = .fullScreen
        secondVC.modalTransitionStyle = .crossDissolve
        
        present(secondVC, animated: true, completion: nil)
    }
    
    func showAlert(title: String, text: String) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y = 0 - 150
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    func validateEmail(enteredEmail: String?) -> Bool {
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
    
    func validateName(name: String?) -> Bool {
        guard name != nil   else {
            nameValidationErrorsLabel.text = "Please, input your name"
            nameValidationErrorStack.isHidden = false
            return false
        }
        if name!.count  > 2 {
            nameValidationErrorStack.isHidden = true
            return true
        } else {
            nameValidationErrorsLabel.text = "Input full name,please"
            nameValidationErrorStack.isHidden = false
            return false
        }
        
    }
    func checkData() -> Bool {
        if nameValidationErrorStack.isHidden == true && emailValidationErrorStack.isHidden == true  {
            if !(editNameTextField.text?.isEmpty ?? true) && !(editEmailTextField.text?.isEmpty ?? true) {
                nameLabel.text = editNameTextField.text
                emailLabel.text = editEmailTextField.text
                saveValidationErrorsStack.isHidden = true
            }
            
            return true
        }
        else if editNameTextField.text == "" || editNameTextField.text == nil || editEmailTextField.text == "" || editEmailTextField.text == nil {
            saveValidationErrorsLabel.text = "Please, cheak your data. Unable to save."
            saveValidationErrorsStack.isHidden = false
            
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changePassword" {
            let nextVC = segue.destination as! ChangePasswordViewController
                nextVC.user = user
            
        }
    }
    
}

extension ProfileViewController: UITextFieldDelegate {
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField.tag {
        
        case 1:
            validateName(name: editNameTextField.text)
        case 2:
            validateEmail(enteredEmail:  editEmailTextField.text)
            
        default: break
        }
        
    }
}
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    func openImagePicker() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[.originalImage] as? UIImage {
            avatarImageView.image = img
            self.dismiss(animated: true)
    }
    
}
}
