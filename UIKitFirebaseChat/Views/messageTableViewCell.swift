//
//  messageTableViewCell.swift
//  FirebaseChat
//
//  Created by yu fai on 9/8/2016.
//  Copyright © 2016 YuFai. All rights reserved.
//

import UIKit
import Firebase

class messageCell: UITableViewCell {
    
    var currentMessage: Message? {
        didSet {
            profileImageView.image = nil
            textLabel?.text = nil
            detailTextLabel?.text = nil
            timeLabel.text = nil
            
            setProfilImage()

            detailTextLabel?.text = (currentMessage as! textMessage).text
            
            if let seconds = currentMessage?.timestamp?.doubleValue {
                let formattedTime = timeViewModel(seconds: seconds)
                timeLabel.text = formattedTime.convertedTime
            }
        }
    }
    
    fileprivate func setProfilImage(){
        if let userID = currentMessage?.chatPartnerID() {
            let ref = Database.database().reference().child(GlobalString.DB_user_dir).child(userID)
            ref.observe(.value, with: { (snapshot) in
                if let value = snapshot.value as? [String: AnyObject] {
                    self.textLabel?.text = value[GlobalString.DB_user_userName] as? String
                    guard let imageURL = value[GlobalString.DB_user_profileImageUrl] as? String else { return }
                    
                    self.profileImageView.loadUrlImageInCache(imageURL)
                }
                }, withCancel: nil)
        }
    }
    
    let profileImageView = UIImageView()
    let timeLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var textLabelFrame = textLabel!.frame
        textLabelFrame.origin.x = 60
        textLabelFrame.origin.y -= 2
//        textLabelFrame.size.width -= 60
        textLabel?.frame = textLabelFrame
        
        var detailLabelFrame = detailTextLabel!.frame
        detailLabelFrame.origin.x = 60
        detailLabelFrame.origin.y += 2
        if detailLabelFrame.size.width > UIScreen.main.bounds.width - 60 {
            detailLabelFrame.size.width -= 60
        }
        detailTextLabel?.frame = detailLabelFrame
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
//        profileImageView.image = UIImage(named: "curry")
        profileImageView.layer.cornerRadius = 24
        profileImageView.layer.masksToBounds = true
        
//        timeLabel.text = "MM:DD:HH"
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        timeLabel.textColor = UIColor.lightGray
        timeLabel.textAlignment = .right
        
        addSubview(profileImageView)
        addSubview(timeLabel)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class timeViewModel {
    var convertedTime: String?
    
    init(seconds: Double){
        let date = Date(timeIntervalSince1970: seconds)
        let secondsFromNow = Date().timeIntervalSince1970 - seconds
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        
        let secondInDays: TimeInterval = 60 * 60 * 24
        
        if secondsFromNow > secondInDays * 7{
            dateFormatter.dateFormat = "dd/MMM/yy"
        } else if secondsFromNow > secondInDays {
            dateFormatter.dateFormat = "EEEE"
        }
        convertedTime = dateFormatter.string(from: date)
    }
}

class ViewModel {
    
    var userName: String?
    var messageText: String?
    var profileImageURL: String?
    
    init(message: Message){
        if let toUserID = message.toID {
            let ref = Database.database().reference().child(GlobalString.DB_user_dir).child(toUserID)
            ref.observe(.value, with: { (snapshot) in
                if let value = snapshot.value as? [String: AnyObject] {
                    self.userName = value[GlobalString.DB_user_userName] as? String
                    guard let imageURL = value[GlobalString.DB_user_profileImageUrl] as? String else { return }
                    self.profileImageURL = imageURL
                }
                }, withCancel: nil)
        }
        messageText = (message as! textMessage).text
    }
}






