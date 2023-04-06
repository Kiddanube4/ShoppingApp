//
//  Extensions.swift
//  ShoppingApp
//
//  Created by Namik Karabiyik on 2.03.2023.
//

import Foundation
import UIKit
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension String {
    func toData(isRaw:Bool)->Data? {
        var url = URL(string: self)
        var imgData = Data()
        let dataThread = DispatchGroup()
        dataThread.enter()
        DispatchQueue.global(qos: .userInteractive).async {
            if isRaw
            {
                url = URL(string: self.appending("?raw=true")) ?? URL(string: "conversionError")!
            }else
            {
                url = URL(string: self)  ?? URL(string: "conversionError")!
            }
            
            if let data = try? Data(contentsOf: url ?? URL(string: "")! )
            {
                imgData = data
            }
            dataThread.leave()
        }
        dataThread.wait()
        return imgData
    }
}

extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: [Iterator.Element: Bool] = [:]
        return self.filter { seen.updateValue(true, forKey: $0) == nil }
    }
}


extension UIViewController {

func showToast(message : String, font: UIFont) {

    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150  , y: self.view.frame.size.height/10, width: 300, height: 35))
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLabel.textColor = UIColor.white
    toastLabel.font = font
    toastLabel.textAlignment = .center;
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.numberOfLines = 0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    self.view.addSubview(toastLabel)
    UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
         toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
} }
