//
//  Movies.swift
//  SwiftMovieDB
//
//  Created by Arwin Oblea on 4/27/21.
//

import Foundation

struct Movies: Decodable {
  
  // MARK: - Properties
  let results: [Movie]
  
  private enum CodingKeys: String, CodingKey {
    case page, results
  }
  
  // MARK: - Init
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    results = try container.decode([Movie].self, forKey: .results)
  }
}
