//
//  ChatLogVC+ImagePickerHandler.swift
//  FirebaseChat
//
//  Created by yu fai on 23/8/2016.
//  Copyright © 2016 YuFai. All rights reserved.
//

import UIKit

extension ChatLogController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var image = info[UIImagePickerControllerEditedImage] as? UIImage
        if image == nil {
            image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        
        if let imageWillUpload = image {
            sendImage(imageWillUpload)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}

func compressImage(_ image: UIImage, defaultSize: Int = 1 * 1000 * 1000) -> Data? {
    let oneMB = defaultSize // 1 MB default
    var rightSizeImage: Data!
    guard let currentImage = UIImagePNGRepresentation(image) else { return nil }
    if currentImage.count >= 10 * oneMB {
        print("image size too large")
    } else if currentImage.count >= oneMB {
        rightSizeImage = UIImageJPEGRepresentation(image, 0.01) // image size / 100
    } else if currentImage.count >= oneMB / 10 {
        rightSizeImage = UIImageJPEGRepresentation(image, 0.1)
    } else {
        rightSizeImage = UIImageJPEGRepresentation(image, 1)
    }
    return rightSizeImage
}
