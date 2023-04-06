//
//  HomePageViewController.swift
//  ShoppingApp
//
//  Created by Namik Karabiyik on 2.03.2023.
//

import UIKit

class HomePageViewController: BaseViewController {
    
    
    
    private lazy var homeViewModel:HomeViewControllerViewModel = {
        var homeViewModelData = HomeViewControllerViewModel()
        homeViewModelData.delegate = self
        return homeViewModelData
    }()
    
    @IBOutlet weak var tblProducts: UITableView! {
        didSet {
            tblProducts.delegate = self
            tblProducts.dataSource = self
            tblProducts.backgroundColor = .white.withAlphaComponent(0.5)
        }
    }
    
    @IBOutlet weak var viewStickyArea: UIView!
    
    @IBOutlet weak var btnStickyCart: UIButton! {
        didSet {
            btnStickyCart.setTitle("Sepete Git", for: .normal)
            btnStickyCart.backgroundColor = .purple
            btnStickyCart.setTitleColor(.white, for: .normal)
            btnStickyCart.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var lblStickyCartTotal: UILabel!{
        didSet {
            lblStickyCartTotal.text = "\(homeViewModel.getTotalPrice().round(to: 2)) TL"
        }
    }
    
    var containerView = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("HomePageViewController")
        homeViewModel.initProducts()
        
        
        containerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width,
                                             height: self.view.frame.height))
        
        
        self.view.addSubview(containerView)
        Helper.shared.showActivityIndicator(uiView: containerView)
        
        registerCell()
        tblProducts.rowHeight = 200
        
        self.title = "Ana Ekran"
        
    }
    override func viewWillAppear(_ animated: Bool) {
        tblProducts.reloadData()
        lblStickyCartTotal.text = "\(homeViewModel.getTotalPrice().round(to: 2)) TL"
    }
    
    func registerCell() {
        let productCell = UINib(nibName: "ProductCell",
                                bundle: nil)
        self.tblProducts.register(productCell,
                                  forCellReuseIdentifier: "ProductCell")
    }
    
    @IBAction func btnCartAction(_ sender: UIButton) {
        if homeViewModel.getCart().count == 0 {
            // show warning
            self.showToast(message: "Sepetinizde ürün olmadığı için devam edemezsiniz", font: UIFont.systemFont(ofSize: 14))
          
        }else {
            //route to cart
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let detailVC = storyBoard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

extension HomePageViewController:UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard  let currentCellData = homeViewModel.getCellData(at: indexPath, from: homeViewModel.products) else {return}
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyBoard.instantiateViewController(withIdentifier: "DetailPageViewController") as! DetailPageViewController
        detailVC.detailPageVM.product = currentCellData
        detailVC.delegate = self
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
}

extension HomePageViewController:UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell") as? ProductCell {
            guard let product = homeViewModel.getCellData(at: indexPath, from: homeViewModel.products) else {return BaseTableViewCell()}
            cell.productCellVm = product
            cell.selectionStyle = .none
            return cell
        }
        
        return BaseTableViewCell()
    }
    
    
}

extension HomePageViewController: HomeVmdelegate {
    func initDidFinish() {
        print("init success")
        containerView.removeFromSuperview()
        Helper.shared.hideActivityIndicator(uiView: containerView)
        self.homeViewModel.getProducts()
        self.tblProducts.reloadData()
        
    }
    
    func initDidfail() {
        print("init fail")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            containerView.removeFromSuperview()
            Helper.shared.hideActivityIndicator(uiView: containerView)
        }
        
        self.homeViewModel.getProducts()
        self.tblProducts.reloadData()
        
    }
}

extension HomePageViewController: DetailPageDelegate {
    func didUpdateCart() {
        lblStickyCartTotal.text = "\(homeViewModel.getTotalPrice().round(to: 2)) TL"
    }
    
    
}
