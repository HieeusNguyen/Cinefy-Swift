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
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imdbScoreTag: CustomLabelTag!
    @IBOutlet weak var qualityTag: CustomLabelTag!
    @IBOutlet weak var languageTag: CustomLabelTag!
    @IBOutlet weak var yearTag: CustomLabelTag!
    @IBOutlet weak var movieGenreCollectionView: UICollectionView!
    
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
        //FS PagerView
        self.pagerView.delegate = self
        self.pagerView.dataSource = self
        self.categoryCollectionView.delegate = self
        self.categoryCollectionView.dataSource = self
        self.movieGenreCollectionView.delegate = self
        self.movieGenreCollectionView.dataSource = self
        //Call API
        self.fetchAPI()
        
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
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            flowLayout.scrollDirection = .horizontal
            flowLayout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 20)
            flowLayout.itemSize = CGSize(width: 200, height: 90)
        }
        self.movieGenreCollectionView.register(UINib(nibName: MovieGenreCollectionViewCell.identifier, bundle: nil),
                                               forCellWithReuseIdentifier: MovieGenreCollectionViewCell.identifier)
        self.movieGenreCollectionView.showsHorizontalScrollIndicator = false
        self.movieGenreCollectionView.backgroundColor = .clear
    }
    
}

// MARK: - Fetch API
extension HomeViewController {
    func fetchAPI(){
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
}

// MARK: - Actions
extension HomeViewController{
    @IBAction func playFilmPressed(_ sender: UIButton) {
        
    }
    
    
    @IBAction func infoFilmPressed(_ sender: UIButton) {
    }
}

// MARK: - Category Delegate & Datasource
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return categories.count
        } else if collectionView == movieGenreCollectionView {
            return movieGenre.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CategoryCollectionViewCell.identifier,
                for: indexPath
            ) as! CategoryCollectionViewCell
            cell.titleLabel.text = categories[indexPath.row]
            return cell
        } else if collectionView == movieGenreCollectionView {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MovieGenreCollectionViewCell.identifier,
                for: indexPath
            ) as! MovieGenreCollectionViewCell
            cell.titleLabel.text = movieGenre[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == movieGenreCollectionView {
            return CGSize(width: 160, height: 90)
        }
        
        return CGSize(width: 50, height: 50)
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



