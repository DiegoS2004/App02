//
//  Fav.swift
//  App02-TMDB
//
//  Created by Diego Sabillón on 21/09/24.
//
import SwiftUI
import SwiftData

@Model
final class Fav {
    
    var id: Int
    var title: String
    var overview: String
    var posterPath: String
    var backdropPath: String
    var genreIds: [Int]
    var originalLanguage: String
    var originalTitle: String
    var popularity: Double
    var releaseDate: String
    var voteAverage: Double
    var voteCount: Int
    
    init(id: Int, title: String, overview: String, posterPath: String, backdropPath: String, genreIds: [Int], originalLanguage: String, originalTitle: String, popularity: Double, releaseDate: String, voteAverage: Double, voteCount: Int) {
        self.id = id
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.genreIds = genreIds
        self.originalLanguage = originalLanguage
        self.originalTitle = originalTitle
        self.popularity = popularity
        self.releaseDate = releaseDate
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }
}
