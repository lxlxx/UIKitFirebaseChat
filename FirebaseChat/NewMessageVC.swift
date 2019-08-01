//
//  NewMessageVC.swift
//  FirebaseChat
//
//  Created by yu fai on 30/7/2016.
//  Copyright © 2016 YuFai. All rights reserved.
//

import UIKit


class NewMessageVC: UITableViewController {
    
// MARK: Data
    
    let cellID = "cellID"
    
    var users = [User]()
    
    weak var messageVC: MessageVC?
    
// MARK: Outlet

// MARK: func
    
    func fetchUsers(){
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { [ weak weakSelf = self ] (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
                let user = User()
                
                if uid != snapshot.key {
                    user.id = snapshot.key
                    user.setValuesForKeys(dictionary)
                    
                    weakSelf?.users.append(user)
                }
                
                DispatchQueue.main.async(execute: { 
                    weakSelf?.tableView.reloadData()
                })
            }
            }, withCancel: nil
        )
    }
    
    func addNavBarItem(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
    }
    
    func handleCancel(){
        self.dismiss(animated: true, completion: nil)
    }

// MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "New Message"
        
        addNavBarItem()
        fetchUsers()
        self.tableView.register(messageCell.self, forCellReuseIdentifier: cellID)
    }
    
    deinit{
        printLog("NewMessageVC deinit")
    }
    
// MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! messageCell
        let user = users[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        if let imageUrl = users[(indexPath as NSIndexPath).row].profileImageUrl{
            
            cell.profileImageView.loadUrlImageInCache(imageUrl)

        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
// MARK: - Table view Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            let user = self.users[(indexPath as NSIndexPath).row]
            self.messageVC?.ShowChatLogController(user)
        }
    }
}







