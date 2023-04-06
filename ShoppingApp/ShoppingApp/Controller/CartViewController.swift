//
//  CartViewController.swift
//  ShoppingApp
//
//  Created by Namik Karabiyik on 5.03.2023.
//

import UIKit

class CartViewController: UIViewController {

    @IBOutlet weak var tableViewCart: UITableView! {
        didSet {
            tableViewCart.delegate = self
            tableViewCart.dataSource = self
            tableViewCart.backgroundColor = .white.withAlphaComponent(0.5)
        }
    }
    
    @IBOutlet weak var viewStickyArea: UIView! {
        didSet {
            viewStickyArea.backgroundColor = .white.withAlphaComponent(0.8)
        }
    }
    
    @IBOutlet weak var btnStickyCheckout: UIButton! {
        didSet {
            btnStickyCheckout.setTitle("Ödeme Yap", for: .normal)
            btnStickyCheckout.backgroundColor = .purple
            btnStickyCheckout.setTitleColor(.white, for: .normal)
            btnStickyCheckout.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var lblStickyTotal: UILabel! {
        didSet {
            lblStickyTotal.text = "\(cartViewModel.getTotalPrice().round(to: 2)) TL"
        }
    }
    let cartViewModel = CartViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        registerCell()
        tableViewCart.rowHeight = 200
        self.title = "Ödeme Ekranı"
    }
    override func viewWillAppear(_ animated: Bool) {
        cartViewModel.getCartProducts()
        tableViewCart.reloadData()
    }
    
    
    func registerCell() {
        let productCell = UINib(nibName: "ProductCell",
                                    bundle: nil)
          self.tableViewCart.register(productCell,
                                  forCellReuseIdentifier: "ProductCell")
    }
    
    @IBAction func btnStickyPayAction(_ sender: UIButton) {
        Helper.shared.showAlert(title: "Bilgilendirme", message: "Satın alım işlemi tamamlansın mı \(cartViewModel.getTotalPrice().round(to: 2)) ? ", viewController: self) {
            self.cartViewModel.resetCart()
            self.navigationController?.popToRootViewController(animated: true)
        } alertActionDecline: {
            
        }

        
    }
    
    
    
}
extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard  let currentCellData = cartViewModel.getCellData(at: indexPath, from: cartViewModel.products) else {return}
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
         let detailVC = storyBoard.instantiateViewController(withIdentifier: "DetailPageViewController") as! DetailPageViewController
        detailVC.detailPageVM.product = currentCellData
        detailVC.delegate = self
         self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
}
extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartViewModel.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell") as? ProductCell {
            guard let product = cartViewModel.getCellData(at: indexPath, from: cartViewModel.products) else {return BaseTableViewCell()}
            cell.productCellVm = product
            cell.selectionStyle = .none
               return cell
           }
           
           return BaseTableViewCell()
    }
}


extension CartViewController: DetailPageDelegate {
    func didUpdateCart() {
        lblStickyTotal.text = "\(cartViewModel.getTotalPrice().round(to: 2)) TL"
        tableViewCart.reloadData()
        
        if cartViewModel.getCart().count == 0 {
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    
}
