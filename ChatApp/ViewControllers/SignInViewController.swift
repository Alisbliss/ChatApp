//
//  SignInViewController.swift
//  ChatApp
//
//  Created by Gwinyai Nyatsoka on 21/7/2023.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var createAccountTextView: UITextView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    var activeTextField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.clipsToBounds = true
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        let attributedString = NSMutableAttributedString(string: "Don't have an account? Create an account here.", attributes: [.font: Font.capture])
        attributedString.addAttribute(.link, value: "chatappsignin://signinAccount", range: (attributedString.string as NSString).range(of: "Create an account here."))
        createAccountTextView.attributedText = attributedString
        createAccountTextView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.secondary, .font: Font.linkLabel]
        createAccountTextView.delegate = self
        createAccountTextView.isScrollEnabled = false
        createAccountTextView.textAlignment = .center
        createAccountTextView.isEditable = false
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        let backgroundTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(backgroundTap)
        showLoadingView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            self.removeLoadingView()
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.layer.cornerRadius = 20
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardNotifications()
    }

    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardOffset = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
        let totalOffset = activeTextField == nil ? keyboardOffset : keyboardOffset + activeTextField!.frame.height
        scrollView.contentInset.bottom = totalOffset
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = 0
    }
    
    @objc func dismissKeyboard() {
            view.endEditing(true)
    }
    
    @IBAction func signinButtonTapped(_ sender: Any) {
        guard let passward = passwordTextField.text else {
            presentErrorAlert(title: "Passward required", message: "Please enter a passward to continue sign up")
            return
        }
        
        guard let email = emailTextField.text else {
            presentErrorAlert(title: "Email required", message: "Please enter a email to continue sign up")
            return
        }
        showLoadingView()
        signinUser(email: email, passward: passward) { [weak self] success, error in
            guard let strongSelf = self else { return }
            if let error = error {
                print(error)
                strongSelf.presentErrorAlert(title: "Signin Error", message: error)
                return
            }
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homeVC = mainStoryboard.instantiateViewController(identifier: "HomeViewController")
            let navVC = UINavigationController(rootViewController: homeVC)
            let window = UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.first { $0.isKeyWindow }
            window?.rootViewController = navVC        }
    }

    func signinUser(email: String, passward: String, complition: @escaping (_ success: Bool, _ error: String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: passward) { _, error in
            //self.removeLoadingView()
            if let error = error {
                print(error.localizedDescription)
                var errorMessage = "Something went wrong. Please try again later."
                if let authError = AuthErrorCode(rawValue: error._code) {
                    switch authError {
                    case .userNotFound:
                        errorMessage = "Email/password does not match any record."
                    case .invalidEmail:
                        errorMessage = "invalid email."
                    default:
                        break
                   
                    }
                }
                complition(false, errorMessage)
                //self.presentErrorAlert(title: "Create Account Failed", message: errorMessage)
                return
            }
            complition(true, nil)
           
        }
    
    }
}
extension SignInViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.scheme == "chatappsignin" {
            performSegue(withIdentifier: "CreateAccountSegue", sender: nil)
            
        }
        return false
    }
}
extension SignInViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
}
