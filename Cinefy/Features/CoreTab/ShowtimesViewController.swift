//
//  ShowtimesViewController.swift
//  RoPhim
//
//  Created by Nguyễn Hiếu on 25/8/25.
//

import UIKit
import BMPlayer

class ShowtimesViewController: UIViewController {

    @IBOutlet weak var player: BMPlayer!
    
    override func viewWillAppear(_ animated: Bool) {
        player.autoPlay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorName.primary.color
        let asset = BMPlayerResource(url: URL(string: "https://vip.opstream14.com/20230321/33905_262f8bb8/index.m3u8")!,
                                     name: "爱")
        player.setVideo(resource: asset)
    }

}
