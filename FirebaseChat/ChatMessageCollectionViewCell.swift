//
//  ChatMessageCollectionViewCell.swift
//  FirebaseChat
//
//  Created by yu fai on 10/8/2016.
//  Copyright © 2016 YuFai. All rights reserved.
//

import UIKit


class ChatMessageCollectionViewBasicCell: UICollectionViewCell {
    
    // MARK: Data
    
    var contentDirectionConstraint: NSLayoutConstraint!
    var messagesBelongTome: Bool { return currentMessages?.fromID == FIRAuth.auth()?.currentUser?.uid }
    
    var currentMessages: Message? {
        didSet{
            setCellContent()
            
            userProfileImageView.isHidden = messagesBelongTome ? true : false
            
            self.contentView.removeConstraint(contentDirectionConstraint)
            contentDirectionConstraint = NSLayoutConstraint(v1: backgroundBubble, a: messagesBelongTome ? .right : .left, v2: self.contentView, c: messagesBelongTome ? -6 : 44)
            self.contentView.addConstraint(contentDirectionConstraint)

        }
    }
    
    var currentChatPartner: User? {
        didSet{
            userProfileImageView.image = nil
            
            guard let profileImageURL = currentChatPartner?.profileImageUrl else { return }
            userProfileImageView.loadUrlImageInCache(profileImageURL)
        }
    }
    
    // MARK: Outlet
    
    var userProfileImageView = UIImageView()

    var backgroundBubble = UIView()
    
    // MARK: func
    
    func setCellContent(){ }
    
    // MARK: View life cycle
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        let newFrame = layoutAttributes
        let desiredHeight = self.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        
        newFrame.size.height = desiredHeight.height + 4
        newFrame.size.width = UIScreen.main.bounds.width
//        newFrame.size.width = (UIApplication.sharedApplication().keyWindow?.frame.width)!
        self.setNeedsLayout()
        self.layoutIfNeeded()
        return newFrame
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        
        userProfileImageView.contentMode = .scaleAspectFill
        userProfileImageView.layer.cornerRadius = 16
        userProfileImageView.layer.masksToBounds = true
        
        backgroundBubble.backgroundColor = GlobalString.bubbleBlueColor
        backgroundBubble.layer.cornerRadius = 16
        backgroundBubble.layer.masksToBounds = true
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        userProfileImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundBubble.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(userProfileImageView)
        self.contentView.addSubview(backgroundBubble)

        self.addConstraintsWithFormat("H:|[v0]|", views: self.contentView)
        self.addConstraintsWithFormat("V:|[v0]|", views: self.contentView)
        
        self.contentView.addAutoLayout(v1: userProfileImageView, a: .bottom, v2: backgroundBubble)
        self.contentView.addAutoLayout(v1: userProfileImageView, a: .right, v2: backgroundBubble, a2: .left, c: -4)
        self.contentView.addAutoLayoutHeightWidth(v: userProfileImageView, setHeight: 32, setWidth: 32)

        self.contentView.addAutoLayout(v1: backgroundBubble, a: .top, v2: self.contentView)
        contentDirectionConstraint = NSLayoutConstraint(v1: backgroundBubble, a: .right, v2: self.contentView, c: -8)
        self.contentView.addConstraint(contentDirectionConstraint)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



