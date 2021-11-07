//
//  TableViewCell.swift
//  testTask_ProductCatalog
//
//  Created by Macbook Pro on 05.11.2021.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var discription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        productImageView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
