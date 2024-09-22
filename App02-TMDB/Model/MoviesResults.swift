//
//  MoviesResults.swift
//  App02-TMDB
//
//  Created by Diego Sabillón on 21/09/24.
//

import Foundation

struct Dates: Codable {
    var maximum: String
    var minimum: String
}

struct MoviesResults: Codable {
    var dates: Dates
    var page: Int
    var results: [Movie]
    var totalPages: Int
    var totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case dates
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
