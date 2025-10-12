//
//  MenuTableViewCell.swift
//  Cinefy
//
//  Created by Nguyễn Hiếu on 10/10/25.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var arrowRightImageView: UIImageView!

    // MARK: - Properties
    static let identifier = "MenuTableViewCell"
    
    // MARK: - Init
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = ColorName.primary.color
        menuImageView.tintColor = ColorName.white.color
        titleLabel.textColor = ColorName.white.color
        arrowRightImageView.tintColor = ColorName.white.color
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
