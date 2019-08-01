//
//  ExtensionUIImageView.swift
//  FirebaseChat
//
//  Created by yu fai on 6/8/2016.
//  Copyright © 2016 YuFai. All rights reserved.
//

import UIKit

var imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadUrlImageInCache(_ urlString: String) {
        
        self.image = nil
        
        //check cache for image firsNt
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        //otherwise fire off a new download
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { [ weak weakSelf = self ] (data, response, error) in
            
            //download hit an error so lets return out
            if error != nil {
                print(error)
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    
                    weakSelf?.image = downloadedImage
                }
            })
            
        }).resume()
    }
    
    
    func fetchURLImageInCache(_ URLString: String, complete: @escaping (_ image: UIImage, _ URLString: String) -> ())
    {
        self.image = nil
        
        //check cache for image firsNt
        if let cachedImage = imageCache.object(forKey: URLString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        if let url = URL(string: URLString) {
            DispatchQueue.global().async {
                let contentsOfURL = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let imageData = contentsOfURL{
                        if let downloadedImage = UIImage(data: imageData as Data) {
                            imageCache.setObject(downloadedImage, forKey: URLString as AnyObject)
//                                self.image = downloadedImage
                            complete(downloadedImage, URLString)
                        }
                    }
                }
            }
        }
    }
    
}

// Memory leak
//extension UIImageView {
//    
//    func loadUrlImageInCache(urlString: String){
//        self.image = nil
//        
//        if let cachedImage = imageCache.objectForKey(urlString) as? NSData {
//            self.image = UIImage(data: cachedImage)
//            return
//        }
//        
//        if let imageURL = NSURL(string: urlString ){
//            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
//            dispatch_async(dispatch_get_global_queue(qos, 0)){ () -> Void in
//                if let imageData = NSData(contentsOfURL: imageURL){ //block the main thread
//                    
//                    dispatch_async(dispatch_get_main_queue()) {
//
//                        imageCache.setObject(imageData, forKey: urlString)
//                        self.image = UIImage(data: imageData)
//
//                    }
//                }
//            }
//        }
//    }
//    
//}
