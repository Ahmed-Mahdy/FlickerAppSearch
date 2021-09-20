//
//  loadingViewable.swift
//  FlickrAppSearch
//
//  Created by Ahmed Mahdy on 20/09/2021.
//

import Foundation
import UIKit
import Lottie

protocol loadingViewable {
    func startAnimating()
    func stopAnimating()
}
extension loadingViewable where Self: UIViewController {
    func startAnimating() {
        DispatchQueue.main.async {
            if Self.animationView == nil {
                Self.animationView = .init(name: "speedi_loader")
                
                Self.containerView.backgroundColor = UIColor(red: 134/255, green: 1, blue: 1, alpha: 1)
                Self.animationView!.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
                Self.animationView!.center = Self.containerView.center
                // 3. Set animation content mode
                Self.animationView!.contentMode = .scaleAspectFit
                // 4. Set animation loop mode
                Self.animationView!.loopMode = .loop
                // 5. Adjust animation speed
                Self.containerView.addSubview(Self.animationView!)
                self.view.addSubview(Self.containerView)
                // 6. Play animation
                Self.animationView!.play()
            }
        }
    }
    func stopAnimating() {
        DispatchQueue.main.async {
            if Self.animationView != nil {
                Self.animationView!.pause()
                Self.animationView?.removeFromSuperview()
                Self.animationView = nil
                Self.containerView.removeFromSuperview()
            }
        }
    }
}
