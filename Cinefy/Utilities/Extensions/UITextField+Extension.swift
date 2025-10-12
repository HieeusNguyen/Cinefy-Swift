//
//  UITextField+Extension.swift
//  Cinefy
//
//  Created by Nguyễn Hiếu on 12/10/25.
//

import UIKit

extension UITextField{
    func setRightView(_ view: UIView, padding: CGFloat) {
            let container = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width + padding, height: view.frame.height))
            view.frame.origin.x = padding / 2
            container.addSubview(view)
            rightView = container
            rightViewMode = .always
        }
}
