//
//  ViewModelable.swift
//  OdooContacts
//
//  Created by Александр Нехай on 3/23/21.
//

import Foundation
import UIKit

public protocol ViewModelable {
  var viewController: UIViewController { get }
  var model: ViewModel { get set }
}

extension ViewModelable where Self: UIViewController {
  var viewController: UIViewController {
    return self
  }
}

public protocol ViewModel { }
