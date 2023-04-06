//
//  ProductCell.swift
//  ShoppingApp
//
//  Created by Namik Karabiyik on 2.03.2023.
//

import UIKit

class ProductCell: UITableViewCell {
    
   

    @IBOutlet weak var lblAmountInBasket: UILabel!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    var vmHelper  = ProductDetailVM()
    override func awakeFromNib() {
        super.awakeFromNib()
        print("did awake")
        
    }
    
    var productCellVm:Product? {
        didSet {
            print("current data to vm \(productCellVm)")
            
            lblProductName.text = productCellVm!.productName
            lblProductName.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            lblProductName.numberOfLines = 0
            lblDescription.numberOfLines = 0
            lblDescription.font = UIFont.systemFont(ofSize: 14)
            lblDescription.text = productCellVm!.productDescription
            lblPrice.text = "\(productCellVm!.productPrice) TL"
            guard let imageData = productCellVm?.productImageUrl else {return}
            imgProduct.image = UIImage(data: imageData)
            let cartItem =  vmHelper.fetchCartForItem(productId: productCellVm?.productId ?? 0)
            lblAmountInBasket.font = UIFont.systemFont(ofSize: 14)
            lblAmountInBasket.text = "Sepette: \(cartItem?.amount ?? 0)"
            
            
        }
    }
    
    
  

   
    
}
