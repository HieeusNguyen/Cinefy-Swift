//
//  ResponseModel.swift
//  RoPhim
//
//  Created by Nguyễn Hiếu on 25/8/25.
//

struct ResponseModel: Codable{
    let status: String
    let message: String
    let data: DataModel
}
