//
//  APIModel.swift
//  MarvelKIS
//
//  Created by Jeeeun Lim on 2022/04/09.
//

import Foundation

struct MainList: Decodable {
    let data: DataClass
    let status: String
    enum CodingKeys: String, CodingKey {
        case data, status
    }
    struct DataClass: Decodable {
        let items: [Character]

        enum CodingKeys: String, CodingKey {
            case items = "results"
        }
    }
}

struct Thumbnail: Codable {
    let path: String
    let thumbnailExtension: String

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
    
    init(path: String, thumbnailExtension: String) {
        self.path = path
        self.thumbnailExtension = thumbnailExtension
    }
}



struct Character: Codable {
    let id: Int
    let name, description: String?
    let thumbnail: Thumbnail?

    enum CodingKeys: String, CodingKey {
        case description, id, name, thumbnail
    }

    init(id: Int, name: String, thumbnail: Thumbnail, description: String? = "") {
        self.name = name
        self.id = id
        self.thumbnail = thumbnail
        self.description = description
    }

}



struct Diary: Codable {
    let contentText: String
    let id:Int

    enum CodingKeys: String, CodingKey {
        case contentText, id
    }

    init(id: Int, contentText: String = "") {
        self.contentText = contentText
        self.id = id
    }

}
