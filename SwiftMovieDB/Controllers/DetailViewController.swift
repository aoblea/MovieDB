//
//  DetailViewController.swift
//  SwiftMovieDB
//
//  Created by Arwin Oblea on 4/27/21.
//

import UIKit

class DetailViewController: UIViewController, Alertable {
  
  // MARK: - Properties
  var movie: Movie?
  fileprivate lazy var client = MovieDBClient()
  fileprivate lazy var dateFormatter = DateFormatter()
  
  // MARK: - IBOutlets
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var movieImageView: UIImageView!
  @IBOutlet weak var summaryTextView: UITextView!
  
  // MARK: - ViewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.tintColor = .white
    
    setupView()
  }
  
  // MARK: - Helper Methods
  fileprivate func setupView() {
    guard let movie = movie else { return }
    titleLabel.text = movie.title
    summaryTextView.text = movie.overview
    
    if let releaseDate = movie.releaseDate {
      setDateLabel(using: releaseDate)
    } else {
      dateLabel.text = "Unavailable"
    }
    
    if movie.imageState == .placeholder {
      setImageView(from: movie)
    } else {
      movieImageView.image = .remove
    }
  }
  
  fileprivate func setDateLabel(using movieDate: String) {
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let movieDateFormat = dateFormatter.date(from: movieDate)
    dateFormatter.dateStyle = .short
    let movieDateStringFormat = dateFormatter.string(from: movieDateFormat!)
    
    dateLabel.text = "Release Date: \(movieDateStringFormat)"
  }
  
  fileprivate func setImageView(from movie: Movie) {
    client.getImageData(from: movie) { [unowned self] (results) in
      switch results {
      case .success(let data):
        self.movieImageView.image = UIImage(data: data)
        self.movie?.imageState = .downloaded
      case .failure(let error):
        showAlert(title: "Internal error occurred.", message: "Error: \(error)", viewController: self)
        self.movie?.imageState = .failed
      }
    }
  }
}
