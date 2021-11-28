//
//  extension.swift
//  FacebookMessenger
//
//  Created by yu fai on 19/4/16.
//  Copyright © 2016 YuFai. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    
    convenience init(v1 view1: AnyObject, a attr1: NSLayoutConstraint.Attribute, r relation: NSLayoutConstraint.Relation = .equal, v2 view2: AnyObject?, a2 attr2: NSLayoutConstraint.Attribute? = nil, m multiplier: CGFloat = 1.0, c constant: CGFloat = 0) {
        
        if attr2 == nil {
            self.init(item: view1, attribute: attr1, relatedBy: relation, toItem: view2, attribute: attr1, multiplier: multiplier, constant: constant)
        } else {
            self.init(item: view1, attribute: attr1, relatedBy: relation, toItem: view2, attribute: attr2!, multiplier: multiplier, constant: constant)
        }
    }
    
    convenience init(v view: AnyObject, WorH: NSLayoutConstraint.Attribute, c constant: CGFloat){
        self.init(item: view, attribute: WorH, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: constant)
    }
    
}

extension UIView {
    
    func addConstraintsWithFormat(_ format: String, views: UIView..., options: NSLayoutConstraint.FormatOptions = NSLayoutConstraint.FormatOptions(), metrics:[String: CGFloat]?=nil){
        
        var viewsDicationary = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDicationary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: options, metrics: metrics, views: viewsDicationary))
    }
    
    
    func addAutoLayout(v1 view1: UIView, a attr1: NSLayoutConstraint.Attribute, v2 view2: AnyObject, a2 attr2: NSLayoutConstraint.Attribute?=nil, r relation: NSLayoutConstraint.Relation=NSLayoutConstraint.Relation.equal,c constant: CGFloat=0, m multiplier:CGFloat=1){
        
        if attr2 == nil {
            self.addConstraint(NSLayoutConstraint(item: view1, attribute: attr1, relatedBy: relation, toItem: view2, attribute: attr1, multiplier: multiplier, constant: constant))
        } else {
            self.addConstraint(NSLayoutConstraint(item: view1, attribute: attr1, relatedBy: relation, toItem: view2, attribute: attr2!, multiplier: multiplier, constant: constant))
        }
    }
    
    func addAutoLayoutHeightWidth(v view1: UIView, setHeight: CGFloat?=nil, setWidth: CGFloat?=nil, relation: NSLayoutConstraint.Relation=NSLayoutConstraint.Relation.equal){
        
        if setHeight != nil {
            self.addConstraint(NSLayoutConstraint(item: view1, attribute: .height, relatedBy: relation, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: setHeight!))
        }
        if setWidth != nil {
            self.addConstraint(NSLayoutConstraint(item: view1, attribute: .width, relatedBy: relation, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: setWidth!))
        }
    }
    
    
    // put v1 into v2 with 8px packing
    func packInSubview(v1 contentView: UIView, v2 containerView: UIView, left:Bool=true, right:Bool=true, top:Bool=true, bottom:Bool=true,c constant:CGFloat=8){
        
        let Options: [Bool] = [left, right, top, bottom]
        let Attributes: [NSLayoutConstraint.Attribute] = [NSLayoutConstraint.Attribute.left, NSLayoutConstraint.Attribute.right, NSLayoutConstraint.Attribute.top, NSLayoutConstraint.Attribute.bottom]
        let constants: [CGFloat] = [constant, -constant, constant, -constant]
        
        for (index, option) in Options.enumerated() {
            if option {
                self.addConstraint(NSLayoutConstraint(item: contentView, attribute: Attributes[index], relatedBy: .equal, toItem: containerView, attribute: Attributes[index], multiplier: 1, constant: constants[index]))
            }
        }
    }
    
}
