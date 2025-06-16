//
//  UploadViewController.swift
//  ChatApp
//
//  Created by Алеся Афанасенкова on 16.06.2025.
//

import UIKit

class UploadViewController: UIViewController {

    @IBOutlet weak var uploadAvatarLabel: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uploadAvatarLabel.textColor = UIColor.white
        uploadAvatarLabel.font = Font.body
        progressView.tintColor = UIColor.white
        progressView.trackTintColor = UIColor.lightGray
        view.backgroundColor = UIColor.white.withAlphaComponent(0)
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = view.bounds
        view.addSubview(visualEffectView)
        view.sendSubviewToBack(visualEffectView)

        
    }
    

}
