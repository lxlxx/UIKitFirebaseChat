//
//  HandleZoomImage.swift
//  FirebaseChat
//
//  Created by yu fai on 26/8/2016.
//  Copyright © 2016 YuFai. All rights reserved.
//

import UIKit


protocol HandleZoomImage: class {
//    var zoomImageView: UIImageView? { get set }
    func zoomInImage(_ startImage: UIImageView)
}

extension HandleZoomImage {
    
    func startZoomInImage(_ startImage: UIImageView, target: UIViewController, zoomOutImage: Selector){
        let startingFrame = startImage.superview?.convert(startImage.frame, to: nil)
        guard let keywindow = UIApplication.shared.keyWindow else { return }
        let zoomImage = UIImageView()
        zoomImage.layer.cornerRadius = 16
        zoomImage.clipsToBounds = true
        zoomImage.backgroundColor = UIColor.black
        zoomImage.contentMode = .scaleAspectFit
        zoomImage.image = startImage.image
        zoomImage.isUserInteractionEnabled = true
        zoomImage.addGestureRecognizer(UITapGestureRecognizer(target: target, action: zoomOutImage))
        
        zoomImage.translatesAutoresizingMaskIntoConstraints = false
        
        keywindow.addSubview(zoomImage)
        guard let xPos = startingFrame?.origin.x, let yPos = startingFrame?.origin.y, let imageWidth = startingFrame?.size.width, let imageHeight = startingFrame?.size.height else { return }
        
        let constraintShouldRemove = keywindow.constraints
        if constraintShouldRemove.count > 0 {
            keywindow.removeConstraints(constraintShouldRemove)
        }
        
        let xPosConstraints = NSLayoutConstraint(v1: zoomImage, a: .left, v2: keywindow, c: xPos)
        var yPosConstraints = NSLayoutConstraint(v1: zoomImage, a: .top, v2: keywindow, c: yPos)
        var widthConstraints = NSLayoutConstraint(v: zoomImage, WorH: .width, c: imageWidth)
        var heightConstraints = NSLayoutConstraint(v: zoomImage, WorH: .height, c: imageHeight)
        
        keywindow.addConstraints([xPosConstraints, yPosConstraints, widthConstraints, heightConstraints])
        keywindow.layoutIfNeeded()
        
        let mainScreenSize = UIScreen.main.bounds
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            zoomImage.layer.cornerRadius = 0
            yPosConstraints.constant = 0
            xPosConstraints.constant = 0
            widthConstraints.constant = mainScreenSize.width
            heightConstraints.constant = mainScreenSize.height
            keywindow.layoutIfNeeded()
        }){ (completed) -> Void in
            keywindow.removeConstraints([yPosConstraints, widthConstraints, heightConstraints])
            yPosConstraints = NSLayoutConstraint(v1: zoomImage, a: .centerY, v2: keywindow)
            widthConstraints = NSLayoutConstraint(v1: zoomImage, a: .width, v2: keywindow)
            heightConstraints = NSLayoutConstraint(v1: zoomImage, a: .height, v2: keywindow)
            keywindow.addConstraints([yPosConstraints, widthConstraints, heightConstraints])
        }
//        print(keywindow.constraints.filter{ ($0.firstItem as! NSObject == self.zoomImage || $0.secondItem as! NSObject == self.zoomImage) && $0.firstAttribute == .Top })
    }
    
    func startZoomOutImage(_ gesture: UITapGestureRecognizer){
        if let zoomImage =  gesture.view {
            
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                zoomImage.alpha = 0
                }, completion: { (completed) in
                    zoomImage.removeFromSuperview()
            })
        }
    }
}

//extension HandleZoomImage {
//    var zoomImageView: UIImageView {
//        let imageview = UIImageView()
//        return imageview
//    }
//}

//@objc protocol ZoomImage: class {
//    var zoomimageView: UIImageView { get set }
//    optional func zoomImage()
//}
