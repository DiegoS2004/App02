//
//  MoviesData.swift
//  App02-TMDB
//
//  Created by Diego Sabillón on 21/09/24.
//
import Foundation

@Observable
class MoviesData {
    var movies: [Movie] = []

    func fetchNowPlayingMovies() async {
        await fetchMovies(from: "https://api.themoviedb.org/3/movie/now_playing")
    }

    func fetchPopularMovies() async {
        await fetchMovies(from: "https://api.themoviedb.org/3/movie/popular")
    }

    func fetchTopRatedMovies() async {
        await fetchMovies(from: "https://api.themoviedb.org/3/movie/top_rated")
    }

    private func fetchMovies(from urlString: String) async {
        guard let url = URL(string: urlString) else { return }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "api_key", value: "3ffaa88b6a551a6fe8653d4347ca82f8") // Your API Key
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = ["accept": "application/json"]

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedResponse = try JSONDecoder().decode(MoviesResults.self, from: data)
            movies = decodedResponse.results
        } catch {
            print("Failed to fetch movies: \(error.localizedDescription)")
        }
    }
}
