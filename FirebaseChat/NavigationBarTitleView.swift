//
//  NavigationBarTitleView.swift
//  FirebaseChat
//
//  Created by yu fai on 5/8/2016.
//  Copyright © 2016 YuFai. All rights reserved.
//

class NavigationBarTitleView: UIView {
    
// MARK: Data
    
    var titleImageViewWidthConstraint: NSLayoutConstraint!
    var titleNameLabelWidthConstraint: NSLayoutConstraint!
    
// MARK: Outlet
    
    let containerView = UIView()
    
    let titleImageView = UIImageView()
    let titleNameLabel = UILabel()

// MARK: func
    

// MARK: View life cycle
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        
        titleNameLabel.text = "loading"
        titleNameLabel.backgroundColor = UIColor.clear
        
        titleImageView.image = UIImage(named: "curry")
        titleImageView.layer.cornerRadius = 20
        titleImageView.layer.masksToBounds = true
        titleImageView.contentMode = .scaleToFill
        
        self.backgroundColor = UIColor.clear
        
        containerView.addSubview(titleNameLabel)
        containerView.addSubview(titleImageView)
        
        self.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleImageView.translatesAutoresizingMaskIntoConstraints = false
        titleNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleNameLabelWidthConstraint = NSLayoutConstraint(item: titleNameLabel, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 160)
        titleImageViewWidthConstraint = NSLayoutConstraint(item: titleImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
        
        self.addConstraint(titleNameLabelWidthConstraint)
        self.addConstraint(titleImageViewWidthConstraint)
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]-[v1]|", options: [.alignAllCenterY], metrics: nil, views: ["v0":titleImageView, "v1":titleNameLabel]))
        
        self.addConstraint(NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: containerView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        
        
        self.addConstraint(NSLayoutConstraint(item: titleImageView, attribute: .height, relatedBy: .equal, toItem: titleImageView, attribute: .width, multiplier: 1, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: titleNameLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: titleNameLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        if(UIDevice.current.orientation.isLandscape) {
            titleNameLabelWidthConstraint.constant = 500
            titleImageViewWidthConstraint.constant = 20
            titleImageView.layer.cornerRadius = 10
        }
        
        if(UIDevice.current.orientation.isPortrait) {
            titleNameLabelWidthConstraint.constant = 160
            titleImageViewWidthConstraint.constant = 40
            titleImageView.layer.cornerRadius = 20
        }
        self.setNeedsUpdateConstraints()
    }
    
}
