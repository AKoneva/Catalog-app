//
//  DetailViewController.swift
//  testTask_ProductCatalog
//
//  Created by Macbook Pro on 05.11.2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var addCommentButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonBackgroundView: UIView!
    
    private var isAuthotized = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureTableView()
      
    }
    
    func configureView(){
        buttonBackgroundView.layer.cornerRadius = 8
        addCommentButton.layer.cornerRadius = 8
        
        // Apply a shadow
        addCommentButton.layer.shadowRadius = 8.0
        addCommentButton.layer.shadowOpacity = 0.10
        addCommentButton.layer.shadowColor = UIColor.black.cgColor
        addCommentButton.layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    @IBAction func addCommentButtonTapped(_ sender: Any) {
        isAuthotized ? openPopUp() : showLogin()
        
    }
    
    func openPopUp(){
        let storyboard = UIStoryboard(name: "Catalog", bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: "AddCommentPopupViewController")
        
        secondVC.modalPresentationStyle = .overFullScreen
        secondVC.modalTransitionStyle = .crossDissolve
        
        present(secondVC, animated: true, completion: nil)
    }
    func showLogin()  {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: "login")

        present(secondVC, animated: true, completion: nil)
    }
}
extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 5
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let productCell = tableView.dequeueReusableCell(withIdentifier: "productCell") as! ProductTableViewCell
            return productCell
        case 1:
            let comments = tableView.dequeueReusableCell(withIdentifier: "comments") as! CommentTableViewCell
            return comments
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 80
    }
    
}
