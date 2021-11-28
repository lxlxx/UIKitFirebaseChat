//
//  FirebaseHelper.swift
//  FirebaseChat
//
//  Created by yu fai on 23/8/2016.
//  Copyright © 2016 YuFai. All rights reserved.
//

import UIKit


struct FirebaseHelper {
    
    func fetchUserMessages(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child(GlobalString.userMessage).child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            
            let chatPartnersID = snapshot.key
            let chatPartnersmessagesRef = Database.database().reference().child(GlobalString.userMessage).child(uid).child(chatPartnersID)
            chatPartnersmessagesRef.observe(.childAdded, with: { (snapshot) in
                let messageID = snapshot.key
                let messagesRef = Database.database().reference().child(GlobalString.message).child(messageID)
                
                self.fetchMessageContentByID(messagesRef)
            })
            
            }, withCancel: nil)
    }
    
    func fetchMessageContentByID(_ ref: DatabaseReference){
        ref.observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let message = textMessage()
                message.setValuesForKeys(dictionary)
                
//                if let chatPartnersID = message.chatPartnerID() {
////                    self.messageDictionary[chatPartnersID] = message
//                }
            }
            
//            self.tableViewReloadTimer?.invalidate()
//            self.tableViewReloadTimer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: #selector(self.reloadTableViewByNSTimer), userInfo: nil, repeats: false)
            
            }, withCancel: nil)
    }
}



//message.setValuesForKeysWithDictionary(dictionary)

//                let smartMessage = smartMessage2()
//                smartMessage.setMessage2(dictionary)
//                guard let resultMessage = smartMessage.resultMessage else { return }
//                switch resultMessage.messageType {
//                case .text: break
//                case .image:
//                    message.text = "[Image]"
//                case .video:
//                    message.text = "[Video]"
//                }
