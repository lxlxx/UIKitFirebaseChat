//
//  LoginVC+ImagePickerHandler.swift
//  FirebaseChat
//
//  Created by yu fai on 30/7/2016.
//  Copyright © 2016 YuFai. All rights reserved.
//

import UIKit

extension LoginVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func handleSelectImage(_ gesture: UITapGestureRecognizer){
        if gesture.state == .ended {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.allowsEditing = true
            pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            
            self.present(pickerController, animated: true, completion: nil)
        }
    }
// MARK: UIImagePickerControllerDelegate

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var image = info[UIImagePickerControllerEditedImage] as? UIImage
        if image == nil {
            image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        contentView.profileImage.image = image
        
        self.dismiss(animated: true, completion: nil)
    }
}
