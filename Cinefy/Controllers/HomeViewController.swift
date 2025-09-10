//
//  HomeViewController.swift
//  RoPhim
//
//  Created by Nguyễn Hiếu on 25/8/25.
//

import UIKit
import FSPagerView
import SDWebImage

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    let categories: [String] = ["Đề xuất", "Phim bộ", "Phim lẻ", "Thể loại"]
    var listFilm: [String] = []
    var imageFilm: [String] = []
    let movieGenre: [String] = ["Marvel", "Viễn tưởng", "Hành động", "Keo lỳ slayyy"]
    var listActionMovie: [String] = []
    var imageActionMovie: [String] = []
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imdbScoreTag: CustomLabelTag!
    @IBOutlet weak var qualityTag: CustomLabelTag!
    @IBOutlet weak var languageTag: CustomLabelTag!
    @IBOutlet weak var yearTag: CustomLabelTag!
    @IBOutlet weak var movieGenreCollectionView: UICollectionView!
    @IBOutlet weak var actionMovieCollectionView: UICollectionView!
    
    private let categoryHandler = CategoryCollectionViewHandler()
    private let movieGenreHandler = MovieGenreCollectionViewHandler()
    private let actionMovieHandler = ActionMovieCollectionViewHandler()
    
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
        
        //Setup UI
        self.setupUI()
    }
    
    func setupUI(){
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
                let homeData = try await APIService.getHomePageData()
                self.listFilm = homeData.data.items.map { $0.name }
                self.imageFilm = homeData.data.items.map { $0.thumbURL }
                self.pagerView.reloadData()
                self.pageControl.numberOfPages = self.listFilm.count
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func fetchAPIActionMvie(){
        Task{
            do{
                let actionMovie = try await APIService.getActionMovieData()
                self.actionMovieHandler.listActionMovie = actionMovie.data.items.map { $0.name }
                self.actionMovieHandler.imageActionMovie = actionMovie.data.items.map { $0.thumbURL }
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
        return cell
    }
}

// MARK: - PagerView Delegate & Datasource
extension HomeViewController: FSPagerViewDelegate, FSPagerViewDataSource {
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        if let thumbURL = URL(string: "\(APIService.DOMAIN_CDN_IMAGE)\(imageFilm[index])") {
            cell.imageView?.sd_setImage(with: thumbURL, placeholderImage: UIImage(named: "placeholder"))
        }
        return cell
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return listFilm.count
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        self.titleLabel.text = listFilm[index]
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        let index = pagerView.currentIndex
        if index < listFilm.count {
            titleLabel.text = listFilm[index]
        }
        self.pageControl.currentPage = pagerView.currentIndex
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
    var listActionMovie: [String] = []
    var imageActionMovie: [String] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listActionMovie.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ActionMovieCollectionViewCell.identifier,
            for: indexPath
        ) as! ActionMovieCollectionViewCell
        cell.titleLabel.text = listActionMovie[indexPath.row]
        if let thumbURL = URL(string: "\(APIService.DOMAIN_CDN_IMAGE)\(imageActionMovie[indexPath.row])") {
            cell.imageView?.sd_setImage(with: thumbURL, placeholderImage: UIImage(named: "placeholder"))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 270)
    }
}
