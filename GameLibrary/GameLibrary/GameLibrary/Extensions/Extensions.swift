//
//  Extensions.swift
//  GameLibrary
//
//  Created by Mehmet Akdeniz on 14.07.2023.
//

import Foundation
import UIKit

//MARK: - ImageView Extension
private var taskKey: Void?
extension UIImageView {
    var task: URLSessionDataTask? {
        get { return objc_getAssociatedObject(self, &taskKey) as? URLSessionDataTask }
        set { objc_setAssociatedObject(self, &taskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    func downloadImage(from url: URL) {
        
        task?.cancel()

        task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to download image from \(url): \(error)")
                return
            }
            
            guard let data = data else {
                print("No data returned from \(url)")
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }
        
        task?.resume()
    }
}
//MARK: - Notification Extensions
extension Notification.Name {
    static let didSelectGame = Notification.Name("didSelectGame")
}

//MARK: - Sceene Extension
public extension UIApplication {
    func currentUIWindow() -> UIWindow? {
        let connectedScenes = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }

        let window = connectedScenes.first?
            .windows
            .first { $0.isKeyWindow }

        return window

    }
}



