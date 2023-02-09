//
//  messageInputView.swift
//  FacebookMessengerCopy
//
//  Created by yu fai on 8/8/2016.
//  Copyright © 2016 YuFai. All rights reserved.
//

import UIKit


class MessageInputView: UIView {
    
    let messageInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send", for: UIControl.State())
        button.setTitleColor(UIColor(red: 0, green: 134/255, blue: 230/255, alpha: 0.9), for: UIControl.State())
        button.setTitleColor(UIColor(white: 0.8, alpha: 0.8), for: .highlighted)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
//        button.addTarget(self, action: #selector(sendMessage), forControlEvents: .TouchUpInside)
        return button
    }()
    
    var inputTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter Message .... "
        return textfield
    }()
    
    let divderLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    let imagePicker = UIImageView()
    
    convenience init(target: UIViewController, sendMessage: Selector, launchImagePicker: Selector){
        self.init()
        sendButton.addTarget(target, action: sendMessage, for: .touchUpInside)
        imagePicker.addGestureRecognizer(UITapGestureRecognizer(target: target, action: launchImagePicker))
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = UIColor.white
        
        imagePicker.image = UIImage(named: "imagePicker")
        imagePicker.isUserInteractionEnabled = true
        imagePicker.contentMode = .scaleAspectFit
        
        self.addSubview(messageInputContainerView)
        messageInputContainerView.translatesAutoresizingMaskIntoConstraints = false
        self.packInSubview(v1: messageInputContainerView, v2: self, c: 0)
        
        imagePicker.translatesAutoresizingMaskIntoConstraints = false
        
        messageInputContainerView.addSubview(imagePicker)
        messageInputContainerView.addSubview(inputTextField)
        messageInputContainerView.addSubview(divderLineView)
        messageInputContainerView.addSubview(sendButton)
        
        messageInputContainerView.addConstraintsWithFormat("H:|-16-[v0(44)]-[v1][v2(60)]-16-|", views: imagePicker, inputTextField, sendButton)
        messageInputContainerView.addConstraintsWithFormat("V:|-4-[v0]|", views: imagePicker)
        messageInputContainerView.addConstraintsWithFormat("V:|[v0]|", views: sendButton)
        messageInputContainerView.addConstraintsWithFormat("V:|[v0]|", views: inputTextField)
        
        messageInputContainerView.addConstraintsWithFormat("H:|-2-[v0]-2-|", views: divderLineView)
        messageInputContainerView.addConstraintsWithFormat("V:|[v0(1.5)]", views: divderLineView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
