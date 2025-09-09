//
//  CustomLabelTag.swift
//  RoPhim
//
//  Created by Nguyễn Hiếu on 8/9/25.
//

import UIKit

final class CustomLabelTag: UILabel {
    
    // MARK: - Properties
    @IBInspectable
    var cornerRadius: CGFloat = 6 {
        didSet { setupUI() }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 2 {
        didSet { setupUI() }
    }
    
    @IBInspectable
    var borderColor: UIColor = .white {
        didSet { setupUI() }
    }
    
    @IBInspectable var startColor: UIColor? { didSet { updateGradient() } }
    @IBInspectable var endColor: UIColor? { didSet { updateGradient() } }
    
    private var gradientLayer: CAGradientLayer?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupUI()
        updateGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = bounds
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.clipsToBounds = true
        self.font = UIFont.systemFont(ofSize: 12, weight: .bold)
    }
    
    // MARK: - Set Padding for label
    @IBInspectable var topInset: CGFloat = 6.0
    @IBInspectable var bottomInset: CGFloat = 6.0
    @IBInspectable var leftInset: CGFloat = 12.0
    @IBInspectable var rightInset: CGFloat = 12.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
    
    // MARK: - Gradient
    private func updateGradient() {
        guard let start = startColor, let end = endColor else {
            gradientLayer?.removeFromSuperlayer()
            gradientLayer = nil
            return
        }
        
        if gradientLayer == nil {
            let newGradientLayer = CAGradientLayer()
            layer.insertSublayer(newGradientLayer, at: 0)
            gradientLayer = newGradientLayer
        }
        
        gradientLayer?.colors = [start.cgColor, end.cgColor]
        gradientLayer?.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer?.endPoint = CGPoint(x: 1, y: 0.5)
    }

}
