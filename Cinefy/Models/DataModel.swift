//
//  DataModel.swift
//  RoPhim
//
//  Created by Nguyễn Hiếu on 25/8/25.
//

struct DataModel: Codable {
    let seoOnPage: SEOOnPage
    let items: [Item]
    let itemsSportsVideos: [String]?
    let params: Params
    let typeList: String
    let appDomainFrontend: String
    let appDomainCdnImage: String

    enum CodingKeys: String, CodingKey {
        case seoOnPage
        case items
        case itemsSportsVideos
        case params
        case typeList = "type_list"
        case appDomainFrontend = "APP_DOMAIN_FRONTEND"
        case appDomainCdnImage = "APP_DOMAIN_CDN_IMAGE"
    }
}

struct SEOOnPage: Codable {
    let titleHead: String
    let descriptionHead: String
    let ogType: String
    let ogImage: [String]

    enum CodingKeys: String, CodingKey {
        case titleHead
        case descriptionHead
        case ogType = "og_type"
        case ogImage = "og_image"
    }
}

struct Item: Codable {
    let tmdb: TMDB
    let imdb: IMDB
    let modified: Modified
    let _id: String
    let name: String
    let slug: String
    let originName: String
    let type: String
    let thumbURL: String
    let subDocquyen: Bool
    let time: String
    let episodeCurrent: String
    let quality: String
    let lang: String
    let year: Int
    let category: [Category]
    let country: [Country]

    enum CodingKeys: String, CodingKey {
        case tmdb
        case imdb
        case modified
        case _id
        case name
        case slug
        case originName = "origin_name"
        case type
        case thumbURL = "thumb_url"
        case subDocquyen = "sub_docquyen"
        case time
        case episodeCurrent = "episode_current"
        case quality
        case lang
        case year
        case category
        case country
    }
}

struct TMDB: Codable {
    let type: String
    let id: String
    let season: Int?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case type
        case id
        case season
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

struct IMDB: Codable {
    let id: String?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

struct Modified: Codable {
    let time: String
}

struct Category: Codable {
    let id: String
    let name: String
    let slug: String
}

struct Country: Codable {
    let id: String
    let name: String
    let slug: String
}

struct Params: Codable {
    let typeSlug: String
    let filterCategory: [String]
    let filterCountry: [String]
    let filterYear: String
    let sortField: String
    let pagination: Pagination
    let itemsUpdateInDay: Int?
    let totalSportsVideos: Int?
    let itemsSportsVideosUpdateInDay: Int?

    enum CodingKeys: String, CodingKey {
        case typeSlug = "type_slug"
        case filterCategory
        case filterCountry
        case filterYear
        case sortField
        case pagination
        case itemsUpdateInDay
        case totalSportsVideos
        case itemsSportsVideosUpdateInDay
    }
}

struct Pagination: Codable {
    let totalItems: Int
    let totalItemsPerPage: Int
    let currentPage: Int
    let pageRanges: Int
}
