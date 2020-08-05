//
//  Extensions.swift
//  LSCase-Burak
//
//  Created by Burak Donat on 5.08.2020.
//  Copyright © 2020 Burak Donat. All rights reserved.
//

import UIKit

extension UIViewController{
     func displayAlert() {
        let alert = UIAlertController(title: "Ops", message: "There is no data", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

