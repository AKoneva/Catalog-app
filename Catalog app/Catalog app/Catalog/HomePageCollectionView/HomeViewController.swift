//
//  Home1ViewController.swift
//  testTask_ProductCatalog
//
//  Created by Macbook Pro on 05.11.2021.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var refreshControl: UIRefreshControl!
    
    var data = [Product(name: "poduct 1", discription: "bla bla bla bla bla bla bla ", image: "image", category: "first"),
                Product(name: "poduct 2", discription: "bla bla bla bla bla bla bla ", image: "image", category: "first"),
                Product(name: "poduct 3", discription: "bla bla bla bla bla bla bla ", image: "image", category: "first"),
                Product(name: "poduct 4", discription: "bla44 bla bla ", image: "image", category: "first"),
                Product(name: "poduct 5", discription: "bla b5 bla bla bla ", image: "image", category: "first"),
                Product(name: "poduct 6", discription: "bla bla bla bla bla bla bla ", image: "image", category: "first"),
                Product(name: "poduct 7", discription: "bla bla 6bla bla d ", image: "image", category: "first")]
    
    var filteredData = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        collectionView.keyboardDismissMode = .onDrag
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = #colorLiteral(red: 0.3182727098, green: 0.5263802409, blue: 0.4970731735, alpha: 1)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        searchBar.delegate = self
        filteredData = data
    }
  
    @objc func refresh(_ sender: Any) {
    
        collectionView.reloadData()
        refreshControl.endRefreshing()
       
    }
  

}
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "product", for: indexPath) as! ProductCollectionViewCell
        cell.productName.text = filteredData[indexPath.row].name
        cell.productDescription.text = filteredData[indexPath.row].discription
        cell.productImage.image = UIImage(named: filteredData[indexPath.row].image)
        cell.productImage.layer.cornerRadius = 8
        
        return cell
      
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing : CGFloat = (collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 0.0
        let widthPerItem = (view.frame.width  - spacing * 2)/2
        return CGSize(width: widthPerItem, height: 300)
    }

   
    
}
extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? data : data.filter { $0.name.lowercased().contains(searchText.lowercased()) || $0.discription.lowercased().contains(searchText.lowercased())  }
        collectionView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
        {
            self.searchBar.endEditing(true)
        }
}
struct Product {
    var name: String
    var discription: String
    var image: String
    var rate: Int = 5
    var category: String
}
