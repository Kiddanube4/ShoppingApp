//
//  DetailPageViewController.swift
//  ShoppingApp
//
//  Created by Namik Karabiyik on 4.03.2023.
//

import UIKit
protocol DetailPageDelegate {
    func didUpdateCart()
}
enum DetailScreenState {
    case addingNew
    case updating
}
class DetailPageViewController: UIViewController {
    
    @IBOutlet weak var imgProduct: UIImageView!
    
    @IBOutlet weak var lblProductName: UILabel!
    
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var btnAddToCart: UIButton!
    
    @IBOutlet weak var stepperAmount: UIStepper!
    
    @IBOutlet weak var lblAmount: UILabel!
    
  
    var detailPageVM = ProductDetailVM()
    var delegate:DetailPageDelegate?
    var amount = 0
    var detailScreenState:DetailScreenState?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblProductName.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        lblProductName.textAlignment = .center
        lblProductName.numberOfLines = 0
        
        lblDescription.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        lblDescription.textAlignment = .center
        lblDescription.numberOfLines = 0
        
        lblPrice.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lblPrice.textAlignment = .center
        lblPrice.numberOfLines = 0
        
        lblAmount.textAlignment = .center
        self.title = "Ürün Detayı"
       
        stepperAmount.minimumValue = 0

    }
    
    override func viewWillAppear(_ animated: Bool) {
        let currentAmount = detailPageVM.fetchCartForItem(productId: detailPageVM.product.productId)?.amount.description
        imgProduct.image = UIImage(data: detailPageVM.product.productImageUrl ?? .init())
        lblProductName.text = detailPageVM.product.productName
        lblDescription.text = detailPageVM.product.productDescription
        lblPrice.text = " \(detailPageVM.product.productPrice) TL"
        lblAmount.text = (currentAmount == nil) ? "0" : currentAmount
        stepperAmount.value = Double(Int(detailPageVM.fetchCartForItem(productId: detailPageVM.product.productId)?.amount ?? 0))
        amount = Int(stepperAmount.value)
        if detailPageVM.fetchCartForItem(productId: detailPageVM.product.productId)?.amount ?? 0 > 0 {
            btnAddToCart.setTitle("Sepeti Güncelle", for: .normal)
            detailScreenState = .updating
        }else {
            btnAddToCart.setTitle("Sepete Ekle", for: .normal)
            detailScreenState = .addingNew
        }
        
    }
    
  
    

    @IBAction func btnAddToCartAction(_ sender: UIButton) {
        
        
        switch detailScreenState {
        case .addingNew:
            if amount == 0 {
                self.showToast(message: "Lütfen en az bir adet ekleyin", font: UIFont.systemFont(ofSize: 12))
                return
            }
            detailPageVM.updateCart(amount: Int32(amount),
                                    productId: detailPageVM.product.productId,
                                    productPrice: detailPageVM.product.productPrice)
            delegate?.didUpdateCart()
        case .updating:
            detailPageVM.updateCart(amount: Int32(amount),
                                    productId: detailPageVM.product.productId,
                                    productPrice: detailPageVM.product.productPrice)
            delegate?.didUpdateCart()

        case .none:
            break
        }
       
       
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func stepperAmountAction(_ sender: UIStepper) {
        amount = Int(stepperAmount.value)
        lblAmount.text = "\(amount)"
        
    }
    
}

