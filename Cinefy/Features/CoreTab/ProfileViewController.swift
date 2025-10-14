//
//  ProfileViewController.swift
//  RoPhim
//
//  Created by Nguyễn Hiếu on 25/8/25.
//

import UIKit
import PanModal
import FirebaseAuth
import SDWebImage

final class ProfileViewController: UIViewController{
    
    // MARK: - IBOutlets
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var managerAccountButton: UIButton!
    @IBOutlet weak var menuTableView: UITableView!
    
    // MARK: - Properties
    var isLoggedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    private var menuItems: [MenuItem] = []
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        updateUIForLoginState()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDelegates()
        self.setupUI()
        setupMenuItems()
        menuTableView.isScrollEnabled = false
        menuTableView.separatorStyle = .none
        menuTableView.register(UINib(nibName: MenuTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: MenuTableViewCell.identifier)
        
    }
    
    // MARK: - Setup UI
    
    private func setupDelegates(){
        menuTableView.delegate = self
        menuTableView.dataSource = self
    }
    
    private func setupUI(){
        view.backgroundColor = ColorName.black.color
        userImageView.tintColor = ColorName.white.color
        userImageView.layer.cornerRadius = userImageView.frame.size.width / 2
        userImageView.clipsToBounds = true
        usernameLabel.textColor = ColorName.white.color
        loginButton.tintColor = ColorName.lightYellow.color
        registerButton.tintColor = ColorName.white.color
        managerAccountButton.tintColor = ColorName.lightYellow.color
        menuTableView.backgroundColor = ColorName.primary.color
    }
    
    private func updateUIForLoginState() {
        if isLoggedIn {
            userImageView.sd_setImage(with: Auth.auth().currentUser?.photoURL)
            usernameLabel.text = Auth.auth().currentUser?.displayName ?? "Người dùng"
            usernameLabel.font = .systemFont(ofSize: 14, weight: .bold)
            emailLabel.text = Auth.auth().currentUser?.email ?? "Email"
            emailLabel.isHidden = false
            loginButton.isHidden = true
            registerButton.isHidden = true
            managerAccountButton.isHidden = false
        } else {
            userImageView.image = UIImage(systemName: "person.circle")
            usernameLabel.font = .systemFont(ofSize: 18, weight: .bold)
            usernameLabel.text = "Tài khoản"
            emailLabel.isHidden = true
            loginButton.isHidden = false
            registerButton.isHidden = false
            managerAccountButton.isHidden = true
        }
        setupMenuItems()
        
        DispatchQueue.main.async {
            self.menuTableView.reloadData()
        }
    }
    
}

// MARK: - Actions
extension ProfileViewController{
    
    @IBAction func loginPressed(_ sender: UIButton) {
        let loginVC = AuthViewController()
        loginVC.mode = .login
        presentPanModal(loginVC)
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        let registerVC = AuthViewController()
        registerVC.mode = .register
        presentPanModal(registerVC)
    }
    
    @IBAction func managerAccountPressed(_ sender: UIButton) {
        print("Quan ly nguoi dung")
    }
}

// MARK: - CollectionView Delegate & DataSource
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.identifier, for: indexPath) as! MenuTableViewCell
        let item = menuItems[indexPath.row]
        cell.titleLabel.text = item.title
        cell.menuImageView.image = UIImage(systemName: item.icon)
        cell.titleLabel.textColor = item.color ?? .label
        cell.menuImageView.tintColor = item.color ?? .systemGray
        cell.arrowRightImageView.tintColor = item.color ?? .systemGray
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        switch index{
        case 0:
            if isLoggedIn{
                let viewingRecentVC = ViewingRecentViewController()
                navigationController?.pushViewController(viewingRecentVC, animated: true)
            }else{
                let loginVC = AuthViewController()
                loginVC.mode = .login
                presentPanModal(loginVC)
            }
        case 1:
            if isLoggedIn{
                print("danh sách phim của tôi")
            }else{
                let loginVC = AuthViewController()
                loginVC.mode = .login
                presentPanModal(loginVC)
            }
        case 2:
            if isLoggedIn{
                print("yêu thích")
            }else{
                let loginVC = AuthViewController()
                loginVC.mode = .login
                presentPanModal(loginVC)
            }
        case 3:
            print("cái đặt")
        case 4:
            print("đăng nhập smartTV")
        case 5:
            print("chính sách bảo mật")
        case 6:
            print("liên hệ")
        case 7:
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                self.setupMenuItems()
                DispatchQueue.main.async {
                    ShowMessage.show("Đăng xuất thành công", type: .success, in: self)
                    self.updateUIForLoginState()
                    self.menuTableView.reloadData()
                }
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

// MARK: - Private Helpers
extension ProfileViewController {
    
    private func setupMenuItems() {
        menuItems = [
            MenuItem(title: "Đang xem", icon: "clock.arrow.trianglehead.counterclockwise.rotate.90", color: nil),
            MenuItem(title: "Danh sách phim của tôi", icon: "plus", color: nil),
            MenuItem(title: "Yêu thích", icon: "heart.fill", color: nil),
            MenuItem(title: "Cài đặt", icon: "gearshape", color: nil),
            MenuItem(title: "Đăng nhập smartTV", icon: "tv.badge.wifi.fill", color: nil),
            MenuItem(title: "Chính sách bảo mật", icon: "newspaper.fill", color: nil),
            MenuItem(title: "Liên hệ", icon: "questionmark.square", color: nil)
        ]
        
        if isLoggedIn {
            menuItems.append(
                MenuItem(title: "Đăng xuất",
                         icon: "iphone.and.arrow.right.outward",
                         color: .systemRed)
            )
        }
    }
}

