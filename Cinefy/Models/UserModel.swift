//
//  UserModel.swift
//  Cinefy
//
//  Created by Nguyễn Hiếu on 13/10/25.
//

import Foundation
import FirebaseCore

public struct UserModel: Codable{
    let name: String
    let email: String
    let password: String
    let photoURL: URL?
    let createdAt: Timestamp
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case password
        case photoURL = "photo_url"
        case createdAt = "created_at"
    }
    
    init(name: String, email: String, password: String, photoURL: URL? = nil, createdAt: Timestamp) {
        self.name = name
        self.email = email
        self.password = password
        self.photoURL = photoURL ?? URL(string: "https://i.pinimg.com/736x/bc/43/98/bc439871417621836a0eeea768d60944.jpg")
        self.createdAt = createdAt
    }
}
