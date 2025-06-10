//
//  Exstention+UIController.swift
//  ChatApp
//
//  Created by Алеся Афанасенкова on 10.06.2025.
//

import Foundation
import UIKit

extension UIViewController {
    
    func presentErrorAlert(title: String, message: String) {
        let arert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        arert.addAction(okAction)
        present(arert, animated: true)
    }
}
