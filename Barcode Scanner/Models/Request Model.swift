//
//  Request Model.swift
//  Barcode Scanner Practice
//
//  Created by Pierre Liebenberg on 8/15/18.
//  Copyright © 2018 Phase 2. All rights reserved.
//

import Foundation

struct Search: Codable {
    
    var limit: Int
    var search_type: String
    var term: String
}

struct BookSearch: Codable {
    var search: Search
}
