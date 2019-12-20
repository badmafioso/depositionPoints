//
//  UIDevice+HDPI.swift
//  depositionPoints
//
//  Created by Sergey Frolov on 20.12.2019.
//  Copyright © 2019 SmartCapitan. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {
    func getHDPISize() -> String {
        if UIScreen.main.bounds.size.height <= 667 {
            return "xhdpi"
        }

        return "xxhdpi"
    }
}
