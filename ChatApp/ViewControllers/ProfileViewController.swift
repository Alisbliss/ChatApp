//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by Алеся Афанасенкова on 15.06.2025.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avatarImageView.image = UIImage(systemName: "person.fill")
        avatarImageView.tintColor = UIColor.black
        avatarImageView.backgroundColor = UIColor.lightGray
        
        let avatarTap = UITapGestureRecognizer(target: self, action: #selector(presentAvatarOptions))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(avatarTap)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.layer.cornerRadius = 8
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
    }
    
   
    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            let authStoryboard = UIStoryboard(name: "Auth", bundle: nil)
            let signinVC = authStoryboard.instantiateViewController(withIdentifier: "SignInViewController")
            let window = UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.first { $0.isKeyWindow }
            window?.rootViewController = signinVC       } catch {
                presentErrorAlert(title: "Logout failed", message: "Something went wrong with logout. Please try again later.")
            }
    }
    
    @objc func presentAvatarOptions() {
        let avatarOptionSheet = UIAlertController(title: "Change Avatar", message: "Select an option", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.performSegue(withIdentifier: "UploadSegue", sender: nil)
        }
        let photoAction = UIAlertAction(title: "Photo", style: .default) { _ in
            self.performSegue(withIdentifier: "UploadSegue", sender: nil)
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        avatarOptionSheet.addAction(cameraAction)
        avatarOptionSheet.addAction(photoAction)
        avatarOptionSheet.addAction(deleteAction)
        avatarOptionSheet.addAction(cancelAction)
        
        present(avatarOptionSheet,animated: true)
    }
        @IBAction func logoutButtonTapped(_ sender: Any) {
            
            let logoutAlert = UIAlertController(title: "Conform Logout", message: "Are you sure you would like to logout of your account", preferredStyle: .alert)
            let logoutAction = UIAlertAction(title: "Logout", style: .destructive) {
                _ in
                self.logout()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            logoutAlert.addAction(logoutAction)
            logoutAlert.addAction(cancelAction)
            present(logoutAlert, animated: true)
        }
    }
