//
//  PlayFilmViewController.swift
//  Cinefy
//
//  Created by Nguyễn Hiếu on 10/9/25.
//

import UIKit

class PlayFilmViewController: UIViewController {
    
    var filmURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorName.primary.color
//        let filmData = APIService.getFilmInfo(slug: filmURL!)
        print("Link Film: \(APIService.FILM_PROTOCOL)\(APIService.FILM_ENDPOINT)\(self.filmURL ?? "")")
    }


}
