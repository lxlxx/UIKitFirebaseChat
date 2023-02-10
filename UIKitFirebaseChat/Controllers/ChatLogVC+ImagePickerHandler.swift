//
//  ChatLogVC+ImagePickerHandler.swift
//  FirebaseChat
//
//  Created by yu fai on 23/8/2016.
//  Copyright © 2016 YuFai. All rights reserved.
//

import UIKit

extension ChatLogController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        if image == nil {
            image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
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
    guard let currentImage = image.pngData() else { return nil }
    if currentImage.count >= 10 * oneMB {
        print("image size too large")
    } else if currentImage.count >= oneMB {
        rightSizeImage = image.jpegData(compressionQuality: 0.01) // image size / 100
    } else if currentImage.count >= oneMB / 10 {
        rightSizeImage = image.jpegData(compressionQuality: 0.1)
    } else {
        rightSizeImage = image.jpegData(compressionQuality: 1)
    }
    return rightSizeImage
}
