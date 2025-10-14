//
//  ViewedModel.swift
//  Cinefy
//
//  Created by Nguyễn Hiếu on 13/10/25.
//

import FirebaseCore

public struct ViewedModel: Codable{
    let title: String
    let url: String
    let photoURL: String
    let watchedAt: Timestamp
    
    enum CodingKeys: String, CodingKey {
        case title
        case url
        case photoURL = "photo_url"
        case watchedAt = "watched_at"
    }
    
    init(title: String, url: String, photoURL: String, watchedAt: Timestamp) {
        self.title = title
        self.url = url
        self.photoURL = photoURL
        self.watchedAt = watchedAt
    }
}
