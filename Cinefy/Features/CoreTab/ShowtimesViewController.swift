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
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorName.primary.color
    }

}
