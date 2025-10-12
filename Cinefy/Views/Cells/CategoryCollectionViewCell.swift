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
    
    // MARK: - Properties
    static let identifier = "CategoryCollectionViewCell"
    
    // MARK: - Init
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.textColor = ColorName.white.color
        contentView.layer.cornerRadius = 14
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = ColorName.white.color.cgColor
        contentView.backgroundColor = .clear
    }

}
