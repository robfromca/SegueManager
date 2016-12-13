//
//  SegueManager.swift
//  Q42
//
//  Created by Tom Lokhorst on 2014-10-14.
//

import UIKit

private struct SourceLocation {
  let file: String
  let line: Int
  let column: Int
  let function: String
}

open class SegueManager {
  typealias Handler = (UIStoryboardSegue) -> Void

  fileprivate unowned let viewController: UIViewController
  fileprivate let sourceLocation: SourceLocation
  fileprivate var handlers = [String: Handler]()
  fileprivate var timers = [String: Timer]()

  public init(
    viewController: UIViewController,
    file: String = #file,
    line: Int = #line,
    column: Int = #column,
    function: String = #function)
  {
    self.viewController = viewController
    self.sourceLocation = SourceLocation(file: file, line: line, column: column, function: function)
  }

  open func performSegue(_ identifier: String, handler: @escaping (UIStoryboardSegue) -> Void) {
    handlers[identifier] = handler
    timers[identifier] = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(SegueManager.timeout(_:)), userInfo: identifier, repeats: false)

    viewController.performSegue(withIdentifier: identifier, sender: viewController)
  }

  open func performSegue<T>(_ identifier: String, handler: @escaping (T) -> Void) {
    performSegue(identifier) { segue in
      if let vc: T = viewControllerOfType(segue.destination) {
        handler(vc)
      }
      else {
        let message = "Performing segue '\(identifier)', "
          + "however destinationViewController is of type "
          + "'\(type(of: segue.destination))' "
          + "not of expected type '\(T.self)'."

        fatalError(message)
      }
    }
  }

  open func performSegue(_ identifier: String) {
    self.performSegue(identifier, handler: { _ in })
  }

  open func prepareForSegue(_ segue: UIStoryboardSegue) {
    if let segueIdentifier = segue.identifier {
      timers[segueIdentifier]?.invalidate()
      timers.removeValue(forKey: segueIdentifier)

      if let handler = handlers[segueIdentifier] {
        handler(segue)

        handlers.removeValue(forKey: segueIdentifier)
      }
    }
  }

  @objc fileprivate func timeout(_ timer: Timer) {
    let segueIdentifier = timer.userInfo as? String ?? ""
    let message = "SegueManager created at \(sourceLocation.file):\(sourceLocation.line)\n"
      + "Performed segue `\(segueIdentifier)', but handler not called.\n"
      + "Forgot to call SegueManager.prepareForSegue?"

    fatalError(message)
  }
}


// Smartly select a view controller of a specific type
// For navigation and tabbar controllers, select the obvious view controller
private func viewControllerOfType<T>(_ viewController: UIViewController?) -> T? {
  if let vc = viewController as? T {
    return vc
  }
  else if let vc = viewController as? UINavigationController {
    return viewControllerOfType(vc.visibleViewController)
  }
  else if let vc = viewController as? UITabBarController {
    return viewControllerOfType(vc.viewControllers?.first)
  }

  return nil
}
