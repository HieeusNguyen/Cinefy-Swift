//
//  MovieGenreCollectionViewCell.swift
//  Cinefy
//
//  Created by Nguyễn Hiếu on 9/9/25.
//

import UIKit

class MovieGenreCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!

    // MARK: - Properties
    static let identifier: String = "MovieGenreCollectionViewCell"
    private var gradientLayer: CAGradientLayer?

    // MARK: - Setup UI
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleLabel.font = .systemFont(ofSize: 18.0, weight: .bold)
        self.titleLabel.textColor = ColorName.white.color
        self.titleLabel.textAlignment = .center
        self.titleLabel.numberOfLines = 2
        
        self.contentView.layer.cornerRadius = 8.0
        self.contentView.layer.masksToBounds = true
        
        setupGradient()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = self.contentView.bounds
    }
    
    // MARK: - Gradient
    private func setupGradient() {
        gradientLayer?.removeFromSuperlayer()
        
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.systemPurple.cgColor,
            UIColor.systemBlue.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.frame = self.contentView.bounds
        gradient.cornerRadius = 8.0

        self.contentView.layer.insertSublayer(gradient, at: 0)
        self.gradientLayer = gradient
    }
}
