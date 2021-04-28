//
//  MovieDBClient.swift
//  SwiftMovieDB
//
//  Created by Arwin Oblea on 4/27/21.
//

import Foundation
import UIKit

enum APIError: Error {
  case requestFailed
  case invalidData
  case responseUnsuccessful
  case jsonParsingFailure
  case jsonConversionFailure
  
  var localizedDescription: String {
    switch self {
    case .requestFailed: return "Request Failed"
    case .invalidData: return "Invalid Data"
    case .responseUnsuccessful: return "Response Unsuccessful"
    case .jsonParsingFailure: return "JSON Parsing Failure"
    case .jsonConversionFailure: return "JSON Conversion Failure"
    }
  }
}

class MovieDBClient {
  
  // MARK: - Properties
  let session: URLSession
  var decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    return decoder
  }()
  private let apiKey = "34d74b3c4d3a6d099c7422cb6b1a5c77"

  // MARK: - Init Methods
  init(configuration: URLSessionConfiguration) {
    self.session = URLSession(configuration: configuration)
  }
  
  convenience init() {
    self.init(configuration: .default)
  }
  
  // MARK: - Fileprivate Methods
  typealias DataTaskCompletionHandler = (Result<Data, APIError>) -> Void
  fileprivate func dataTask(with request: URLRequest, completionHandler completion: @escaping DataTaskCompletionHandler) -> URLSessionDataTask {
    let task = session.dataTask(with: request) { data, response, error in
      guard let httpResponse = response as? HTTPURLResponse else {
        completion(.failure(.requestFailed))
        return
      }
      if httpResponse.statusCode == 200 {
        if let data = data {
          completion(.success(data))
        } else {
          completion(.failure(.invalidData))
        }
      } else {
        completion(.failure(.responseUnsuccessful))
      }
    }
    return task
  }
  
  fileprivate func searchMovies(with request: URLRequest, completion: @escaping (Result<Movies, APIError>) -> Void) {
    let task = dataTask(with: request) { (results) in
      DispatchQueue.main.async {
        switch results {
        case .success(let data):
          do {
            let movies = try self.decoder.decode(Movies.self, from: data)
            completion(.success(movies))
          } catch let DecodingError.dataCorrupted(context) {
            print(context)
          } catch let DecodingError.keyNotFound(key, context) {
            print(key, context)
          } catch let DecodingError.typeMismatch(type, context) {
            print(type, context)
          } catch let DecodingError.valueNotFound(value, context) {
            print(value, context)
          } catch {
            print(error)
          }
        case .failure(let error):
          completion(.failure(error))
        }
      }
    }
    task.resume()
  }
  
  fileprivate func fetchImageData(with request: URLRequest, completion: @escaping (Result<Data, APIError>) -> Void) {
    let task = dataTask(with: request) { (results) in
      DispatchQueue.main.async {
        switch results {
        case .success(let data):
          completion(.success(data))
        case .failure(let error):
          completion(.failure(error))
        }
      }
    }
    task.resume()
  }
  
  // MARK: - Public Methods
  func searchUsing(_ text: String, completion: @escaping (Result<Movies, APIError>) -> Void) {
    let endpoint = MovieDB.movies(apiKey: apiKey, searchText: text)
    let request = endpoint.request
    
    searchMovies(with: request, completion: completion)
  }
  
  func getImageData(from movie: Movie, completion: @escaping (Result<Data, APIError>) -> Void) {
    guard let path = movie.posterPath else { return }
    let endpoint = MovieDB.movieImage(path: path)
    let request = endpoint.request
    
    fetchImageData(with: request, completion: completion)
  }
}
