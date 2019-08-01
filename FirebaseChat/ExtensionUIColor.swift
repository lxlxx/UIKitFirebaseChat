//
//  extensionUIColor.swift
//  FirebaseChat
//
//  Created by yu fai on 5/8/2016.
//  Copyright © 2016 YuFai. All rights reserved.
//

import Foundation

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat){
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
}