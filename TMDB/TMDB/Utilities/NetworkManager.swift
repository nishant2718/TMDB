//
//  NetworkManager.swift
//  TMDB
//
//  Created by Nishant Patel on 7/25/23.
//

import UIKit

protocol MoviesProvider {
    func getMoviesFor(_ keyword: String,
                      and page: Int,
                      using urlSession: URLSession) async throws -> ([Movie], Int)

    func getPosterImageUsing(_ link: String,
                             with urlSession: URLSession) async throws -> UIImage
}

enum NetworkingError: Error {
    case badUrl
    case badResponse
    case badData
}

class NetworkManager: MoviesProvider {
    private let cache = NSCache<NSString, UIImage>()
    private let decoder = JSONDecoder()
    private let prefixEndpoint = "https://api.themoviedb.org/3/search/movie?api_key=b11fc621b3f7f739cb79b50319915f1d&language=en-US&query="
    private let suffixEndpoint = "&page="
    private let posterImageEndpoint = "https://image.tmdb.org/t/p/original"

    init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    func getMoviesFor(_ keyword: String,
                      and page: Int,
                      using urlSession: URLSession = .shared) async throws -> ([Movie], Int) {
        let endpoint = "\(prefixEndpoint)\(keyword)\(suffixEndpoint)\(page)"
        
        guard let url = URL(string: endpoint) else {
            throw NetworkingError.badUrl
        }
        
        let (data, response) = try await urlSession.data(from: url)
        
        guard let response = response as? HTTPURLResponse,
                (200...300) ~= response.statusCode else {
            throw NetworkingError.badResponse
        }
        
        do {
            let movies = try decoder.decode(Movies.self, from: data)
            return (movies.results, movies.totalPages)
        } catch let error {
            print(error)
            throw NetworkingError.badData
        }
    }
    
    // NOTE: TMDB gives us back HEAVY images, and also forces 20 results per page (with no option to decrease it).
    // This causes visible UI stuttering issues on scrolling when NOT cached.
    func getPosterImageUsing(_ link: String,
                             with urlSession: URLSession = .shared) async throws -> UIImage {
        let endpoint = "\(posterImageEndpoint)\(link)"
        
        if let image = cache.object(forKey: NSString(string: endpoint)) {
            return image
        }
        
        guard let url = URL(string: endpoint) else {
            throw NetworkingError.badUrl
        }
        
        let (data, response) = try await urlSession.data(from: url)

        guard let response = response as? HTTPURLResponse,
                (200...300) ~= response.statusCode else {
            throw NetworkingError.badResponse
        }
        
        guard let image = UIImage(data: data) else {
            throw NetworkingError.badData
        }
        
        cache.setObject(image, forKey: NSString(string: endpoint))
        
        return image
    }
}
