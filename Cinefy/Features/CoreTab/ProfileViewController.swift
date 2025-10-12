//
//  ProfileViewController.swift
//  RoPhim
//
//  Created by Nguyễn Hiếu on 25/8/25.
//

import UIKit
import PanModal
import FirebaseAuth

final class ProfileViewController: UIViewController{
    
    // MARK: - IBOutlets
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var menuTableView: UITableView!
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.isScrollEnabled = false
        menuTableView.separatorStyle = .none
        menuTableView.register(UINib(nibName: MenuTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: MenuTableViewCell.identifier)
        self.setupUI()
    }
    
    // MARK: - Setup UI
    private func setupUI(){
        view.backgroundColor = ColorName.black.color
        userImageView.tintColor = ColorName.white.color
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = ColorName.white.color
        loginButton.tintColor = ColorName.lightYellow.color
        registerButton.tintColor = ColorName.white.color
        menuTableView.backgroundColor = ColorName.primary.color
    }
}

// MARK: - Action
extension ProfileViewController{
    
    @IBAction func loginPressed(_ sender: UIButton) {
        print("Login Pressed")
        if Auth.auth().currentUser != nil{
            print("User already logged in")
        }else{
            let loginVC = AuthViewController()
            loginVC.mode = .login
            presentPanModal(loginVC)
        }
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        print("Register Pressed")
        if Auth.auth().currentUser != nil{
            print("User already logged in")
        }else{
            let registerVC = AuthViewController()
            registerVC.mode = .register
            presentPanModal(registerVC)
        }
    }
}

// MARK: - CollectionView Delegate & DataSource
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.identifier, for: indexPath) as! MenuTableViewCell
        switch index {
        case 0:
            cell.menuImageView.image = UIImage(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90")
            cell.titleLabel.text = "Đang xem"
        case 1:
            cell.menuImageView.image = UIImage(systemName: "plus")
            cell.titleLabel.text = "Danh sách phim của tôi"
        case 2:
            cell.menuImageView.image = UIImage(systemName: "heart.fill")
            cell.titleLabel.text = "Yêu thích"
        case 3:
            cell.menuImageView.image = UIImage(systemName: "gearshape")
            cell.titleLabel.text = "Cài đặt"
        case 4:
            cell.menuImageView.image = UIImage(systemName: "tv.badge.wifi.fill")
            cell.titleLabel.text = "Đăng nhập smartTV"
        case 5:
            cell.menuImageView.image = UIImage(systemName: "newspaper.fill")
            cell.titleLabel.text = "Chính sách bảo mật"
        case 6:
            cell.menuImageView.image = UIImage(systemName: "questionmark.square")
            cell.titleLabel.text = "Liên hệ"
        case 7:
            cell.menuImageView.image = UIImage(systemName: "plus")
            cell.titleLabel.text = "Đăng xuất"
        default: break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        switch index{
        case 0:
            print("đagn xem")
        case 1:
            print("danh sách phim của tôi")
        case 2:
            print("yêu thích")
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
                print("Đăng xuất thành công")
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
