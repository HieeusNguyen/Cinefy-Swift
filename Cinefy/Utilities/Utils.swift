//
//  Utils.swift
//  Cinefy
//
//  Created by Nguyễn Hiếu on 9/10/25.
//

class Utils{
    
    static func formatString(_ input: String) -> String {
        var noDiacritics = input.folding(options: .diacriticInsensitive, locale: .current)
        noDiacritics = noDiacritics
            .replacingOccurrences(of: "đ", with: "d")
            .replacingOccurrences(of: "Đ", with: "d")
        let formatted = noDiacritics
            .lowercased()
            .replacingOccurrences(of: "\\s+", with: "-", options: .regularExpression)
        
        return formatted
    }
    
}
