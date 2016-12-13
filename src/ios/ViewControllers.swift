//
//  ViewControllers.swift
//  SegueManager
//
//  Created by Tom Lokhorst on 2016-01-23.
//  Copyright © 2016 nonstrict. All rights reserved.
//

import UIKit

public protocol SeguePerformer {
  var segueManager: SegueManager { get }
}

extension SeguePerformer {
  public func performSegue(_ identifier: String, handler: @escaping (UIStoryboardSegue) -> Void) {
    segueManager.performSegue(identifier, handler: handler)
  }

  public func performSegue<T>(_ identifier: String, handler: @escaping (T) -> Void) {
    segueManager.performSegue(identifier, handler: handler)
  }

  public func performSegue(_ identifier: String) {
    segueManager.performSegue(identifier)
  }
}

open class SegueManagerViewController : UIViewController, SeguePerformer {
  open lazy var segueManager: SegueManager = { return SegueManager(viewController: self) }()

  override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    segueManager.prepareForSegue(segue)
  }
}

open class SegueManagerCollectionViewController : UICollectionViewController, SeguePerformer {
  open lazy var segueManager: SegueManager = { return SegueManager(viewController: self) }()

  override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    segueManager.prepareForSegue(segue)
  }
}

open class SegueManagerNavigationController : UINavigationController, SeguePerformer {
  open lazy var segueManager: SegueManager = { return SegueManager(viewController: self) }()

  override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    segueManager.prepareForSegue(segue)
  }
}

open class SegueManagerTableViewController : UITableViewController, SeguePerformer {
  open lazy var segueManager: SegueManager = { return SegueManager(viewController: self) }()

  override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    segueManager.prepareForSegue(segue)
  }
}
