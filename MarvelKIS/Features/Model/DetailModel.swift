//
//  DetailModel.swift
//  MarvelKIS
//
//  Created by Jeeeun Lim on 2022/04/11.
//

import Foundation

// MARK: - Welcome
struct DetailParentInfo: Decodable {
    let data: DataClass

    // MARK: - DataClass
    struct DataClass: Decodable {
        let total, count: Int
        let results: [DetailInfo]?

        // MARK: - Result
        struct DetailInfo: Decodable {
            let id: Int
            let name: String?
            let description: String?
            let thumbnail: Thumbnail?
            let resourceURI: String?
            let comics, series, creators, characters: Comics?
            let stories: Stories?
            let events: Comics?
            let urls: [URLElement]?

        }
    }

}

struct Series: Decodable {
    let id: Int
    let digitalID: Int?
    let name, description, title: String?
    let thumbnail: Thumbnail?

    enum CodingKeys: String, CodingKey {
        case digitalID = "digitalId"
        case description, id, name, title, thumbnail
    }
}


// MARK: - Comics
struct Comics: Decodable {
    let available: Int?
    let collectionURI: String?
    let items: [UrlItem]?
    let returned: Int?
}

// MARK: - Stories
struct Stories: Decodable {
    let available: Int
    let collectionURI: String?
    let items: [UrlItem]?
    let returned: Int?
}

// MARK: - StoriesItem
struct UrlItem: Decodable {
    let resourceURI: String
    let name: String
    let type: TypeEnum?
}

enum TypeEnum: String, Decodable {
    case cover = "cover"
    case empty = ""
    case interiorStory = "interiorStory"
}

// MARK: - URLElement
struct URLElement: Decodable {
    let type: String
    let url: String
}
