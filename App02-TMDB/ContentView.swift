//
//  ContentView.swift
//  App02-TMDB
//
//  Created by Diego Sabillón on 21/09/24.
//
import SwiftUI
import Kingfisher

struct ContentView: View {
    @Environment(MoviesData.self) var moviesData
    @State private var selectedCategory: MovieCategory = .nowPlaying // Default to Now Playing

    var body: some View {
        TabView {
            // First tab: Movie List
            NavigationStack {
                VStack {
                    Picker("Select Category", selection: $selectedCategory) {
                        ForEach(MovieCategory.allCases, id: \.self) { category in
                            Text(category.rawValue.capitalized)
                                .tag(category) // Make sure to tag each option
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()

                    List {
                        ForEach(moviesData.movies) { movie in
                            HStack {
                                Text(movie.title)
                                Spacer()
                                KFImage.url(URL(string: "https://image.tmdb.org/t/p/original\(movie.posterPath)"))
                                    .cacheMemoryOnly()
                                    .fade(duration: 0.25)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100)
                            }
                        }
                    }
                }
                .navigationTitle("Movies")
                .onAppear {
                    Task {
                        await fetchMovies(category: selectedCategory)
                    }
                }
                .onChange(of: selectedCategory) { newCategory in
                    Task {
                        await fetchMovies(category: newCategory)
                    }
                }
            }
            .tabItem {
                Label("Movies", systemImage: "film")
            }
            
            // Second tab: Profile
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
    }

    // Function to fetch movies based on the selected category
    func fetchMovies(category: MovieCategory) async {
        switch category {
        case .popular:
            await moviesData.fetchPopularMovies()
        case .nowPlaying:
            await moviesData.fetchNowPlayingMovies()
        case .topRated:
            await moviesData.fetchTopRatedMovies()
        }
    }
}

enum MovieCategory: String, CaseIterable {
    case popular = "Popular"
    case nowPlaying = "Now Playing"
    case topRated = "Top Rated"
}

#Preview {
    ContentView()
        .environment(MoviesData())
}
