//
//  SearchViewController.swift
//  RoPhim
//
//  Created by Nguyễn Hiếu on 25/8/25.
//

import UIKit

final class SearchViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultCollectionView: UICollectionView!
    
    // MARK: - Properties
    var searchData: ResponseModel?
    
    /// Hidden NavigationBar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.searchBar.delegate = self
        self.searchBar.placeholder = "Tìm kiếm"
        self.searchResultCollectionView.delegate = self
        self.searchResultCollectionView.dataSource = self
        
        // Call API
        self.fetchAPI(keyword: nil)
        
        // Dismiss Keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupUI(){
        view.backgroundColor = ColorName.primary.color
        
        // Search Result CollectionView
        if let flowLayout = searchResultCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = .zero
            flowLayout.scrollDirection = .vertical
            flowLayout.sectionInset = .init(top: 10, left: 10, bottom: 0, right: 10)
            flowLayout.minimumLineSpacing = 15
            flowLayout.minimumInteritemSpacing = 10
        }
        self.searchResultCollectionView.register(UINib(nibName: ActionMovieCollectionViewCell.identifier, bundle: nil),
                                                 forCellWithReuseIdentifier: ActionMovieCollectionViewCell.identifier)
        self.searchResultCollectionView.backgroundColor = .clear
    }
    
    // Dismiss Keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Fetch API
extension SearchViewController{
    func fetchAPI(keyword: String?){
        Task {
            do{
                self.searchData = try await APIService.searchFilm(keyword: keyword ?? "hanh-dong")
                self.searchResultCollectionView.reloadData()
            } catch{
                print("Error: \(error)")
            }
        }
    }
}

// MARK: - Action
extension SearchViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("User text: \(searchText)")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("User search: \(searchBar.text ?? "User not input")")
        let cleaned = Utils.formatString(searchBar.text ?? "")
        print("cleaned = \(cleaned)")
        fetchAPI(keyword: cleaned)
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            view.endEditing(true)
        }
}

// MARK: - Search Result CollectionView Delegate & DataSource
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchData?.data.items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ActionMovieCollectionViewCell.identifier,
            for: indexPath
        ) as! ActionMovieCollectionViewCell
        cell.titleLabel.text = searchData?.data.items?[indexPath.row].name
        if let thumbURL = URL(string: "\(APIService.DOMAIN_CDN_IMAGE)\(searchData?.data.items?[indexPath.row].thumbURL ?? "")") {
            cell.imageView?.sd_setImage(with: thumbURL, placeholderImage: UIImage(named: "placeholder"))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width-40)/3, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("slug: \(String(describing: searchData?.data.items?[indexPath.row].slug))")
        if let currentFilm = self.searchData?.data.items?[indexPath.row].slug{
            let playFilmVC = PlayFilmViewController()
            playFilmVC.hidesBottomBarWhenPushed = true
            playFilmVC.filmURL = currentFilm
            navigationController?.pushViewController(playFilmVC, animated: true)
        }else{
            return
        }
    }
}
