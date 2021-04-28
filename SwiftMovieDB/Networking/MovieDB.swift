//
//  MovieDB.swift
//  SwiftMovieDB
//
//  Created by Arwin Oblea on 4/27/21.
//

import Foundation

enum MovieDB {
  case movies(apiKey: String, searchText: String)
  case movieImage(path: String)
}

extension MovieDB {
  var base: String {
    switch self {
    case .movies:
      return "https://api.themoviedb.org"
    case .movieImage:
      return "https://image.tmdb.org"
    }
  }
  
  var path: String {
    switch self {
    case .movies:
      return "/3/search/movie"
    case .movieImage(let path):
      return "/t/p/w500\(path)"
    }
  }
  
  var queryItems: [URLQueryItem] {
    switch self {
    case .movies(let key, let searchText):
      return [
        URLQueryItem(name: "api_key", value: key.description),
        URLQueryItem(name: "language", value: "en-US"),
        URLQueryItem(name: "query", value: searchText.description),
        URLQueryItem(name: "page", value: "1"),
        URLQueryItem(name: "include_adult", value: "false")
      ]
    case .movieImage:
      return []
    }
  }
  
  var urlComponents: URLComponents {
    var components = URLComponents(string: base)!
    components.path = path
    components.queryItems = queryItems
    
    return components
  }
  
  var request: URLRequest {
    let url = urlComponents.url!
    return URLRequest(url: url)
  }
}
