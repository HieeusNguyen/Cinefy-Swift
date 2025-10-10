//
//  EpisodeCollectionViewCell.swift
//  Cinefy
//
//  Created by Nguyễn Hiếu on 1/10/25.
//

import UIKit

class EpisodeCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties
    static let identifier = "EpisodeCollectionViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Init
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 6
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = ColorName.white.color.cgColor
        self.titleLabel.textColor = ColorName.white.color
        self.titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
    }

}
