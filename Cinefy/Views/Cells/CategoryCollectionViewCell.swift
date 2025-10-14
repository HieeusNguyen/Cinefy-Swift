//
//  CategoryCollectionViewCell.swift
//  RoPhim
//
//  Created by Nguyễn Hiếu on 25/8/25.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var arrowDownImageView: UIImageView!
    
    // MARK: - Properties
    static let identifier = "CategoryCollectionViewCell"
    
    // MARK: - Init
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.textColor = ColorName.white.color
        titleLabel.attributedText = NSAttributedString(
            string: "...",
            attributes: [.font: UIFont.systemFont(ofSize: 11, weight: .medium)]
        )
        arrowDownImageView.tintColor = .white
        arrowDownImageView.isHidden = true
        contentView.layer.cornerRadius = 8.0
        contentView.clipsToBounds = true
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = ColorName.white.color.cgColor
        contentView.backgroundColor = .clear
    }

}
