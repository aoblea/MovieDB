//
//  MovieCell.swift
//  SwiftMovieDB
//
//  Created by Arwin Oblea on 4/26/21.
//

import UIKit

class MovieCell: UITableViewCell {
  
  // MARK: - IBOutlets
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var ratingLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
