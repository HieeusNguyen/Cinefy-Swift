//
//  CategoryFilterCollectionViewCell.swift
//  Cinefy
//
//  Created by Nguyễn Hiếu on 22/9/25.
//

import UIKit

class CategoryFilterCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Properties
    static let identifier = "CategoryFilterCollectionViewCell"
    
    // MARK: Init
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.textColor = ColorName.white.color
        self.titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        self.contentView.layer.cornerRadius = 4
        self.contentView.layer.masksToBounds = true
        self.contentView.backgroundColor = .darkGray
    }

}
