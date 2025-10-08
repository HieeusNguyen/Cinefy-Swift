//
//  DataModel.swift
//  RoPhim
//
//  Created by Nguyễn Hiếu on 25/8/25.
//

struct DataModel: Codable {
    let seoOnPage: SEOOnPage?
    let items: [Item]?
    let itemsSportsVideos: [String]?
    let breadCrumb: [BreadCrumb]?
    let params: Params?
    let item: Item?
    let typeList: String?
    let appDomainFrontend: String?
    let appDomainCdnImage: String?

    enum CodingKeys: String, CodingKey {
        case seoOnPage
        case items
        case itemsSportsVideos
        case breadCrumb
        case params
        case item
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
    let seoSchema: SEOSchema?
    let updatedTime: Int64?
    let ogURL: String?

    enum CodingKeys: String, CodingKey {
        case titleHead
        case descriptionHead
        case ogType = "og_type"
        case ogImage = "og_image"
        case seoSchema
        case updatedTime = "updated_time"
        case ogURL = "og_url"
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
    let content: String?
    let type: String
    let status: String?
    let thumbURL: String
    let posterURL: String?
    let isCopyright: Bool?
    let subDocquyen: Bool
    let time: String
    let episodeCurrent: String
    let episodeTotal: String?
    let quality: String
    let lang: String
    let notify: String?
    let showtimes: String?
    let year: Int
    let view: Int?
    let actor: [String]?
    let director: [String]?
    let category: [Category]
    let country: [Country]
    let episodes: [Episode]?

    enum CodingKeys: String, CodingKey {
        case tmdb
        case imdb
        case modified
        case _id
        case name
        case slug
        case originName = "origin_name"
        case content
        case type
        case status
        case thumbURL = "thumb_url"
        case posterURL = "poster_url"
        case isCopyright = "is_copyright"
        case subDocquyen = "sub_docquyen"
        case time
        case episodeCurrent = "episode_current"
        case episodeTotal = "episode_total"
        case quality
        case lang
        case notify
        case showtimes
        case year
        case view
        case actor
        case director
        case category
        case country
        case episodes
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
    let typeSlug: String?
    let filterCategory: [String]?
    let filterCountry: [String]?
    let filterYear: String?
    let sortField: String?
    let pagination: Pagination?
    let itemsUpdateInDay: Int?
    let totalSportsVideos: Int?
    let itemsSportsVideosUpdateInDay: Int?
    let slug: String?

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
        case slug
    }
}

struct Pagination: Codable {
    let totalItems: Int
    let totalItemsPerPage: Int
    let currentPage: Int
    let pageRanges: Int
}

struct SEOSchema: Codable {
    let context: String
    let type: String
    let name: String
    let dateModified: String
    let dateCreated: String
    let url: String
    let datePublished: String
    let image: String?
    let director: String?
    
    enum CodingKeys: String, CodingKey {
        case context = "@context"
        case type = "@type"
        case name
        case dateModified
        case dateCreated
        case url
        case datePublished
        case image
        case director
    }
}

struct BreadCrumb: Codable {
    let name: String
    let slug: String?
    let isCurrent: Bool?
    let position: Int
    
    enum CodingKeys: String, CodingKey{
        case name
        case slug
        case isCurrent
        case position
    }
}

struct Episode: Codable {
    let serverName: String
    let serverData: [ServerData]
    
    enum CodingKeys: String, CodingKey {
        case serverName = "server_name"
        case serverData = "server_data"
    }
}

struct ServerData: Codable{
    let name: String
    let slug: String
    let fileName: String
    let linkEmbed: String
    let linkM3U8: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case slug
        case fileName = "filename"
        case linkEmbed = "link_embed"
        case linkM3U8 = "link_m3u8"
    }
}
