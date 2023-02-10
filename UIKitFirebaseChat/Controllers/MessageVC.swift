//
//  ViewController.swift
//  FirebaseChat
//
//  Created by yu fai on 23/7/2016.
//  Copyright © 2016 YuFai. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class MessageVC: UITableViewController {
    
// MARK: Data
    
    let cellID = "cellID"
    
    var currentMessages = [Message]()
    var messageDictionary = [String: Message]()
    
    var tableViewReloadTimer: Timer?

// MARK: Outlet
    
    var titleView: NavigationBarTitleView!
    
    func addNavBarItems(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        let rightBarImage = UIImage(named: "newMessage")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightBarImage, style: .plain, target: self, action: #selector(handleNewMessage))
    }
    
    
    func setNavBarTitleView(){
        titleView = NavigationBarTitleView()
        self.navigationItem.titleView = titleView
    }
    
    func fetchUserNameSetTitle(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child(GlobalString.DB_user_dir).child(uid).observeSingleEvent(of: .value, with: {
            (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                guard let profileImageURL = dictionary[GlobalString.DB_user_profileImageUrl] as? String else { return }
                
                self.titleView.titleNameLabel.text = dictionary[GlobalString.DB_user_userName] as? String
                self.titleView.titleImageView.loadUrlImageInCache(profileImageURL)
            }
            }, withCancel: nil)
        fetchUserMessages()
    }
    
// MARK: func
    
    @objc func handleNewMessage(){
        let messageVC = NewMessageVC()
        messageVC.messageVC = self
        let newMessageVC = UINavigationController(rootViewController: messageVC)
        
        self.present(newMessageVC, animated: true, completion: nil)
    }
    
    @objc func handleLogout(){
        currentMessages.removeAll()
        messageDictionary.removeAll()
        tableView.reloadData()
        
        do {
            try Auth.auth().signOut()
        } catch let err {
            print(err)
        }
        let vc = LoginVC()
        vc.messageController = self
        present(vc, animated: true, completion: nil)
    }
    
    func checkUserIsLogin(){
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            fetchUserNameSetTitle()
        }
    }
    
    func ShowChatLogController(_ sender: AnyObject){
        let vc = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(vc, animated: true)
        if let userExit = sender as? User { vc.currentUser = userExit }
    }
    
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
            // using smartMessage switch messagetype case text: append case video
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
//                let message = textMessage()
//                message.setValuesForKeys(dictionary)
                
                let sMessage = smartMessage2()
                sMessage.setMessageForNonTextMessage(dictionary)
                guard let resultMessage = sMessage.resultMessage else { return }
                
                if let chatPartnersID = resultMessage.chatPartnerID() {
                    self.messageDictionary[chatPartnersID] = resultMessage
                }
            }

            self.tableViewReloadTimer?.invalidate()
            self.tableViewReloadTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.reloadTableViewByNSTimer), userInfo: nil, repeats: false)

            }, withCancel: nil)
    }
    
    @objc func reloadTableViewByNSTimer(){
        self.currentMessages = Array(self.messageDictionary.values)
        self.currentMessages.sort{ $0.timestamp?.int32Value > $1.timestamp?.int32Value }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
// MARK: View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        self.tableView.register(messageCell.self, forCellReuseIdentifier: cellID)
        self.tableView.tableFooterView = UIView()

        addNavBarItems()
        checkUserIsLogin()
        setNavBarTitleView()

    }
    
    deinit{
        printLog("MessageVC deinit")
    }
    
// MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentMessages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! messageCell
        cell.currentMessage = currentMessages[(indexPath as NSIndexPath).row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
// MARK: - Table view Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = currentMessages[(indexPath as NSIndexPath).row]
        guard let chatPartnerID = message.chatPartnerID() else { return }
        let ref = Database.database().reference().child(GlobalString.DB_user_dir).child(chatPartnerID)
        ref.observeSingleEvent(of: .value, with:  { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            
            let user = User()
            user.setValuesForKeys(dictionary)
            user.id = snapshot.key
            self.ShowChatLogController(user)
        })
    }
}
