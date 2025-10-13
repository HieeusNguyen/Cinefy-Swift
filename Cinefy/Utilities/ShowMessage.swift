//
//  ShowMessage.swift
//  Cinefy
//
//  Created by Nguyễn Hiếu on 13/10/25.
//

import UIKit

enum MessageType {
    case success
    case error
    case info
}

final class ShowMessage{
    static func show(_ message: String, type: MessageType = .info, in viewController: UIViewController?, actionPressed: (() -> Void)? = nil ) {
        let alert = UIAlertController(title: title(for: type), message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { _ in
            actionPressed?()
        }
        alert.addAction(action)
        viewController?.present(alert, animated: true)
    }
    
    private static func title(for type: MessageType) -> String {
        switch type {
        case .success: return "Thành công"
        case .error: return "Lỗi"
        case .info: return "Thông báo"
        }
    }
}
