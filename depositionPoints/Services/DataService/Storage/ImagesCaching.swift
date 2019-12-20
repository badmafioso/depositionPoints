//
//  ImageCaching.swift
//  depositionPoints
//
//  Created by Sergey Frolov on 20.12.2019.
//  Copyright © 2019 SmartCapitan. All rights reserved.
//

import Foundation
import UIKit.UIImage

protocol ImagesCaching {
    func cache(name: String, image: UIImage)
    func get(imageName: String) -> UIImage?
}
