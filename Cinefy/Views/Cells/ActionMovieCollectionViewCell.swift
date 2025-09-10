//
//  ActionMovieCollectionViewCell.swift
//  Cinefy
//
//  Created by Nguyễn Hiếu on 10/9/25.
//

import UIKit

class ActionMovieCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties
    static let identifier: String = "ActionMovieCollectionViewCell"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Setup UI
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView.layer.cornerRadius = 10
        self.imageView.layer.masksToBounds = true
        self.imageView.contentMode = .scaleAspectFill
        self.titleLabel.numberOfLines = 1
        self.titleLabel.font = .systemFont(ofSize: 11.0, weight: .regular)
        self.titleLabel.textAlignment = .center
    }

}
