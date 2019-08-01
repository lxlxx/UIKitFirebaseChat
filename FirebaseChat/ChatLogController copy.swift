//
//  ChatLogController.swift
//  FirebaseChat
//
//  Created by yu fai on 7/8/2016.
//  Copyright © 2016 YuFai. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
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


class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, handleKeyboard, HandleZoomImage
{

// MARK: Data
    
    var flowLayout:UICollectionViewFlowLayout { return self.collectionView!.collectionViewLayout as! UICollectionViewFlowLayout }
    
    var currentMessages = [Message]()
    
    var messageInputViewBottomConstraint: NSLayoutConstraint!
    
    var currentUser: User? {
        didSet{
            navigationItem.title = currentUser!.name
            fetchChatPartnerMessages()
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reload", style: .plain, target: self, action: #selector(reloadCollectionViewByNSTimer))
        }
    }
    
    var tableViewReloadTimer: Timer?

// MARK: Outlet
    
    var messageInputView: MessageInputView!

    func addMessageInputView(){
        messageInputView = MessageInputView(target: self, sendMessage: #selector(sendText), launchImagePicker: #selector(launchImagePicker))
        self.view.addSubview(messageInputView)
        messageInputView.translatesAutoresizingMaskIntoConstraints = false
        messageInputView.inputTextField.delegate = self
        
        messageInputViewBottomConstraint = NSLayoutConstraint(v1: messageInputView, a: .bottom, v2: self.view, c: 0)
        self.view.addConstraint(messageInputViewBottomConstraint)
        self.view.addConstraintsWithFormat("H:|[v0]|", views: messageInputView)
        self.view.addConstraintsWithFormat("V:[v0(48)]", views: messageInputView)
    }
    
// MARK: func
    // should handleSend and fetch result in a model like tweets
    fileprivate func handleSend(_ contents: [String: NSObject]) {
        guard let toUserID = currentUser!.id else { return }
        guard let fromUserID = FIRAuth.auth()?.currentUser?.uid else { return }
        
        let ref = FIRDatabase.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let timestamp: NSNumber = NSNumber(integerLiteral: Int(Date().timeIntervalSince1970))
        var values = ["toID": toUserID, "fromID": fromUserID, "timestamp": timestamp] as [String : Any]
        
        contents.forEach{ values[$0] = $1 }
        
        childRef.updateChildValues(values){
            if let err = $0.0 { print(err); return }
            
            let messageID = childRef.key
            
            let fromUserIDMessageRef = FIRDatabase.database().reference().child(GlobalString.userMessage).child(fromUserID).child(toUserID)
            fromUserIDMessageRef.updateChildValues([messageID: 1])
            let toUserIDMessageRef = FIRDatabase.database().reference().child(GlobalString.userMessage).child(toUserID).child(fromUserID)
            toUserIDMessageRef.updateChildValues([messageID: 1])
            
        }
        messageInputView.inputTextField.text = nil
    }
    
    func sendText(){
        if messageInputView.inputTextField.text?.characters.count > 0 {
            guard let inputMessage = messageInputView.inputTextField.text else { return }
            handleSend(["text":inputMessage as NSObject])
        }
    }
    
    func sendImage(_ imageWillUpload: UIImage){
        let imageName = UUID().uuidString
        let ref = FIRStorage.storage().reference().child(GlobalString.DB_message_image).child("\(imageName).png")
        
        if let compressedImage = compressImage(imageWillUpload) {
            ref.put(compressedImage, metadata: nil, completion: { [ weak weakSelf = self] (metadata, error) in
                if error != nil { printLog(error) ; return }
                
                if let imageURL = metadata?.downloadURL()?.absoluteString {
                    weakSelf?.handleSend([GlobalString.message_imageURL: imageURL as NSObject, GlobalString.message_imageWidth: imageWillUpload.size.width as NSObject, GlobalString.message_imageHeight: imageWillUpload.size.height as NSObject])
                }
            })
        }
    }
    
    func fetchChatPartnerMessages(){
        guard let myID = FIRAuth.auth()?.currentUser?.uid, let chatPartnerUserID = currentUser!.id else { return }
        let ref = FIRDatabase.database().reference().child(GlobalString.userMessage).child(myID).child(chatPartnerUserID)
        ref.observe(.childAdded, with: { [ weak weakSelf = self] (snapshot) in
            
            let messageID = snapshot.key
            let messagesRef = FIRDatabase.database().reference().child(GlobalString.message).child(messageID)
            
            weakSelf?.fetchMessageContentByID(messagesRef)
            
            }, withCancel: nil)
    }
    
    
    func fetchMessageContentByID(_ ref: FIRDatabaseReference){
        ref.observe(.value, with: { [ weak weakSelf = self] (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                weakSelf?.appendMessageWithSmartClass(dictionary, target: weakSelf)
            }
            weakSelf?.tableViewReloadTimer?.invalidate()
            weakSelf?.tableViewReloadTimer = Timer.scheduledTimer(timeInterval: 0.6, target: weakSelf!, selector: #selector(weakSelf?.reloadCollectionViewByNSTimer), userInfo: nil, repeats: false)
            }, withCancel: nil)
    }
    
    func appendMessageWithSmartClass(_ dictionary: [String: AnyObject] , target: ChatLogController?){
        let sMessage = smartMessage2()
        sMessage.setMessage2(dictionary)
        guard let resultMessage = sMessage.resultMessage else { return }
        target?.currentMessages.append(resultMessage)
    }
    
    func reloadCollectionViewByNSTimer(){
//        self.currentMessages.sortInPlace{ $0.timestamp?.intValue < $1.timestamp?.intValue }
        DispatchQueue.main.async{ [ weak weakSelf = self] in
            self.collectionView?.reloadData()
//            weakSelf?.perform(#selector(weakSelf?.scrollToBottom), with: nil, afterDelay: 1)
        }

    }
    
    func scrollToBottom(_ animated: Bool=false){
        if currentMessages.count > 0 {
            collectionView?.layoutIfNeeded()
            let indexPath = IndexPath(item: currentMessages.count - 1, section: 0)
            collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: animated)
            
        }
    }
    
    func launchImagePicker(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }

// MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.backgroundColor = UIColor.white
        
        let mainScreen = UIScreen.main.bounds
//        let shortSide = mainScreen.width > mainScreen.height ? mainScreen.height : mainScreen.width
        let shortSide = min(mainScreen.width, mainScreen.height)
        flowLayout.estimatedItemSize = CGSize(width: shortSide, height: 50)
        
//        flowLayout.scrollDirection = .Vertical
        
//        collectionView?.alwaysBounceVertical = true
        
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 54, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        self.collectionView?.register(ChatMessageCollectionViewTextCell.self, forCellWithReuseIdentifier: NSStringFromClass(ChatMessageCollectionViewTextCell.self))
        self.collectionView?.register(ChatMessageCollectionViewImageCell.self, forCellWithReuseIdentifier: NSStringFromClass(ChatMessageCollectionViewImageCell.self))
        
        addMessageInputView()
        
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupNSNotificationCenter(#selector(handleKeyboardWillShow))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        removeNSNotificationCenter()
    }
    
    deinit{
        printLog("ChatLogController deinit")
    }

// MARK: - Collection View data source
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentMessages.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: ChatMessageCollectionViewBasicCell
        
        switch currentMessages[(indexPath as NSIndexPath).row].messageType {
        case .text:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(ChatMessageCollectionViewTextCell.self), for: indexPath) as! ChatMessageCollectionViewTextCell
        case .video:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(ChatMessageCollectionViewTextCell.self), for: indexPath) as! ChatMessageCollectionViewTextCell
        case .image:
            let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(ChatMessageCollectionViewImageCell.self), for: indexPath) as! ChatMessageCollectionViewImageCell
            imageCell.delegate = self
            cell = imageCell
        }

        cell.currentChatPartner = currentUser
        cell.currentMessages = currentMessages[(indexPath as NSIndexPath).row]

        return cell
    }
    
