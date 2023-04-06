//
//  Helper.swift
//  ShoppingApp
//
//  Created by Namik Karabiyik on 2.03.2023.
//

import Foundation
import UIKit
class Helper {
    static let shared = Helper()
    
   private var container: UIView = UIView()
   private var loadingView: UIView = UIView()
   private var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    
    func showActivityIndicator(uiView: UIView) {
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)

        loadingView.center = uiView.center
        activityIndicator.color = UIColor(displayP3Red: 0/255, green: 0/255, blue: 0/255, alpha: 0.8)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
    
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)


        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        loadingView.addSubview(activityIndicator)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator(uiView: UIView) {
        activityIndicator.stopAnimating()
        container.removeFromSuperview()
    }
    
    
    func showAlert(title: String,
                   message: String,
                   viewController: UIViewController,
                   alertActionAccept:@escaping () -> (),
                   alertActionDecline:@escaping ()->()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Evet", style:   UIAlertAction.Style.default, handler: {_ in
            alertActionAccept()
        }))
        alert.addAction(UIAlertAction(title: "Hayır", style:   UIAlertAction.Style.default, handler: { _ in
            alertActionDecline()
        }))
        viewController.present(alert, animated: true, completion: nil)
    }
    
}
