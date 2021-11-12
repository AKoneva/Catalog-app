//
//  TableViewCell.swift
//  testTask_ProductCatalog
//
//  Created by Macbook Pro on 05.11.2021.
//

import UIKit
import Cosmos

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var ratingControl: CosmosView!
    @IBOutlet weak var priductDescriptionLabel: UILabel!
    
    private var rating = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productImageView.layer.cornerRadius = 5
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func configureWithData(data: Products?) {
        productNameLabel.text = data?.name
        priductDescriptionLabel.text = data?.discription
        productImageView.image = UIImage(named: data?.image ?? "")
        ratingControl.rating = getRating(data: data)
        
    }
    
    func getRating(data: Products?) -> Double {
        let comments: [Comments] = data?.comments?.allObjects as! [Comments]
        print(comments)
        if !comments.isEmpty {
            for comment in comments {
                rating = rating + comment.rate
            }
            let result = rating/Double(comments.count)
            rating = 0
            return result
        } else {
            return 0
        }
    }
    
}
