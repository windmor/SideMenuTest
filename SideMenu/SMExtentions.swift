//
//  SMExtentions.swift
//  SideMenu
//
//  Created by Liliya Sayfutdinova on 17.11.2020.
//

import Foundation
import UIKit

extension UIPanGestureRecognizer
{
    var xVelocity: CGFloat {
        return self.velocity(in: view).x
    }
    
    var yVelocity: CGFloat {
        return self.velocity(in: view).y
    }
}

extension UIApplication
{
    var keyWindow: UIWindow? {
        return UIApplication.shared.windows.filter { $0.isKeyWindow }.first
    }
}
