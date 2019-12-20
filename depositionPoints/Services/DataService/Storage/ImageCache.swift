//
//  ImageCache.swift
//  depositionPoints
//
//  Created by Sergey Frolov on 20.12.2019.
//  Copyright © 2019 SmartCapitan. All rights reserved.
//

import Foundation
import UIKit.UIImage

final class ImageCache: ImagesCaching {
    var cache = NSCache<NSString, UIImage>()

    func cache(name: String, image: UIImage) {
        cache.setObject(image, forKey: name as NSString)
    }

    func get(imageName: String) -> UIImage? {
        cache.object(forKey: imageName as NSString)
    }
}

