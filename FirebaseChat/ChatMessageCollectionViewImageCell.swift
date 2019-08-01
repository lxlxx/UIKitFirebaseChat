//
//  ChatMessageCollectionViewImageCell.swift
//  FirebaseChat
//
//  Created by yu fai on 23/8/2016.
//  Copyright © 2016 YuFai. All rights reserved.
//

import UIKit

class ChatMessageCollectionViewImageCell: ChatMessageCollectionViewBasicCell {
    
    // MARK: Data
    
    var imageSize: (imageHeight: Double, imageWidth: Double) {
        if let iMessage = currentMessages as? imageMessage, let imageHeight = iMessage.imageHeight, let imageWidht = iMessage.imageWidth {
            return (Double(imageHeight), Double(imageWidht))
        } else {
            return (200, 200)
        }
    }
    
    var fetchURLImageInCacheVariable: String!
    
    // MARK: Outlet
    
    weak var delegate: HandleZoomImage?
    var contentImageview = UIImageView()
    var zoomImage = UIImageView()
    
    // MARK: func
    
    override func setCellContent() {
        contentImageview.image = nil
        guard let iMessage = currentMessages as? imageMessage,
            let URLString = iMessage.imageURL else { return }
        
//        contentImageview.loadUrlImageInCache(URLString)
        fetchURLImageInCacheVariable = URLString
        contentImageview.fetchURLImageInCache(URLString){ [weak weakSelf = self] (imageReturn: UIImage, URLStringWhenReturn: String) -> () in
            if URLStringWhenReturn == weakSelf?.fetchURLImageInCacheVariable {
                weakSelf?.contentImageview.image = imageReturn
            } else {
                printLog("the image not i wanted")
            }
        }
    }
    
    func zoomInImage(){
        delegate?.zoomInImage(contentImageview)
    }
    
    // MARK: View life cycle
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        let newFrame = layoutAttributes
        let ratio = imageSize.imageHeight / imageSize.imageWidth
        var desiredHeight: CGFloat = 0
        let maxRatio = 2.0, minRation = 0.5
        
        if ratio >= minRation && ratio <= maxRatio {
            desiredHeight = 200 * CGFloat(ratio)
        } else if ratio > maxRatio {
            desiredHeight = 200 * 2
        } else if ratio < minRation {
            desiredHeight = 200 * 0.5
        }
        
        newFrame.size.height = desiredHeight + 4
        newFrame.size.width = UIScreen.main.bounds.width
        self.setNeedsLayout()
        self.layoutIfNeeded()
        return newFrame
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        backgroundBubble.backgroundColor = UIColor(white: 0.9, alpha: 0.96)
        
        contentImageview.contentMode = .scaleAspectFit
        contentImageview.layer.cornerRadius = 16
        contentImageview.clipsToBounds = true
        contentImageview.backgroundColor = UIColor.clear
        contentImageview.isUserInteractionEnabled = true
        contentImageview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomInImage)))
        
        contentImageview.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(contentImageview)
        
        self.contentView.addAutoLayout(v1: backgroundBubble, a: .width, v2: contentImageview, c: 4)
        self.contentView.addAutoLayout(v1: backgroundBubble, a: .height, v2: contentImageview, c: 4)
        
        self.contentView.addAutoLayout(v1: contentImageview, a: .centerX, v2: backgroundBubble)
        self.contentView.addAutoLayout(v1: contentImageview, a: .centerY, v2: backgroundBubble)
        self.contentView.addAutoLayout(v1: contentImageview, a: .height, v2: self.contentView, c: -4)
        self.contentView.addConstraintsWithFormat("H:[v0(200)]", views: contentImageview)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}





