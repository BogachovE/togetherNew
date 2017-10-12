//
//  Toaster.swift
//  together
//
//  Created by Евгений Богачев on 24.08.17.
//  Copyright © 2017 Attractive Products. All rights reserved.
//

import Foundation
import UIKit

class Toaster {
    static func makeToast(text: String, view: UIViewController) {
        let toastLabel = UILabel(frame: CGRect(x: view.view.frame.size.width/2 - 150, y: view.view.frame.size.height-100, width: 300, height: 35))
        toastLabel.backgroundColor = UIColor.black
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = NSTextAlignment.center;
        view.view.addSubview(toastLabel)
        toastLabel.text = text
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        UIView.animate(withDuration: 4.0, delay: 0.1, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            toastLabel.alpha = 0.0
        })
    }
}
