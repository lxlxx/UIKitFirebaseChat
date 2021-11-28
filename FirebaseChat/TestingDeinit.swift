//
//  TestingDeinit.swift
//  FirebaseChat
//
//  Created by yu fai on 17/9/2016.
//  Copyright © 2016 YuFai. All rights reserved.
//

import UIKit


class TestingDeinit: UIViewController {
    
    var pushButton: UIButton!
    
    func something (){
        print("something")
    }
    
    func addButton(){
        pushButton = UIButton()
        pushButton.setTitleColor(UIColor.white, for: UIControl.State())
        pushButton.backgroundColor = UIColor(r: 80, g: 101, b: 161, a: 1)
        pushButton.setTitle("push", for: UIControl.State())
        pushButton.addTarget(self, action: #selector(pushToMessagePage), for: .touchUpInside)
        
        pushButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(pushButton)
        
        pushButton.addAutoLayoutHeightWidth(v: pushButton, setHeight: 200, setWidth: 200)
        self.view.addAutoLayout(v1: pushButton, a: .centerX, v2: self.view)
        self.view.addAutoLayout(v1: pushButton, a: .centerY, v2: self.view)
    }
    
    @objc func pushToMessagePage(sender: UIButton){
        print(sender.currentTitle)
        self.navigationController?.pushViewController(MessageVC(), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        addButton()
        getAllMessages()
        something()
    }
    
    func getAllMessages(){
        let ref = Database.database().reference().child(GlobalString.message)
        ref.observe(.childAdded, with: { [ weak weakSelf = self] (snapshot) in
            
            let messageID = snapshot.key
            let messagesRef = Database.database().reference().child(GlobalString.message).child(messageID)
            guard let result = snapshot.value as? [String: Any] else { return }
            if let time = result["timestamp"]{
                if let seconds = (time as AnyObject).doubleValue {
                    let formattedTime = timeViewModel(seconds: seconds)
                    print(formattedTime.convertedTime)
                }
            }
            print(123)
            }, withCancel: nil)
        
    }
    
    deinit{
        print("TestingDeinit deinit")
    }
}
