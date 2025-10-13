//
//  AuthViewController.swift
//  Cinefy
//
//  Created by Nguyễn Hiếu on 11/10/25.
//

import UIKit
import PanModal
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import Combine

// MARK: - AuthViewController
final class AuthViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var confirmPasswordTextField: UITextField!
    @IBOutlet private weak var mainButton: UIButton!
    @IBOutlet private weak var forgotPasswordLabel: UILabel!
    @IBOutlet private weak var googleButton: UIButton!
    
    // MARK: - Properties
    var mode: AuthMode = .login
    private var isShortFormEnabled = true
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        setupUI()
        setupKeyboardObservers()
        setupForgotPasswordTap()
    }
    
    // MARK: - Deinit
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}

// MARK: - Setup UI
private extension AuthViewController {
    
    func setupDelegates() {
        [nameTextField, emailTextField, passwordTextField, confirmPasswordTextField]
            .forEach { $0?.delegate = self }
    }
    
    func setupUI() {
        // Configure toggle buttons
        let toggleButton = makeToggleButton(action: #selector(togglePasswordVisibility(_:)))
        let toggleConfirmButton = makeToggleButton(action: #selector(toggleConfirmPasswordVisibility(_:)))
        
        passwordTextField.setRightView(toggleButton, padding: 16)
        confirmPasswordTextField.setRightView(toggleConfirmButton, padding: 16)
        
        // Configure buttons
        mainButton.tintColor = ColorName.lightYellow.color
        googleButton.tintColor = .darkGray
        googleButton.configuration?.imagePadding = 10
        googleButton.setAttributedTitle(
            NSAttributedString(
                string: "Đăng nhập bằng Google",
                attributes: [
                    .font: UIFont.systemFont(ofSize: 16, weight: .bold),
                    .foregroundColor: ColorName.white.color
                ]
            ),
            for: .normal
        )
        
        // Configure labels & mode
        switch mode {
        case .login:
            titleLabel.attributedText = NSAttributedString(
                string: "Đăng nhập",
                attributes: [.font: UIFont.systemFont(ofSize: 22, weight: .bold)]
            )
            subTitleLabel.text = "Nếu bạn chưa có tài khoản, đăng ký ngay"
            nameTextField.isHidden = true
            confirmPasswordTextField.isHidden = true
            mainButton.setAttributedTitle(
                NSAttributedString(
                    string: "Đăng nhập",
                    attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .bold),
                                 .foregroundColor: ColorName.black.color]
                ),
                for: .normal
            )
        case .register:
            titleLabel.attributedText = NSAttributedString(
                string: "Đăng ký",
                attributes: [.font: UIFont.systemFont(ofSize: 22, weight: .bold)]
            )
            subTitleLabel.text = "Nếu bạn đã có tài khoản, đăng nhập ngay"
            forgotPasswordLabel.isHidden = true
            mainButton.setAttributedTitle(
                NSAttributedString(
                    string: "Đăng ký",
                    attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .bold),
                                 .foregroundColor: ColorName.black.color]
                ),
                for: .normal
            )
        }
    }
    
    func setupForgotPasswordTap() {
        forgotPasswordLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(forgotPasswordTapped))
        forgotPasswordLabel.addGestureRecognizer(tapGesture)
    }
    
    func makeToggleButton(action: Selector) -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.tintColor = .gray
        button.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
}

// MARK: - Actions
private extension AuthViewController {
    
    @objc func togglePasswordVisibility(_ sender: UIButton) {
        toggleSecureEntry(for: passwordTextField, sender: sender)
    }
    
    @objc func toggleConfirmPasswordVisibility(_ sender: UIButton) {
        toggleSecureEntry(for: confirmPasswordTextField, sender: sender)
    }
    
    @objc func forgotPasswordTapped() {
        print("Forgot password tapped")
    }
    
    @IBAction func mainButtonPressed(_ sender: UIButton) {
        if mode == .login {
            self.performLogin()
        }else{
            self.performRegister()
        }
    }
    
    @IBAction func googleButtonPressed(_ sender: UIButton) {
        self.performGoogleSignIn()
    }
}

// MARK: - Combine Bindings
private extension AuthViewController {
    
    func setupKeyboardObservers() {
        let willShow = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification).map { _ in true }
        let willHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification).map { _ in false }
        
        Publishers.Merge(willShow, willHide)
            .receive(on: RunLoop.main)
            .sink { [weak self] visible in
                guard let self = self else { return }
                
                if visible {
                    guard self.isShortFormEnabled else { return }
                    self.isShortFormEnabled = false
                    self.panModalTransition(to: .longForm)
                } else {
                    guard !self.isShortFormEnabled else { return }
                    self.isShortFormEnabled = true
                    self.panModalTransition(to: .shortForm)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - UITextFieldDelegate
extension AuthViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            if mode == .login {
                textField.resignFirstResponder()
            } else {
                confirmPasswordTextField.becomeFirstResponder()
            }
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}

// MARK: - PanModalPresentable
extension AuthViewController: PanModalPresentable {
    
    var panScrollable: UIScrollView? { nil }
    
    var shortFormHeight: PanModalHeight {
        if isShortFormEnabled {
            return mode == .login ? .contentHeight(430) : .contentHeight(510)
        } else {
            return longFormHeight
        }
    }
    
    var anchorModalToLongForm: Bool { false }
    
    func willTransition(to state: PanModalPresentationController.PresentationState) {
        guard isShortFormEnabled, case .longForm = state else { return }
        isShortFormEnabled = false
        panModalSetNeedsLayoutUpdate()
    }
}

// MARK: - Private Helpers
private extension AuthViewController {
    
    func toggleSecureEntry(for textField: UITextField, sender: UIButton) {
        textField.isSecureTextEntry.toggle()
        let imageName = textField.isSecureTextEntry ? "eye.slash" : "eye"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
    }
}

// MARK: - Authentication Logic
private extension AuthViewController {
    
    func performLogin() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            ShowMessage.show("Vui lòng nhập đầy đủ thông tin", type: .error, in: self)
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                ShowMessage.show(error.localizedDescription, type: .error, in: self)
            } else {
                ShowMessage.show("Đăng nhập thành công", type: .success, in: self){
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    func performRegister() {
        guard let name = nameTextField.text, !name.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            ShowMessage.show("Vui lòng nhập đầy đủ thông tin", type: .error, in: self)
            return
        }
        
        guard password == confirmPassword else {
            ShowMessage.show("Mật khẩu xác nhận không khớp", type: .error, in: self)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                ShowMessage.show(error.localizedDescription, type: .error, in: self)
            } else {
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = name
                changeRequest?.commitChanges { _ in
                    print("Đăng ký thành công")
                }
            }
        }
    }
    
    func performGoogleSignIn() {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            ShowMessage.show("Lỗi cấu hình Google Sign In", type: .error, in: self)
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                ShowMessage.show("Đăng nhập Google thất bại:", type: .error, in: self)
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                ShowMessage.show("Không thể lấy thông tin người dùng", type: .error, in: self)
                return
            }
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )
            
            Auth.auth().signIn(with: credential) { [weak self] _, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    ShowMessage.show("Đăng nhập thất bại", type: .error, in: self)
                } else {
                    ShowMessage.show("Đăng nhập Google thành công", in: self){
                        self.dismiss(animated: true)
                    }
                }
            }
        }
    }
}
