//
//  CategoriesViewController.swift
//  testTask_ProductCatalog
//
//  Created by Macbook Pro on 05.11.2021.
//

import UIKit
import CoreData

class CategoriesViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private var refreshControl: UIRefreshControl!
    var user: User?
    private var data: [Products]?
    private var filteredData = [String]()
    var cateroryArray = [String]()
    let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        hideKeyboardWhenTappedAround()
        configureTableView()
        
        print("## categori#",user)
    }
    func configureView(){
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = #colorLiteral(red: 0.3182727098, green: 0.5263802409, blue: 0.4970731735, alpha: 1)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
                
        searchBar.delegate = self
        
        fetchProductsWithCategories()
        cateroryArray = Array(getCategoies())
        filteredData = cateroryArray
    }
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 95
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.refreshControl = refreshControl
    }
    
    @objc func refresh(_ sender: Any) {
    
        tableView.reloadData()
        refreshControl.endRefreshing()
       
    }

    func getCategoies() -> Set<String>{
        for product in data! {
            cateroryArray.append(product.category!)
        }
        print(cateroryArray)
        return Set(cateroryArray)
    }

  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? CategoryTableViewCell {
            let indexPath = cell.tag
            if let nextViewController = segue.destination as? HomeViewController {
                let nextVC = segue.destination as! HomeViewController
                nextVC.user = user
                nextVC.state = .categoryProducts
                nextVC.currentCategory = filteredData[indexPath]
            }
        }
        
        
    }
  

}
extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "category") as! CategoryTableViewCell
        cell.categoryNameLabel.text = filteredData[indexPath.row]
        cell.tag = indexPath.row
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension CategoriesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? cateroryArray : cateroryArray.filter { $0.lowercased().contains(searchText.lowercased())  }
        tableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
        {
            self.searchBar.endEditing(true)
        }
}
extension CategoriesViewController {
    func fetchProductsWithCategories(){
        do{
            let request = Products.fetchRequest() as  NSFetchRequest<Products>
            
            self.data = try context.fetch(request)
        }
        catch {
            
        }
    }
}

