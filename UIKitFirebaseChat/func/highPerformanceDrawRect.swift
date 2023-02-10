//
//  highPerformanceDrawRect.swift
//  FirebaseChat
//
//  Created by yu fai on 4/8/2016.
//  Copyright © 2016 YuFai. All rights reserved.
//

import Foundation


/*

func testingDrawRect(){
    let rectImageView = UIImageView()
    rectImageView.image = UIImage(named: "curry")
    rectImageView.contentMode = .ScaleToFill
    
    rectImageView.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(rectImageView)
    
    self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[v0(100)]-|", options: [], metrics: nil, views: ["v0":rectImageView]))
    self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[v0(100)]-16-|", options: [], metrics: nil, views: ["v0":rectImageView]))
    
}

func cropImageWithRect(image: UIImage) -> UIImage{
    
    let drawRect: CGRect = CGRectMake(-15, -15, image.size.width * image.scale, image.size.height * image.scale)
    
    UIGraphicsBeginImageContext(image.size)
    let context: CGContextRef = UIGraphicsGetCurrentContext()!
    CGContextClearRect(context, CGRectMake(0, 0, 100, 100))
    image.drawInRect(drawRect)
    
    let radiusImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return radiusImage
}
 
*/
