//
//  BaseViewController.swift
//  ShoppingApp
//
//  Created by Namik Karabiyik on 2.03.2023.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()

        // Do any additional setup after loading the view.
    }
   @discardableResult func setNavBar() -> UINavigationBarAppearance
    {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .purple
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        return appearance
        
    }
  

}