// MARK: - Collection View Delegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView?.collectionViewLayout.invalidateLayout()
        self.collectionView?.layoutIfNeeded()
    }
    
// MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendText()
        self.view.endEditing(true)
        return true
    }
    
// MARK: - HandleZoomImage
    
    //    var zoomimageView: UIImageView?
    let zoomimage = testingZoom()
    func zoomInImage(_ startImage: UIImageView) {
//        startZoomInImage(startImage, target: self, zoomOutImage: #selector(zoomOutImage))
        zoomimage.startZoomInImage(startImage, target: self, zoomOutImage: #selector(zoomOutImage))
    }
    
    func zoomOutImage(_ gesture: UITapGestureRecognizer){
//        startZoomOutImage(gesture)
        zoomimage.startZoomOutImage(gesture)
    }
    
    
// MARK: - handleKeyboard
    func handleKeyboardWillShow(_ notification: Notification) {
        handleKeyboardShow_v2(notification) { [ weak weakSelf = self ] (keyboardWillShow, keyboardHeight, duration) in
            weakSelf?.messageInputViewBottomConstraint.constant = keyboardWillShow ? -keyboardHeight : 0
            UIView.animate(withDuration: duration, animations: {
                weakSelf?.view.layoutIfNeeded()
                }, completion: { (completed) in
//                    weakSelf?.scrollToBottom(true)
            })
        }
    }
}

