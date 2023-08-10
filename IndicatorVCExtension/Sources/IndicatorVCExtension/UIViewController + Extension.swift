//
//  File.swift
//  
//
//  Created by Mehmet Akdeniz on 24.07.2023.
//

import Foundation
import UIKit

public extension UIViewController {
    
    private struct AssociatedKeys {
        static var activityIndicator = "UIViewControllerActivityIndicator"
        static var blurView = "UIViewControllerBlurView"
    }
    
    var activityIndicator: UIActivityIndicatorView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.activityIndicator) as? UIActivityIndicatorView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.activityIndicator, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var blurView: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.blurView) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.blurView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func showActivityIndicator() {
        if blurView == nil {
            blurView = UIView()
            blurView?.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blurView?.translatesAutoresizingMaskIntoConstraints = false
            
            if let blurView = blurView {
                view.addSubview(blurView)
                NSLayoutConstraint.activate([
                    blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    blurView.topAnchor.constraint(equalTo: view.topAnchor),
                    blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                ])
            }
        }
        
        if activityIndicator == nil {
            activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator?.backgroundColor = .clear
            activityIndicator?.translatesAutoresizingMaskIntoConstraints = false
            
            if let activityIndicator = activityIndicator {
                view.addSubview(activityIndicator)
                
                NSLayoutConstraint.activate([
                    activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
                ])
            }
        }
        
        activityIndicator?.startAnimating()
    }
    
    func hideActivityIndicator() {
        activityIndicator?.stopAnimating()
        blurView?.removeFromSuperview()
        blurView = nil
    }
}

