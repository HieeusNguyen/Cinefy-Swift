//
//  ViewingRecentTableViewCell.swift
//  Cinefy
//
//  Created by Nguyễn Hiếu on 14/10/25.
//

import UIKit

class ViewingRecentTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var filmImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Properties
    static let identifier = "ViewingRecentTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.filmImageView.layer.cornerRadius = filmImageView.frame.size.width / 8
        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLabel.numberOfLines = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
