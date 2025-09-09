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
    static let DOMAIN_CDN_IMAGE = "https://img.ophim.live/uploads/movies/"
    static let HOME_ENDPOINT = "https://ophim1.com/v1/api/home"
    
    // MARK: - FETCH API
    static func getHomePageData() async throws -> ResponseModel {
        try await AF.request(HOME_ENDPOINT)
            .validate()
            .serializingDecodable(ResponseModel.self)
            .value
    }

}
