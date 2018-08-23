//
//  Book Data Model.swift
//  Barcode Scanner Practice
//
//  Created by Pierre Liebenberg on 8/14/18.
//  Copyright © 2018 Phase 2. All rights reserved.
//

import Foundation

// Data model for Google Books API
// This model is used as a fallback if our main API call fails to yield a result for the item the user scanned.
// In this event, we'll:
// a) query the Google Books API with the same ISBN number
// b) get the book's title
// c) query the main API again, but, this time, using the book's title instead of the ISBN number.

/// Data model for Google Books API
/// This model is used as a fallback if our main API call fails to yield a result for the item the user scanned.
///
/// In this event, we'll:
/// - a) query the Google Books API with the same ISBN number
/// - b) get the book's title
/// - c) query the main API again, but, this time, using the book's title instead of the ISBN number.

struct FallBackBook: Codable {
    // let kind: String
    // let totalItems: Int
    let items: [Item]
    
    enum CodingKeys: String, CodingKey {
        // case kind = "kind"
        // case totalItems = "totalItems"
        case items = "items"
    }
}

struct Item: Codable {
    // let kind: String
    // let id: String
    // let etag: String
    // let selfLink: String
    let volumeInfo: VolumeInfo
    // let saleInfo: SaleInfo
    // let accessInfo: AccessInfo
    // let searchInfo: SearchInfo
    
    enum CodingKeys: String, CodingKey {
        // case kind = "kind"
        // case id = "id"
        // case etag = "etag"
        // case selfLink = "selfLink"
        case volumeInfo = "volumeInfo"
        // case saleInfo = "saleInfo"
        // case accessInfo = "accessInfo"
        // case searchInfo = "searchInfo"
    }
}
/*
struct AccessInfo: Codable {
    let country: String
    let viewability: String
    let embeddable: Bool
    let publicDomain: Bool
    let textToSpeechPermission: String
    let epub: Epub
    let pdf: Epub
    let webReaderLink: String
    let accessViewStatus: String
    let quoteSharingAllowed: Bool
    
    enum CodingKeys: String, CodingKey {
        case country = "country"
        case viewability = "viewability"
        case embeddable = "embeddable"
        case publicDomain = "publicDomain"
        case textToSpeechPermission = "textToSpeechPermission"
        case epub = "epub"
        case pdf = "pdf"
        case webReaderLink = "webReaderLink"
        case accessViewStatus = "accessViewStatus"
        case quoteSharingAllowed = "quoteSharingAllowed"
    }
}
*/

/*struct Epub: Codable {
    let isAvailable: Bool
    
    enum CodingKeys: String, CodingKey {
        case isAvailable = "isAvailable"
    }
}*/

/*
struct SaleInfo: Codable {
    let country: String
    let saleability: String
    let isEbook: Bool
    
    enum CodingKeys: String, CodingKey {
        case country = "country"
        case saleability = "saleability"
        case isEbook = "isEbook"
    }
}*/

/*
struct SearchInfo: Codable {
    let textSnippet: String
    
    enum CodingKeys: String, CodingKey {
        case textSnippet = "textSnippet"
    }
}*/

struct VolumeInfo: Codable {
    let title: String
    let subtitle: String?
    let authors: [String]
    // let publisher: String
    // let publishedDate: String
    // let description: String
    //let industryIdentifiers: [IndustryIdentifier]
    //let readingModes: ReadingModes
    // let pageCount: Int
    // let printType: String
    // let categories: [String]
    // let maturityRating: String
    // let allowAnonLogging: Bool
    // let contentVersion: String
    let imageLinks: ImageLinks?
    // let language: String
    // let previewLink: String
    let infoLink: String
    // let canonicalVolumeLink: String
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case subtitle = "subtitle"
        case authors = "authors"
        // case publisher = "publisher"
        // case publishedDate = "publishedDate"
        // case description = "description"
        //case industryIdentifiers = "industryIdentifiers"
        //case readingModes = "readingModes"
        // case pageCount = "pageCount"
        // case printType = "printType"
        // case categories = "categories"
        // case maturityRating = "maturityRating"
        // case allowAnonLogging = "allowAnonLogging"
        // case contentVersion = "contentVersion"
        case imageLinks = "imageLinks"
        // case language = "language"
        // case previewLink = "previewLink"
        case infoLink = "infoLink"
        // case canonicalVolumeLink = "canonicalVolumeLink"
    }
}


struct ImageLinks: Codable {
    let smallThumbnail: String?
    let thumbnail: String?
    
    enum CodingKeys: String, CodingKey {
        case smallThumbnail = "smallThumbnail"
        case thumbnail = "thumbnail"
    }
}

/*struct IndustryIdentifier: Codable {
    let type: String
    let identifier: String
    
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case identifier = "identifier"
    }
}

struct ReadingModes: Codable {
    let text: Bool
    let image: Bool
    
    enum CodingKeys: String, CodingKey {
        case text = "text"
        case image = "image"
    }
}*/
