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
    static func getHomePageData(completion: @escaping (Result<ResponseModel, Error>) -> Void) {
        AF.request(HOME_ENDPOINT).responseDecodable(of: ResponseModel.self) { response in
            switch response.result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                print("Error: \(error)")
                completion(.failure(error))
            }
        }
    }
}
