//
//  Movie.swift
//  SwiftMovieDB
//
//  Created by Arwin Oblea on 4/27/21.
//

import Foundation
import UIKit

enum ImageDownloadState {
  case placeholder, downloaded, failed
}

struct Movie: Decodable {
  
  // MARK: - Properties
  let title: String
  let posterPath: String?
  let releaseDate: String?
  let voteAverage: Float
  let overview: String
  
  var image: UIImage? = nil
  var imageState: ImageDownloadState = .placeholder
  
  private enum CodingKeys: String, CodingKey {
    case title, poster_path, release_date, vote_average, overview
  }
  
  // MARK: - Init
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    title = try container.decode(String.self, forKey: .title)
    posterPath = try container.decodeIfPresent(String.self, forKey: .poster_path)
    releaseDate = try container.decodeIfPresent(String.self, forKey: .release_date)
    voteAverage = try container.decode(Float.self, forKey: .vote_average)
    overview = try container.decode(String.self, forKey: .overview)
  }
}
