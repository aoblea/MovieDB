//
//  Alertable.swift
//  SwiftMovieDB
//
//  Created by Arwin Oblea on 4/28/21.
//

import Foundation
import UIKit

protocol Alertable: class {
  func showAlert(title: String, message: String, viewController: UIViewController)
}

extension Alertable {
  func showAlert(title: String, message: String, viewController: UIViewController) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let alert = UIAlertAction(title: "OK", style: .default, handler: nil)
    
    alertController.addAction(alert)
    viewController.present(alertController, animated: true, completion: nil)
  }
}
