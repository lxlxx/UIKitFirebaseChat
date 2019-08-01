//
//  File.swift
//  FirebaseChat
//
//  Created by yu fai on 28/7/2016.
//  Copyright © 2016 YuFai. All rights reserved.
//

import UIKit


class LoginVC: UIViewController, UITextFieldDelegate {
    
// MARK: Data

// MARK: Outlet
    
    var contentView: LoginView! {
        didSet{
            contentView.nameTextfield.delegate = self
            contentView.emailTextfield.delegate = self
            contentView.passwordTextfield.delegate = self

        }
    }
    
    weak var messageController: MessageVC?

// MARK: func
    
    func handleDismissVC(){
        self.dismiss(animated: true, completion: {
//            let currentVC = UIApplication.sharedApplication().keyWindow
            let currentVC = (UIApplication.shared.delegate as! AppDelegate).window
            let navVC = currentVC?.rootViewController as! UINavigationController
            let messageVC = navVC.topViewController as! MessageVC
            messageVC.checkUserIsLogin()
        })
    }
    
    func handleLoginRegister(){
        if contentView.loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    func handleLogin(){
        guard let email = contentView.emailTextfield.text,
            let password = contentView.passwordTextfield.text
            else { return }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print(error)
                return
            }
            self.messageController?.fetchUserNameSetTitle()
            self.dismiss(animated: true, completion: nil)
            
            printLog("login in!!")
        })
    }
    
    func handleRegister(){
        guard let email = contentView.emailTextfield.text, let password = contentView.passwordTextfield.text, let name = contentView.nameTextfield.text else { return }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { [weak weakSelf = self] (user: FIRUser?, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            guard let uid = user?.uid else { return }
            
            let imageName = UUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("profile_image").child("\(imageName).png")
            
            if let uploadImage = compressImage(weakSelf!.contentView.profileImage.image!){
                storageRef.put(uploadImage, metadata: nil, completion: { (metadata, putDataError) in
                    if putDataError != nil {
                        print(putDataError)
                        return
                    }
                    
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        let value =  ["name": name, "email": email, "profileImageUrl": profileImageUrl]
                        weakSelf!.handleUploadToFiredataDB(uid, value: value as [String : AnyObject])
                    }
                })
            }
            
        })
    }
    
    fileprivate func handleUploadToFiredataDB(_ uid: String, value: [String: AnyObject]){
        let ref = FIRDatabase.database().reference()
        let usersRef = ref.child("users").child(uid)
        
        usersRef.updateChildValues(value, withCompletionBlock: { (updateChildValuesErr, ref) in
            
            if updateChildValuesErr != nil {
                print(updateChildValuesErr)
                return
            }
            self.messageController?.titleView.titleNameLabel.text = value[GlobalString.DB_user_userName] as? String
            if let imageURL = value[GlobalString.DB_user_profileImageUrl] as? String {
                self.messageController?.titleView.titleImageView.loadUrlImageInCache(imageURL)
            }
            self.dismiss(animated: true, completion: nil)
            
        })
    }
    
    func handleLoginRegisterSegment(){
        let SegmentedControl = contentView.loginRegisterSegmentedControl
        let title = SegmentedControl?.titleForSegment(at: (SegmentedControl?.selectedSegmentIndex)!)
        contentView.loginRegisterButton.setTitle(title, for: UIControlState())
        
        contentView.handleLoginRegisterSegmentChangeed(SegmentedControl?.selectedSegmentIndex == 0)
    }
    
// MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        contentView = LoginView(target: self, handleRegister: #selector(handleLoginRegister), handleLoginRegisterSegment: #selector(handleLoginRegisterSegment), handleSelectImage: #selector(handleSelectImage))
        
        self.view = contentView
        
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    deinit{
        printLog("LoginVC deinit")
    }
    
// MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == contentView.emailTextfield || textField == contentView.passwordTextfield || textField == contentView.nameTextfield{
            textField.resignFirstResponder()
        }
        return true
    }

}



