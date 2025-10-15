//
//  PlayFilmViewController.swift
//  Cinefy
//
//  Created by Nguyễn Hiếu on 10/9/25.
//

import UIKit
import AVFoundation
import FirebaseAuth
import FirebaseFirestore
import BMPlayer

class PlayFilmViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var player: BMPlayer!
    @IBOutlet weak var titleFilm: UILabel!
    @IBOutlet weak var descriptionFilm: UILabel!
    @IBOutlet weak var episodesLabel: UILabel!
    
    // MARK: - Properties
    var filmURL: String?
    private var filmData: ResponseModel?
    private var isMovie: Bool = false
    private let categoryFilterHandler = CategoryFilterCollectionViewHandler()
    private let episodesHandler = EpisodesCollectionViewHandler()
    private let db = Firestore.firestore()
    private let user = Auth.auth().currentUser
    
    // CollectionView
    @IBOutlet weak var categoryFilterCollectionView: UICollectionView!
    @IBOutlet weak var episodesCollectionView: UICollectionView!
    
    // Constraints
    @IBOutlet weak var aspectRatioConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomToLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomToSafeViewAreaConstraint: NSLayoutConstraint?
    
    // MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        player.autoPlay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.categoryFilterCollectionView.delegate = categoryFilterHandler
        self.categoryFilterCollectionView.dataSource = categoryFilterHandler
        self.episodesCollectionView.delegate = episodesHandler
        self.episodesCollectionView.dataSource = episodesHandler
        self.episodesHandler.delegate = self
        
        player.delegate = self
        
        // Call API
        self.fetchData()
        
        // Setup UI
        self.setupUI()
        
        player.backBlock = { [unowned self] (isFullScreen) in
            if isFullScreen == true { return }
            let _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.pause(allowAutoPlay: true)
    }
    
    deinit{
        player.prepareToDealloc()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    // MARK: - Setup UI
    private func setupUI(){
        
        self.descriptionFilm.textColor = ColorName.white.color
        self.descriptionFilm.font = .systemFont(ofSize: 14, weight: .medium)
        self.view.backgroundColor = ColorName.primary.color
        
        
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
            flowLayout.minimumLineSpacing = 10
        }
        self.episodesCollectionView.register(UINib(nibName: EpisodeCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: EpisodeCollectionViewCell.identifier)
        self.episodesCollectionView.backgroundColor = .clear
        self.episodesCollectionView.showsVerticalScrollIndicator = false
    }
    
    // MARK: - Setup Player
    private func setupPlayer(with url: URL) {
        
        let asset = BMPlayerResource(url: URL(string: url.absoluteString)!,
                                     name: "")
        player.setVideo(resource: asset)
    }
    


}

// MARK: - Fetch API
extension PlayFilmViewController {
    private func fetchData() {
        Task {
            do {
                self.filmData = try await APIService.getFilmInfo(slug: self.filmURL!)
                
                //Save ViewingRecent to Firebase
                self.saveViewingRecent(filmData: filmData!)
                
                
                self.categoryFilterHandler.movieData = filmData
                self.episodesHandler.movieData = filmData

                DispatchQueue.main.async {
                    self.titleFilm.text = self.filmData?.data.seoOnPage?.titleHead
                    self.descriptionFilm.text = self.filmData?.data.seoOnPage?.descriptionHead
                    self.categoryFilterCollectionView.reloadData()
                    self.episodesCollectionView.reloadData()
                    self.episodesCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
                }
                if let link = filmData?.data.item?.episodes?.first?.serverData.first?.linkM3U8,
                   let url = URL(string: link) {
                    setupPlayer(with: url)
                } else {
                    print("Not found link m3u8")
                }
                
            } catch {
                print("Error: \(error)")
            }
        }
    }
}

// MARK: - Actions
extension PlayFilmViewController: EpisodesCollectionViewHandlerDelegate{
    
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
    var selectedIndex: IndexPath = IndexPath(item: 0, section: 0)
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieData?.data.item?.episodes![0].serverData.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: EpisodeCollectionViewCell.identifier,
            for: indexPath
        ) as! EpisodeCollectionViewCell
        cell.titleLabel.text = movieData?.data.item?.episodes?[0].serverData[indexPath.row].name
        
        if indexPath == selectedIndex {
            cell.backgroundColor = ColorName.white.color
            cell.titleLabel.textColor = ColorName.black.color
            cell.layer.cornerRadius = 6
            cell.layer.masksToBounds = true
            cell.layer.borderWidth = 2
            cell.layer.borderColor = ColorName.white.color.cgColor
        } else {
            cell.backgroundColor = .clear
            cell.titleLabel.textColor = .white
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath
        collectionView.reloadData()
        
        if let link = movieData?.data.item?.episodes?[0].serverData[indexPath.row].linkM3U8,
           let url = URL(string: link){
            delegate?.didSelectEpisode(with: url)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 33)/4, height: 30)
    }
}

// MARK: - Save ViewingRecent Logic
extension PlayFilmViewController{
    
    func saveViewingRecent(filmData: ResponseModel){
        let viewedData = ViewedModel(
            title: filmData.data.seoOnPage?.titleHead ?? "",
            url: filmData.data.params?.slug ?? "",
            photoURL: filmData.data.seoOnPage?.seoSchema?.image ?? "",
            watchedAt: Timestamp(date: Date())
        )
        do{
            try db.collection("users").document((user?.email)!).collection("viewing_recent").document(filmData.data.params?.slug ?? "").setData(from: viewedData)
            print("Saved successfully ViewingRecent")
        }catch{
            print("Error: \(error)")
        }
    }
}

extension PlayFilmViewController: BMPlayerDelegate{
    func bmPlayer(player: BMPlayer, playerOrientChanged isFullscreen: Bool) {
      player.snp.remakeConstraints { (make) in
        make.top.equalTo(view.snp.top)
        make.left.equalTo(view.snp.left)
        make.right.equalTo(view.snp.right)
        if isFullscreen {
          make.bottom.equalTo(view.snp.bottom)
        } else {
          make.height.equalTo(view.snp.width).multipliedBy(9.0/16.0).priority(500)
        }
      }
    }
    
    // Call back when playing state changed, use to detect is playing or not
    func bmPlayer(player: BMPlayer, playerIsPlaying playing: Bool) {
      print("| BMPlayerDelegate | playerIsPlaying | playing - \(playing)")
    }
    
    // Call back when playing state changed, use to detect specefic state like buffering, bufferfinished
    func bmPlayer(player: BMPlayer, playerStateDidChange state: BMPlayerState) {
      print("| BMPlayerDelegate | playerStateDidChange | state - \(state)")
    }
    
    // Call back when play time change
    func bmPlayer(player: BMPlayer, playTimeDidChange currentTime: TimeInterval, totalTime: TimeInterval) {
      //        print("| BMPlayerDelegate | playTimeDidChange | \(currentTime) of \(totalTime)")
    }
    
    // Call back when the video loaded duration changed
    func bmPlayer(player: BMPlayer, loadedTimeDidChange loadedDuration: TimeInterval, totalDuration: TimeInterval) {
      //        print("| BMPlayerDelegate | loadedTimeDidChange | \(loadedDuration) of \(totalDuration)")
    }
}
