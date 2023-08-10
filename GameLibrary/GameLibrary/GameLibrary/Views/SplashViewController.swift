//
//  SplashViewController.swift
//  GameLibrary
//
//  Created by Mehmet Akdeniz on 20.07.2023.
//

import UIKit
import Network
import IndicatorVCExtension

final class SplashViewController: UIViewController {
    let monitor = NWPathMonitor()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        showActivityIndicator()
        startMonitoring()
    }

    private func startMonitoring() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.hideActivityIndicator()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let mainVC = storyboard.instantiateViewController(withIdentifier: "UITabbarController") as? UITabBarController {
                        mainVC.modalPresentationStyle = .fullScreen
                        self.present(mainVC, animated: true, completion: nil)
                    }
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.hideActivityIndicator()
                    let alert = UIAlertController(title: "Error", message: "Check your internet connection.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }

        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
}



