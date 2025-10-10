//
//  ProfileViewController.swift
//  RoPhim
//
//  Created by Nguyễn Hiếu on 25/8/25.
//

import UIKit

class ProfileViewController: UIViewController{
    
    // MARK: - Properties
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var menuTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.isScrollEnabled = false
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
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        print("Register Pressed")
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.identifier, for: indexPath) as! MenuTableViewCell
        switch index {
        case 0:
            cell.menuImageView.image = UIImage(systemName: "person.circle")
            cell.titleLabel.text = "Đang xem"
        case 1:
            cell.menuImageView.image = UIImage(systemName: "person.circle")
            cell.titleLabel.text = "Danh sách phim của tôi"
        case 2:
            cell.menuImageView.image = UIImage(systemName: "person.circle")
            cell.titleLabel.text = "Yêu thích"
        case 3:
            cell.menuImageView.image = UIImage(systemName: "person.circle")
            cell.titleLabel.text = "Cài đặt"
        case 4:
            cell.menuImageView.image = UIImage(systemName: "person.circle")
            cell.titleLabel.text = "Đăng nhập smartTV"
        case 5:
            cell.menuImageView.image = UIImage(systemName: "person.circle")
            cell.titleLabel.text = "Chính sách bảo mật"
        case 6:
            cell.menuImageView.image = UIImage(systemName: "person.circle")
            cell.titleLabel.text = "Liên hệ"
        default: break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row: \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
