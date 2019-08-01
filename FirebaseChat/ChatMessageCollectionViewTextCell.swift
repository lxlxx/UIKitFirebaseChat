//
//  ChatMessageCollectionViewTextCell.swift
//  FirebaseChat
//
//  Created by yu fai on 17/8/2016.
//  Copyright © 2016 YuFai. All rights reserved.
//

import UIKit

class ChatMessageCollectionViewTextCell: ChatMessageCollectionViewBasicCell {
    
    // MARK: Data
    
    // MARK: Outlet
    
    var contentTextview = UITextView()
    
    // MARK: func
    
    override func setCellContent() {
        
        contentTextview.text = nil
        
        guard let contentText = (currentMessages as! textMessage).text else { return }
        
        contentTextview.text = contentText
        
        contentTextview.textColor = messagesBelongTome ? UIColor.white : UIColor.black
        backgroundBubble.backgroundColor = messagesBelongTome ? GlobalString.bubbleBlueColor : GlobalString.bubbleGrayColor
    }
    
    // MARK: View life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentTextview.isScrollEnabled = false
        contentTextview.isUserInteractionEnabled = false
        contentTextview.font = UIFont(name: "HiraginoSans-W3", size: 15)
        contentTextview.backgroundColor = UIColor.clear
        contentTextview.textColor = UIColor.white
        
        contentTextview.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(contentTextview)
        
        self.contentView.addAutoLayout(v1: backgroundBubble, a: .width, v2: contentTextview, c: 8)
        self.contentView.addAutoLayout(v1: backgroundBubble, a: .height, v2: contentTextview)
        
        self.contentView.addAutoLayout(v1: contentTextview, a: .centerX, v2: backgroundBubble)
        self.contentView.addAutoLayout(v1: contentTextview, a: .centerY, v2: backgroundBubble, c: 4)
        self.contentView.addAutoLayout(v1: contentTextview, a: .width, v2: self.contentView, r: .lessThanOrEqual, m: 0.8)
        self.contentView.addAutoLayout(v1: contentTextview, a: .height, v2: self.contentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