struct testingZoom {
    
    func startZoomInImage(_ startImage: UIImageView, target: UIViewController, zoomOutImage: Selector){
        let startingFrame = startImage.superview?.convert(startImage.frame, to: nil)
        guard let keywindow = UIApplication.shared.keyWindow else { return }
        let zoomImage = UIImageView()
        zoomImage.layer.cornerRadius = 16
        zoomImage.clipsToBounds = true
        zoomImage.backgroundColor = UIColor.black
        zoomImage.contentMode = .scaleAspectFit
        zoomImage.image = startImage.image
        zoomImage.isUserInteractionEnabled = true
        zoomImage.addGestureRecognizer(UITapGestureRecognizer(target: target, action: zoomOutImage))
        
        zoomImage.translatesAutoresizingMaskIntoConstraints = false
        
        keywindow.addSubview(zoomImage)
        guard let xPos = startingFrame?.origin.x, let yPos = startingFrame?.origin.y, let imageWidth = startingFrame?.size.width, let imageHeight = startingFrame?.size.height else { return }
        
        let constraintShouldRemove = keywindow.constraints
        if constraintShouldRemove.count > 0 {
            keywindow.removeConstraints(constraintShouldRemove)
        }
        
        let xPosConstraints = NSLayoutConstraint(v1: zoomImage, a: .left, v2: keywindow, c: xPos)
        var yPosConstraints = NSLayoutConstraint(v1: zoomImage, a: .top, v2: keywindow, c: yPos)
        var widthConstraints = NSLayoutConstraint(v: zoomImage, WorH: .width, c: imageWidth)
        var heightConstraints = NSLayoutConstraint(v: zoomImage, WorH: .height, c: imageHeight)
        
        keywindow.addConstraints([xPosConstraints, yPosConstraints, widthConstraints, heightConstraints])
        keywindow.layoutIfNeeded()
        
        let mainScreenSize = UIScreen.main.bounds
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            zoomImage.layer.cornerRadius = 0
            yPosConstraints.constant = 0
            xPosConstraints.constant = 0
            widthConstraints.constant = mainScreenSize.width
            heightConstraints.constant = mainScreenSize.height
            keywindow.layoutIfNeeded()
        }){ (completed) -> Void in
            keywindow.removeConstraints([yPosConstraints, widthConstraints, heightConstraints])
            yPosConstraints = NSLayoutConstraint(v1: zoomImage, a: .centerY, v2: keywindow)
            widthConstraints = NSLayoutConstraint(v1: zoomImage, a: .width, v2: keywindow)
            heightConstraints = NSLayoutConstraint(v1: zoomImage, a: .height, v2: keywindow)
            keywindow.addConstraints([yPosConstraints, widthConstraints, heightConstraints])
        }
        //        print(keywindow.constraints.filter{ ($0.firstItem as! NSObject == self.zoomImage || $0.secondItem as! NSObject == self.zoomImage) && $0.firstAttribute == .Top })
    }
    
    func startZoomOutImage(_ gesture: UITapGestureRecognizer){
        if let zoomImage =  gesture.view {
            
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                zoomImage.alpha = 0
                }, completion: { (completed) in
                    zoomImage.removeFromSuperview()
            })
        }
    }
}
