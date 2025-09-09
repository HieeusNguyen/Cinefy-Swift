//
//  CustomButton.swift
//  RoPhim
//
//  Created by Nguyễn Hiếu on 7/9/25.
//

import UIKit

@IBDesignable
final class CustomButton: UIButton {
    // MARK: - Properties
    @IBInspectable
    var customBackgroundColor: UIColor? = ColorName.lightYellow.color {
        didSet {
            setupButton()
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupButton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    // MARK: - Setup
    private func setupButton() {
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.backgroundColor = customBackgroundColor
    }
    
}
