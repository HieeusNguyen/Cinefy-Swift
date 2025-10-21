//
//  HomeViewController.swift
//  RoPhim
//
//  Created by Nguyễn Hiếu on 25/8/25.
//

import UIKit
import FSPagerView
import SDWebImage

final class HomeViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imdbScoreTag: CustomLabelTag!
    @IBOutlet weak var qualityTag: CustomLabelTag!
    @IBOutlet weak var languageTag: CustomLabelTag!
    @IBOutlet weak var yearTag: CustomLabelTag!
    @IBOutlet weak var movieGenreCollectionView: UICollectionView!
    @IBOutlet weak var actionMovieCollectionView: UICollectionView!
    
    @IBOutlet weak var pagerView: FSPagerView!{
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.pagerView.isInfinite = true
            self.pagerView.automaticSlidingInterval = 3
            self.pagerView.transformer = FSPagerViewTransformer(type: .linear)
            self.pagerView.itemSize = CGSize(width: 280, height: 400)
            self.pagerView.contentMode = .scaleAspectFit
        }
    }
    
    @IBOutlet weak var pageControl: FSPageControl!{
        didSet{
            self.pageControl.contentHorizontalAlignment = .center
            self.pageControl.hidesForSinglePage = true
            self.pageControl.setFillColor(.gray, for: .normal)
            self.pageControl.setFillColor(.white, for: .selected)
            self.pageControl.itemSpacing = 6
            self.pageControl.interitemSpacing = 3
            self.pageControl.backgroundColor = .clear
        }
    }
    
    // MARK: - Properties
    let categories: [String] = ["Đề xuất", "Phim bộ", "Phim lẻ", "Thể loại"]
    let movieGenre: [String] = ["Marvel", "Viễn tưởng", "Hành động", "Keo lỳ slayyy"]
    var currentFilm: String?
    var homeData: ResponseModel?
    var actionMovieData: ResponseModel?
    
    private let categoryHandler = CategoryCollectionViewHandler()
    private let movieGenreHandler = MovieGenreCollectionViewHandler()
    private let actionMovieHandler = ActionMovieCollectionViewHandler()
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Call API
        self.fetchAPIgetHomePage()
        self.fetchAPIActionMvie()
        
        //FS PagerView
        self.pagerView.delegate = self
        self.pagerView.dataSource = self
        
        // Category CollectionView
        self.categoryHandler.categories = categories
        self.categoryCollectionView.delegate = categoryHandler
        self.categoryCollectionView.dataSource = categoryHandler
        
        // Movie CollectionView
        self.movieGenreHandler.movieGenre = movieGenre
        self.movieGenreCollectionView.delegate = movieGenreHandler
        self.movieGenreCollectionView.dataSource = movieGenreHandler
        
        // ActionMovie CollectionView
        self.actionMovieCollectionView.delegate = actionMovieHandler
        self.actionMovieCollectionView.dataSource = actionMovieHandler
        self.actionMovieHandler.parentVC = self
        
        //Setup UI
        self.setupUI()
    }
    
    // MARK: - Setup UI
    private func setupUI(){
        self.view.backgroundColor = ColorName.primary.color
        
        //Category CollectionView
        if let flowLayout = categoryCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            flowLayout.scrollDirection = .horizontal
            flowLayout.sectionInset = .init(top: 0, left: 10, bottom: 0, right: 10)
        }
        self.categoryCollectionView.register(UINib(nibName: CategoryCollectionViewCell.identifier, bundle: nil),
                                             forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        self.categoryCollectionView.backgroundColor = .clear
        self.categoryCollectionView.showsHorizontalScrollIndicator = false
        
        
        //Title Label
        titleLabel.textColor = ColorName.white.color
        
        //Movie Genre CollectionView
        if let flowLayout = movieGenreCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = .zero
            flowLayout.scrollDirection = .horizontal
            flowLayout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 20)
        }
        self.movieGenreCollectionView.register(UINib(nibName: MovieGenreCollectionViewCell.identifier, bundle: nil),
                                               forCellWithReuseIdentifier: MovieGenreCollectionViewCell.identifier)
        self.movieGenreCollectionView.showsHorizontalScrollIndicator = false
        self.movieGenreCollectionView.backgroundColor = .clear
        
        // ActionMovie CollectionView
        if let flowLayout = actionMovieCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = .zero
            flowLayout.scrollDirection = .horizontal
            flowLayout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 20)
        }
        self.actionMovieCollectionView.register(UINib(nibName: ActionMovieCollectionViewCell.identifier, bundle: nil),
                                               forCellWithReuseIdentifier: ActionMovieCollectionViewCell.identifier)
        self.actionMovieCollectionView.showsHorizontalScrollIndicator = false
        self.actionMovieCollectionView.backgroundColor = .clear
    }
    
}

