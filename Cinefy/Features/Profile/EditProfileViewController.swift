//
//  EditProfileViewController.swift
//  Cinefy
//
//  Created by Nguyễn Hiếu on 20/10/25.
//

import UIKit
import FirebaseAuth
import SDWebImage

// MARK: - EditProfileViewController
class EditProfileViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var editAvatarButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: CustomTextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var changePasswordLabel: UILabel!
    @IBOutlet weak var changePasswordStackView: UIStackView!
    @IBOutlet weak var updateProfileButton: UIButton!
    
    // MARK: - Properties
    let user = Auth.auth().currentUser!
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = "Quản lý tài khoản"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem?.tintColor = ColorName.white.color
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    // MARK: - Setup UI
    private func setupUI(){
        self.view.backgroundColor = ColorName.primary.color
        avatarImageView.sd_setImage(with: user.photoURL)
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        editAvatarButton.tintColor = ColorName.lightYellow.color
        nameTextField.text = user.displayName
        emailTextField.text = user.email
        updateProfileButton.tintColor = ColorName.lightYellow.color
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changePasswordPressed))
        changePasswordStackView.isUserInteractionEnabled = true
        changePasswordStackView.addGestureRecognizer(tapGesture)
    }

}

// MARK: - Actions
extension EditProfileViewController {
    
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func changePasswordPressed(){
        print("change Password Pressed")
    }
    
    @IBAction func updateProfilePressed(_ sender: UIButton) {
        print("update Profile Pressed")
    }
    
    @IBAction func editAvatarPressed(_ sender: UIButton) {
        print("edit Avatar Pressed")
    }
}
