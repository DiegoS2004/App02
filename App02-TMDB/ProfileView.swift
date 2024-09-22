//
//  ProfileView.swift
//  App02-TMDB
//
//  Created by Diego Sabillón on 21/09/24.
//
import SwiftUI
import Kingfisher

struct ProfileView: View {
    @State private var name: String = "" // State for storing the user's name
    @State private var profileImage: Image? = nil // State for storing the profile image
    @State private var isImagePickerPresented = false // Controls if the image picker is presented
    @State private var upcomingMovies: [Movie] = [] // State for storing upcoming movies

    var body: some View {
        VStack(spacing: 20) {
            // Profile Image
            if let profileImage = profileImage {
                profileImage
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .clipShape(Circle()) // Circular image
                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
            } else {
                // Placeholder for the profile image
                Circle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 150, height: 150)
                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                    .onTapGesture {
                        isImagePickerPresented = true // Show image picker
                    }
            }

            // Button to change the profile image
            Button("Change Profile Picture") {
                isImagePickerPresented = true
            }
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(selectedImage: $profileImage) // Custom Image Picker
            }

            // TextField for the name
            TextField("Enter your name", text: $name)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)

            // Recommended Movies section
            Text("Recommended Upcoming Movies for \(name.isEmpty ? "You" : name)")
                .font(.headline)
                .padding(.top)

            List(upcomingMovies) { movie in
                HStack {
                    KFImage.url(URL(string: "https://image.tmdb.org/t/p/original\(movie.posterPath)"))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25)
                    Text(movie.title)
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Profile")
        .onAppear {
            Task {
                await fetchUpcomingMovies()
            }
        }
    }

    // Fetch upcoming movies from the API
    private func fetchUpcomingMovies() async {
        let url = URL(string: "https://api.themoviedb.org/3/movie/upcoming")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "api_key", value: "3ffaa88b6a551a6fe8653d4347ca82f8") // Replace with your API key
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = ["accept": "application/json"]

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            if let decodedResponse = try? JSONDecoder().decode(MoviesResults.self, from: data) {
                upcomingMovies = decodedResponse.results
            }
        } catch {
            print("Error fetching upcoming movies: \(error)")
        }
    }
}

#Preview {
    ProfileView()
}
