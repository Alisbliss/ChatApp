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
    func showLoadingView() {
        let loadingView = LoadingView()
        view.addSubview(loadingView)
        loadingView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        loadingView.tag = 20250100
    }
    
    func removeLoadingView() {
        if let loadingView = view.viewWithTag(20250100) {
            loadingView.removeFromSuperview()
        }
    }
}
