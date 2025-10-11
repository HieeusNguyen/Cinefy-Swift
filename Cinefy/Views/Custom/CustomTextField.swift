//
//  CustomTextField.swift
//  Cinefy
//
//  Created by Nguyễn Hiếu on 11/10/25.
//

import UIKit

final class CustomTextField: UITextField{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupUI()
    }
    
    private func setupUI(){
        layer.cornerRadius = 8
        layer.masksToBounds = true
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        leftViewMode = .always
        font = .systemFont(ofSize: 16, weight: .medium)
        textColor = ColorName.white.color
        attributedPlaceholder = NSAttributedString(string: placeholder ?? "",
                                                   attributes: [.foregroundColor: UIColor.gray])
        backgroundColor = .clear
        heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}

