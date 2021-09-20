//
//  Reactive+Loading.swift
//  FlickrAppSearch
//
//  Created by Ahmed Mahdy on 20/09/2021.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Lottie

extension UIViewController: loadingViewable {
    static var animationView: AnimationView?
    static let containerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
}

extension Reactive where Base: UIViewController {

    /// Bindable sink for `startAnimating()`, `stopAnimating()` methods.
    public var isAnimating: Binder<Bool> {
        return Binder(self.base, binding: { (viewController, active) in
            if active {
                viewController.startAnimating()
            } else {
                viewController.stopAnimating()
            }
        })
    }

}
