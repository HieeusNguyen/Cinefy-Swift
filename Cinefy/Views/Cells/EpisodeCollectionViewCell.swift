//
//  EpisodeCollectionViewCell.swift
//  Cinefy
//
//  Created by Nguyễn Hiếu on 1/10/25.
//

import UIKit

class EpisodeCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "EpisodeCollectionViewCell"

    // MARK: - Properties
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Init
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 4
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = ColorName.white.color.cgColor
        self.titleLabel.textColor = ColorName.white.color
        self.titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
    }

}
