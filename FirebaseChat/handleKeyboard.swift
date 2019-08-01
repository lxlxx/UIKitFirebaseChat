//
//  handleKeyboard.swift
//  FacebookMessengerCopy
//
//  Created by yu fai on 16/5/2016.
//  Copyright © 2016 YuFai. All rights reserved.
//

import UIKit

protocol handleKeyboard {
    func handleKeyboardShow(_ notification: Notification)
    func setupNSNotificationCenter(_ keyboardHandler: Selector)
    func removeNSNotificationCenter()
    
    func handleKeyboardShow_v2(_ notification: Notification, done: (_ keyboardWillShow: Bool, _ keyboardHeight: CGFloat, _ keyboardDuration:Double) -> () )
}

extension handleKeyboard where Self: UIViewController {
    
    func handleKeyboardShow(_ notification: Notification){
        
        if let userInfo = (notification as NSNotification).userInfo {
            
            let keyboardFram = (userInfo[UIKeyboardFrameBeginUserInfoKey] as AnyObject).cgRectValue
            
            let keyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
            
            view.frame.origin.y = keyboardShowing ? -keyboardFram!.height / 2 : 0
            
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                self.view.layoutIfNeeded()
                
                }, completion: { (completed) -> Void in
                    
            })
        }
    }
    
    func handleKeyboardShow_v2(_ notification: Notification, done: (_ keyboardWillShow: Bool, _ keyboardHeight: CGFloat, _ keyboardDuration:Double) -> ()){
        let keyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
        let keyboardFrame = ((notification as NSNotification).userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyboardDuration = ((notification as NSNotification).userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
//        UIView.animateWithDuration(keyboardDuration!) {
            done(keyboardShowing, (keyboardFrame?.height)!, keyboardDuration!)
//        }
    }
    
    func setupNSNotificationCenter(_ keyboardHandler: Selector){
        //search 睇下可唔可以直接指向 protocol 入面嘅 Selector 
        //答案係no #selector 一定要係 
        //        class SignUpPageController: UIViewController, UITextFieldDelegate, handleKeyboard {
        //              入面
        //        }
        NotificationCenter.default.addObserver(self, selector: keyboardHandler, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: keyboardHandler, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func removeNSNotificationCenter(){
        NotificationCenter.default.removeObserver(self)
    }
}
