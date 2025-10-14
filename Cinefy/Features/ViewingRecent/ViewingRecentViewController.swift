//
//  ViewingRecentViewController.swift
//  Cinefy
//
//  Created by Nguyễn Hiếu on 14/10/25.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

// MARK: - ViewingRecent ViewController
class ViewingRecentViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var viewingRecentTableView: UITableView!
    
    // MARK: - Properties
    let db = Firestore.firestore()
    var viewedList: [ViewedModel] = []
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.title = "Đang xem"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem?.tintColor = ColorName.white.color
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewingRecentTableView.delegate = self
        viewingRecentTableView.dataSource = self
        viewingRecentTableView.register(UINib(nibName:ViewingRecentTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ViewingRecentTableViewCell.identifier)
        self.setupUI()
        Task {
            await getRecentViewing()
        }
    }
    
    // MARK: - Setup UI
    func setupUI(){
        self.view.backgroundColor = ColorName.primary.color
    }
    
}

// MARK: - Actions
extension ViewingRecentViewController{
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - ViewingRecent TableView Delegate & Datasource
extension ViewingRecentViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewingRecentTableViewCell.identifier, for: indexPath) as! ViewingRecentTableViewCell
        let viewed = viewedList[indexPath.row]
        if let thumbURL = URL(string: "\(viewed.photoURL)") {
            cell.filmImageView?.sd_setImage(with: thumbURL, placeholderImage: UIImage(named: "placeholder"))
        }
        cell.titleLabel?.text = viewed.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playFilmVC = PlayFilmViewController()
        playFilmVC.hidesBottomBarWhenPushed = true
        playFilmVC.filmURL = self.viewedList[indexPath.row].url
        navigationController?.pushViewController(playFilmVC, animated: true)
    }
}

// MARK: - ViewingRecent Logic
extension ViewingRecentViewController{
    private func getRecentViewing() async {
        guard let email = Auth.auth().currentUser?.email else { return }
        
        let collectionRef = Firestore.firestore()
            .collection("users")
            .document(email)
            .collection("viewing_recent")
        
        do {
            let snapshot = try await collectionRef.getDocuments()
            self.viewedList = try snapshot.documents.map { document in
                try document.data(as: ViewedModel.self)
            }
            
            DispatchQueue.main.async {
                self.viewingRecentTableView.reloadData()
            }
            
        } catch {
            print("Error fetching viewing_recent: \(error)")
        }
    }
}
