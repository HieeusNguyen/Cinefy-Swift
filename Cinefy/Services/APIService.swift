//
//  APIService.swift
//  RoPhim
//
//  Created by Nguyễn Hiếu on 25/8/25.
//

import Foundation
import Alamofire

public class APIService{
    
    // MARK: - API
    static let FILM_PROTOCOL = "https://ophim1.com"
    static let DOMAIN_CDN_IMAGE = "https://img.ophim.live/uploads/movies/"
    static let HOME_ENDPOINT = "/v1/api/home"
    static let ACTION_MOVIE_ENDPOINT = "/v1/api/the-loai/hanh-dong"
    static let FILM_ENDPOINT = "/v1/api/phim/"
    static let SEARCH_ENDPOINT = "/v1/api/tim-kiem?keyword="
    
    // MARK: - FETCH API
    static func getHomePageData() async throws -> ResponseModel {
        try await AF.request("\(FILM_PROTOCOL)\(HOME_ENDPOINT)")
            .validate()
            .serializingDecodable(ResponseModel.self)
            .value
    }
    
    static func getActionMovieData() async throws -> ResponseModel {
        try await AF.request("\(FILM_PROTOCOL)\(ACTION_MOVIE_ENDPOINT)")
            .validate()
            .serializingDecodable(ResponseModel.self)
            .value
    }
    
    static func getFilmInfo(slug: String) async throws -> ResponseModel {
        try await AF.request("\(FILM_PROTOCOL)\(FILM_ENDPOINT)\(slug)")
            .validate()
            .serializingDecodable(ResponseModel.self)
            .value
    }
    
    static func searchFilm(keyword: String) async throws -> ResponseModel {
        try await AF.request("\(FILM_PROTOCOL)\(SEARCH_ENDPOINT)[\(keyword)]")
            .validate()
            .serializingDecodable(ResponseModel.self)
            .value
    }

}
