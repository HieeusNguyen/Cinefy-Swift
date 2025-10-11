//
//  AuthViewController.swift
//  Cinefy
//
//  Created by Nguyễn Hiếu on 11/10/25.
//

import UIKit
import PanModal

class AuthViewController: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    @IBOutlet weak var googleButton: UIButton!
    
    // MARK: - Properties
    var mode: AuthMode = .login
    var isShortFormEnabled = true
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        // Setup UI
        self.setupUI()

        passwordTextField.isSecureTextEntry = true
        
        forgotPasswordLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(forgotPasswordTapped))
        forgotPasswordLabel.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Layout
    private func setupUI(){
        
        let toggleButton = UIButton(type: .custom)
        toggleButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        toggleButton.tintColor = .gray
        toggleButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        passwordTextField.rightView = toggleButton
        passwordTextField.rightViewMode = .always
        mainButton.tintColor = ColorName.lightYellow.color
        googleButton.tintColor = .darkGray
        googleButton.configuration?.imagePadding = 10
        googleButton.setAttributedTitle(NSAttributedString(string: "Đăng nhập bằng Google", attributes: [.font: UIFont.systemFont(ofSize: 18, weight: .bold), .foregroundColor : ColorName.white.color]), for: .normal)
        
        switch mode {
        case .login:
            titleLabel.attributedText = NSAttributedString(string: "Đăng nhập", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .bold)])
            subTitleLabel.text = "Nếu bạn chưa có tài khoản, đăng ký ngay"
            nameTextField.isHidden = true
            confirmPasswordTextField.isHidden = true
            mainButton.setAttributedTitle(NSAttributedString(string: "Đăng nhập", attributes: [.font: UIFont.systemFont(ofSize: 18, weight: .bold), .foregroundColor : ColorName.black.color]), for: .normal)
            
        case .register:
            titleLabel.attributedText = NSAttributedString(string: "Đăng ký", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .bold)])
            subTitleLabel.text = "Nếu bạn đã có tài khoản, đăng nhập ngay"
            forgotPasswordLabel.isHidden = true
            mainButton.setAttributedTitle(NSAttributedString(string: "Đăng ký", attributes: [.font: UIFont.systemFont(ofSize: 18, weight: .bold), .foregroundColor : ColorName.black.color]), for: .normal)
        }
    }
    
}

// MARK: - Action
extension AuthViewController{
    
    @objc private func keyboardWillShow(notification: Notification) {
        isShortFormEnabled = false
        panModalTransition(to: .longForm)
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        isShortFormEnabled = true
        panModalTransition(to: .shortForm)
    }
    
    @objc func togglePasswordVisibility(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle() 
        
        let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
    }

    
    @objc func forgotPasswordTapped() {
        print("Forgot password tapped")
    }
    
    @IBAction func mainButtonPressed(_ sender: UIButton) {
        print("Main Button Pressed")
    }
    
    @IBAction func googleButtonPressed(_ sender: UIButton) {
        print("Google Button Pressed")
    }
}

// MARK: - UITextField Delegate
extension AuthViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField{
        case nameTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            if mode == .login{
                textField.resignFirstResponder()
            }else{
                confirmPasswordTextField.becomeFirstResponder()
            }
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}

// MARK: - PanModalPresentable
extension AuthViewController: PanModalPresentable{
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var shortFormHeight: PanModalHeight {
        if isShortFormEnabled{
            if mode == .login{
                return .contentHeight(430)
            }else{
                return .contentHeight(510)
            }
        }else{
            return longFormHeight
        }
    }
    
    var anchorModalToLongForm: Bool {
        return false
    }
    
    func willTransition(to state: PanModalPresentationController.PresentationState) {
        guard isShortFormEnabled, case .longForm = state
        else { return }
        
        isShortFormEnabled = false
        panModalSetNeedsLayoutUpdate()
    }
}
