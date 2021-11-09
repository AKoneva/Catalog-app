//
//  CategoriesViewController.swift
//  testTask_ProductCatalog
//
//  Created by Macbook Pro on 05.11.2021.
//

import UIKit

class CategoriesViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private var refreshControl: UIRefreshControl!
    var user: User?
    private var data = ["full", "catefory 2","generic","catefory 4","width"]
    
    private var filteredData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        configureTableView()
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = #colorLiteral(red: 0.3182727098, green: 0.5263802409, blue: 0.4970731735, alpha: 1)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        searchBar.delegate = self
        filteredData = data
        print("## categori#",user)
    }
  
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 95
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
    }
    
    @objc func refresh(_ sender: Any) {
    
        tableView.reloadData()
        refreshControl.endRefreshing()
       
    }

    

  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        let nextVC = segue.destination as! HomeViewController
        nextVC.user = user
        
    }
  

}
extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "category") as! CategoryTableViewCell
        cell.categoryNameLabel.text = filteredData[indexPath.row]
        return cell
    }
    
    
}

extension CategoriesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? data : data.filter { $0.lowercased().contains(searchText.lowercased())  }
        tableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
        {
            self.searchBar.endEditing(true)
        }
}
