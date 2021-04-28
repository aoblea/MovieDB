//
//  ViewController.swift
//  SwiftMovieDB
//
//  Created by Arwin Oblea on 4/26/21.
//

import UIKit

class ViewController: UIViewController, Alertable {

  // MARK: - IBOutlets
  @IBOutlet weak var searchResultsTableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
  
  // MARK: - Properties
  var listOfMovies = [Movie]()
  lazy var movieClient = MovieDBClient()
  lazy var dateFormatter = DateFormatter()
  
  // MARK: - ViewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    
    searchResultsTableView.dataSource = self
  }
  
  // MARK: - Helper Methods
  fileprivate func refreshTableView() {
    DispatchQueue.main.async {
      self.searchResultsTableView.reloadData()
    }
  }

  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showMovieDetails" {
      guard let selectedIndexPath = self.searchResultsTableView.indexPathForSelectedRow else { return }
      if let destination = segue.destination as? DetailViewController {
        let selectedMovie = listOfMovies[selectedIndexPath.row]
        destination.movie = selectedMovie
      } else {
        showAlert(title: "Internal error occurred.", message: "Segue destination is incorrect.", viewController: self)
      }
    } else {
      showAlert(title: "Problem presenting next view controller.", message: "Segue ID may be incorrect.", viewController: self)
    }
  }
  
  // MARK: - IBAction Methods
  @IBAction func goButtonPressed(_ sender: Any) {
    guard let searchText = searchBar.text?.lowercased() else { return }
    
    movieClient.searchUsing(searchText) { [unowned self] (results) in
      switch results {
      case .success(let movies):
        self.listOfMovies = movies.results
        self.refreshTableView()
      case .failure(let error):
        showAlert(title: "Internal error occurred.", message: "Error: \(error)", viewController: self)
      }
    }
  }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return listOfMovies.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellID") as? MovieCell else { return UITableViewCell() }
    let movie = listOfMovies[indexPath.row]
    
    setup(using: movie, for: cell)
    
    return cell
  }
  
  fileprivate func setup(using movie: Movie, for cell: MovieCell) {
    cell.titleLabel.text = movie.title
    
    if let releaseDate = movie.releaseDate {
      dateFormatter.dateFormat = "yyyy-MM-dd"
      guard let releaseDate = dateFormatter.date(from: releaseDate) else { fatalError("Converting error") }
      dateFormatter.dateStyle = .long
      cell.dateLabel.text = dateFormatter.string(from: releaseDate)
    } else {
      cell.dateLabel.text = "Currently Unavailable"
    }

    cell.ratingLabel.text = String(movie.voteAverage.rounded())
  }
}