// MARK: - Fetch API
extension HomeViewController {
    func fetchAPIgetHomePage(){
        Task{
            do{
                self.homeData = try await APIService.getHomePageData()
                self.pagerView.reloadData()
                self.pageControl.numberOfPages = self.homeData?.data.items?.count ?? 0
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func fetchAPIActionMvie(){
        Task{
            do{
                self.actionMovieData = try await APIService.getActionMovieData()
                self.actionMovieHandler.actionMovieData = actionMovieData
                self.actionMovieCollectionView.reloadData()
            }catch{
                print("Error: \(error)")
            }
        }
    }
}

// MARK: - Actions
extension HomeViewController{
    @IBAction func playFilmPressed(_ sender: UIButton) {
        if let currentFilm = self.currentFilm{
            let playFilmVC = PlayFilmViewController()
            playFilmVC.hidesBottomBarWhenPushed = true
            playFilmVC.filmURL = currentFilm
            navigationController?.pushViewController(playFilmVC, animated: true)
        }else{
            return
        }
    }
    
    @IBAction func infoFilmPressed(_ sender: UIButton) {
    }
}

// MARK: - Category Delegate & Datasource
class CategoryCollectionViewHandler: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    var categories: [String] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CategoryCollectionViewCell.identifier,
            for: indexPath
        ) as! CategoryCollectionViewCell
        cell.titleLabel.text = categories[indexPath.row]
        if indexPath.row == categories.count{
            cell.arrowDownImageView.isHidden = false
        }
        return cell
    }
}

// MARK: - PagerView Delegate & Datasource
extension HomeViewController: FSPagerViewDelegate, FSPagerViewDataSource {
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        if let thumbURL = URL(string: "\(APIService.DOMAIN_CDN_IMAGE)\(homeData?.data.items?[index].thumbURL ?? "")") {
            cell.imageView?.sd_setImage(with: thumbURL, placeholderImage: UIImage(named: "placeholder"))
        }
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        return cell
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return homeData?.data.items?.count ?? 0
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        self.titleLabel.text = homeData?.data.items?[index].name
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        let index = pagerView.currentIndex
        if index < homeData?.data.items?.count ?? 0 {
            titleLabel.text = homeData?.data.items?[index].name
        }
        self.pageControl.currentPage = index
        self.currentFilm = homeData?.data.items?[index].slug
    }
    
}

// MARK: - MovieGenre Delegate & Datasource & FlowLayout
class MovieGenreCollectionViewHandler: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    var movieGenre: [String] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieGenre.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MovieGenreCollectionViewCell.identifier,
            for: indexPath
        ) as! MovieGenreCollectionViewCell
        cell.titleLabel.text = movieGenre[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 90)
    }
}

// MARK: - ActionMovie Delegate & Datasource & FlowLayout
class ActionMovieCollectionViewHandler: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    var actionMovieData: ResponseModel?
    weak var parentVC: UIViewController?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actionMovieData?.data.items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ActionMovieCollectionViewCell.identifier,
            for: indexPath
        ) as! ActionMovieCollectionViewCell
        cell.titleLabel.text = actionMovieData?.data.items?[indexPath.row].name
        if let thumbURL = URL(string: "\(APIService.DOMAIN_CDN_IMAGE)\(actionMovieData?.data.items?[indexPath.row].thumbURL ?? "")") {
            cell.imageView?.sd_setImage(with: thumbURL, placeholderImage: UIImage(named: "placeholder"))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let currentFilm = self.actionMovieData?.data.items?[indexPath.row].slug{
            let playFilmVC = PlayFilmViewController()
            playFilmVC.hidesBottomBarWhenPushed = true
            playFilmVC.filmURL = currentFilm
            parentVC?.navigationController?.pushViewController(playFilmVC, animated: true)
        }else{
            return
        }
    }
}
