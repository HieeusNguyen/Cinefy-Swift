//
//  PlayFilmViewController.swift
//  Cinefy
//
//  Created by Nguyễn Hiếu on 10/9/25.
//

import UIKit
import AVFoundation

class PlayFilmViewController: UIViewController {
    
    // MARK: - Properties
    var filmURL: String?
    var filmData: ResponseModel?
    private var isFullscreen: Bool = false
    private var isMovie: Bool = false
    
    @IBOutlet weak var videoContainerView: UIView!
    @IBOutlet weak var frontView: UIView!
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    @IBOutlet weak var fullScreenButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleFilm: UILabel!
    @IBOutlet weak var descriptionFilm: UILabel!
    @IBOutlet weak var episodesLabel: UILabel!
    
    // CollectionView
    @IBOutlet weak var categoryFilterCollectionView: UICollectionView!
    private let categoryFilterHandler = CategoryFilterCollectionViewHandler()
    @IBOutlet weak var episodesCollectionView: UICollectionView!
    private let episodesHandler = EpisodesCollectionViewHandler()
    // Constraints
    @IBOutlet weak var aspectRatioConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomToLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomToSafeViewAreaConstraint: NSLayoutConstraint?
    
    // MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.categoryFilterCollectionView.delegate = categoryFilterHandler
        self.categoryFilterCollectionView.dataSource = categoryFilterHandler
        self.episodesCollectionView.delegate = episodesHandler
        self.episodesCollectionView.dataSource = episodesHandler
        self.episodesHandler.delegate = self
        
        // Call API
        self.fetchData()
        
        // Setup UI
        self.setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player?.pause()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isFullscreen {
            playerLayer?.frame = view.bounds
            aspectRatioConstraint.isActive = false
            bottomToLabelConstraint.isActive = false
            bottomToSafeViewAreaConstraint?.isActive = true
        } else {
            playerLayer?.frame = videoContainerView.bounds
            aspectRatioConstraint.isActive = true
            bottomToSafeViewAreaConstraint?.isActive = false
            bottomToLabelConstraint.isActive = true
        }
    }
    
    // MARK: - Setup UI
    public func setupUI(){
        
        self.descriptionFilm.textColor = ColorName.white.color
        self.descriptionFilm.font = .systemFont(ofSize: 14, weight: .medium)
        self.view.backgroundColor = ColorName.primary.color
        self.videoContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        //Category Filter CollectionView
        if let flowLayout = categoryFilterCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            flowLayout.scrollDirection = .horizontal
            flowLayout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 20)
            flowLayout.minimumLineSpacing = 5
        }
        self.categoryFilterCollectionView.register(UINib(nibName: CategoryFilterCollectionViewCell.identifier, bundle: nil),
                                                   forCellWithReuseIdentifier: CategoryFilterCollectionViewCell.identifier)
        self.categoryFilterCollectionView.backgroundColor = .clear
        self.categoryFilterCollectionView.showsHorizontalScrollIndicator = false
        
        // Episodes Collection View
        if let flowLayout = episodesCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            flowLayout.scrollDirection = .vertical
            flowLayout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
            flowLayout.minimumLineSpacing = 5
        }
        self.episodesCollectionView.register(UINib(nibName: EpisodeCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: EpisodeCollectionViewCell.identifier)
        self.episodesCollectionView.backgroundColor = .clear
        self.episodesCollectionView.showsVerticalScrollIndicator = false
    }
    
    // MARK: - Setup Player
    private func setupPlayer(with url: URL) {
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        player = nil
        playerLayer = nil
        
        player = AVPlayer(url: url)
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspect
        playerLayer?.frame = videoContainerView.bounds
        videoContainerView.layer.addSublayer(playerLayer!)
        
        frontView.backgroundColor = .clear
        videoContainerView.bringSubviewToFront(frontView)
        
        player?.play()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return isFullscreen ? .landscape : .portrait
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return isFullscreen
    }
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return isFullscreen ? .all : []
    }
}

// MARK: - Fetch API
extension PlayFilmViewController {
    private func fetchData() {
        Task {
            do {
                self.filmData = try await APIService.getFilmInfo(slug: self.filmURL!)
                print("Film Data: \(filmData!)")
                self.titleFilm.text = filmData?.data.seoOnPage?.titleHead
                self.categoryFilterHandler.movieData = filmData
                self.episodesHandler.movieData = filmData
                self.descriptionFilm.text = filmData?.data.seoOnPage?.descriptionHead
                DispatchQueue.main.async {
                    self.categoryFilterCollectionView.reloadData()
                    self.episodesCollectionView.reloadData()
                }
                if let link = filmData?.data.item?.episodes?.first?.serverData.first?.linkM3U8,
                   let url = URL(string: link) {
                    setupPlayer(with: url)
                } else {
                    print("Không tìm thấy link m3u8")
                }
                
            } catch {
                print("Error: \(error)")
            }
        }
    }
}

// MARK: - Actions
extension PlayFilmViewController: EpisodesCollectionViewHandlerDelegate{
    @IBAction func fullScreenPressed(_ sender: UIButton) {
        //        isFullscreen.toggle()
        //        if let windowScene = view.window?.windowScene {
        //            let orientation: UIInterfaceOrientationMask = isFullscreen ? .landscapeRight : .portrait
        //            let geometryPreferences = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: orientation)
        //            windowScene.requestGeometryUpdate(geometryPreferences) { error in
        //                print("Lỗi xoay màn hình: \(error)")
        //            }
        //        }
        
        //        UIView.animate(withDuration: 0.3) {
        //            self.view.setNeedsLayout()
        //            self.view.layoutIfNeeded()
        //        }
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func didSelectEpisode(with url: URL) {
        setupPlayer(with: url)
    }
}

// MARK: - Category Filter CollectionViewHandler
class CategoryFilterCollectionViewHandler: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    var movieData: ResponseModel?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieData?.data.breadCrumb?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CategoryFilterCollectionViewCell.identifier,
            for: indexPath
        ) as! CategoryFilterCollectionViewCell
        cell.titleLabel.text = movieData?.data.breadCrumb?[indexPath.row].name
        return cell
    }
}

// MARK: - Episodes CollectionViewHandler
class EpisodesCollectionViewHandler: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    var movieData: ResponseModel?
    weak var delegate: EpisodesCollectionViewHandlerDelegate?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieData?.data.item?.episodes![0].serverData.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: EpisodeCollectionViewCell.identifier,
            for: indexPath
        ) as! EpisodeCollectionViewCell
        cell.titleLabel.text = movieData?.data.item?.episodes?[0].serverData[indexPath.row].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let link = movieData?.data.item?.episodes?[0].serverData[indexPath.row].linkM3U8,
           let url = URL(string: link){
            delegate?.didSelectEpisode(with: url)
        }
    }
}
