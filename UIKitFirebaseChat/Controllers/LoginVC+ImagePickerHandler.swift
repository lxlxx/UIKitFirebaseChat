//
//  LoginVC+ImagePickerHandler.swift
//  FirebaseChat
//
//  Created by yu fai on 30/7/2016.
//  Copyright © 2016 YuFai. All rights reserved.
//

import UIKit

extension LoginVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func handleSelectImage(_ gesture: UITapGestureRecognizer){
        if gesture.state == .ended {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.allowsEditing = true
            pickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
            
            self.present(pickerController, animated: true, completion: nil)
        }
    }
// MARK: UIImagePickerControllerDelegate

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        if image == nil {
            image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        }
        contentView.profileImage.image = image
        
        self.dismiss(animated: true, completion: nil)
    }
}
