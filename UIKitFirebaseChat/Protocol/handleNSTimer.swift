//
//  handleNSTimer.swift
//  FirebaseChat
//
//  Created by yu fai on 17/8/2016.
//  Copyright © 2016 YuFai. All rights reserved.
//

import UIKit

protocol handleNSTimer {
    var tableViewReloadTimer: Timer? { get set }
    func handleReload(_ reloadView: Selector)
}

extension handleNSTimer where Self: UIViewController {
//    var tableViewReloadTimer: NSTimer? { return tableViewReloadTimer != nil ? tableViewReloadTimer : nil }
    
    mutating func handleReload(_ reloadView: Selector){
        self.tableViewReloadTimer?.invalidate()
        self.tableViewReloadTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: reloadView, userInfo: nil, repeats: false)
    }
}

protocol handleTesting {
    var numberOfIcecream: Int? { get }
    func getNoIcecream()
}

extension handleTesting {
//    var numberOfIcecream: Int? { return 2 }
    func getNoIcecream() {
        print(numberOfIcecream)
    }
}
