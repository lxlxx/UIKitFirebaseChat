//
//  LoginView.swift
//  FirebaseChat
//
//  Created by yu fai on 30/7/2016.
//  Copyright © 2016 YuFai. All rights reserved.
//

import UIKit

class LoginView: UIView {
    
    // MARK: Data
    
    // MARK: Outlet
    
    var profileImage: UIImageView!
    
    var containerViewHeight: NSLayoutConstraint!
    var nameTextfieldHeight: NSLayoutConstraint!
    var emailTextfieldHeight: NSLayoutConstraint!
    var passwordTextfieldHeight: NSLayoutConstraint!
    
    var loginRegisterSegmentedControl: UISegmentedControl!
    
    var containerView: UIView!
    var loginRegisterButton: UIButton!
    
    var nameTextfield: UITextField!
    var emailTextfield: UITextField!
    var passwordTextfield: UITextField!
    
    var nameSeparatorView: UIView!
    var emailSeparatorView: UIView!
    
    // MARK: func
    
    func handleLoginRegisterSegmentChangeed(_ segmentSelected: Bool){
        
        containerViewHeight.constant = segmentSelected ? 100 : 150
        nameTextfieldHeight.isActive = false
        emailTextfieldHeight.isActive = false
        passwordTextfieldHeight.isActive = false
        
        nameTextfieldHeight = nameTextfield.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: segmentSelected ? 0 : 1/3)
        emailTextfieldHeight = emailTextfield.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: segmentSelected ? 1/2 : 1/3)
        passwordTextfieldHeight = passwordTextfield.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: segmentSelected ? 1/2 : 1/3)
        
        nameTextfieldHeight.isActive = true
        emailTextfieldHeight.isActive = true
        passwordTextfieldHeight.isActive = true
        nameTextfield.isHidden = segmentSelected
    }
    
    func addPortraitConstraints(){
        
        profileImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        profileImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 44).isActive = true
        profileImage.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -50).isActive = true
        profileImage.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -16).isActive = true
//        profileImage.heightAnchor.constraintEqualToConstant(150).active = true
        
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -24).isActive = true
        //        containerView.heightAnchor.constraintEqualToConstant(150).active = true
        containerViewHeight = containerView.heightAnchor.constraint(equalToConstant: 150)
        containerViewHeight.isActive = true
        
        loginRegisterButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        nameTextfield.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12).isActive = true
        nameTextfield.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        nameTextfield.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        //        nameTextfield.heightAnchor.constraintEqualToAnchor(containerView.heightAnchor, multiplier: 1/3).active = true
        nameTextfieldHeight = nameTextfield.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1/3)
        nameTextfieldHeight.isActive = true
        
        emailTextfield.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12).isActive = true
        emailTextfield.topAnchor.constraint(equalTo: nameTextfield.bottomAnchor).isActive = true
        emailTextfield.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        //        emailTextfield.heightAnchor.constraintEqualToAnchor(containerView.heightAnchor, multiplier: 1/3).active = true
        emailTextfieldHeight = emailTextfield.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1/3)
        emailTextfieldHeight.isActive = true
        
        passwordTextfield.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12).isActive = true
        passwordTextfield.topAnchor.constraint(equalTo: emailTextfield.bottomAnchor).isActive = true
        passwordTextfield.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        //        passwordTextfield.heightAnchor.constraintEqualToAnchor(containerView.heightAnchor, multiplier: 1/3).active = true
        passwordTextfieldHeight = passwordTextfield.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1/3)
        passwordTextfieldHeight.isActive = true
        
        nameSeparatorView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 6).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextfield.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -12).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        emailSeparatorView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 6).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextfield.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -12).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    // MARK: View life cycle
    
    convenience init(target: UIViewController, handleRegister: Selector, handleLoginRegisterSegment: Selector, handleSelectImage: Selector) {
        self.init()
        loginRegisterButton.addTarget(target, action: handleRegister, for: .touchUpInside)
        loginRegisterSegmentedControl.addTarget(target, action: handleLoginRegisterSegment, for: .valueChanged)
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: target, action: handleSelectImage))
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = UIColor(red: 61/255, green: 91/255, blue: 151/255, alpha: 1)
        
        profileImage = UIImageView()
        profileImage.image = UIImage(named: "curry")
        profileImage.contentMode = .scaleToFill
        profileImage.isUserInteractionEnabled = true
        profileImage.layer.cornerRadius = 8
        profileImage.layer.masksToBounds = true
        
        loginRegisterSegmentedControl = UISegmentedControl(items: ["Login","Register"])
        loginRegisterSegmentedControl.tintColor = UIColor.white
        loginRegisterSegmentedControl.selectedSegmentIndex = 1
        
        containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.layer.cornerRadius = 5
        containerView.layer.masksToBounds = true
        
        loginRegisterButton = UIButton(type: .system)
        loginRegisterButton.setTitleColor(UIColor.white, for: UIControlState())
        loginRegisterButton.backgroundColor = UIColor(r: 80, g: 101, b: 161, a: 1)
        loginRegisterButton.setTitle("Register", for: UIControlState())
        loginRegisterButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        nameTextfield = UITextField()
        nameTextfield.placeholder = "Name"
        
        emailTextfield = UITextField()
        emailTextfield.placeholder = "Email"
        
        passwordTextfield = UITextField()
        passwordTextfield.placeholder = "Password"
        passwordTextfield.isSecureTextEntry = true
        
        nameSeparatorView = UIView()
        nameSeparatorView.backgroundColor = UIColor(r: 220, g: 220, b: 220, a: 1)
        
        emailSeparatorView = UIView()
        emailSeparatorView.backgroundColor = UIColor(r: 220, g: 220, b: 220, a: 1)
        
        self.addSubview(profileImage)
        self.addSubview(loginRegisterSegmentedControl)
        self.addSubview(containerView)
        self.addSubview(loginRegisterButton)
        
        containerView.addSubview(nameTextfield)
        containerView.addSubview(emailTextfield)
        containerView.addSubview(passwordTextfield)
        containerView.addSubview(nameSeparatorView)
        containerView.addSubview(emailSeparatorView)
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        loginRegisterSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        loginRegisterButton.translatesAutoresizingMaskIntoConstraints = false
        nameTextfield.translatesAutoresizingMaskIntoConstraints = false
        emailTextfield.translatesAutoresizingMaskIntoConstraints = false
        passwordTextfield.translatesAutoresizingMaskIntoConstraints = false
        nameSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        emailSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        
        addPortraitConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



