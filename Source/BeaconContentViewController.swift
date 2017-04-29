//
//  BeaconContentViewController.swift
//  Test360
//
//  Created by Kenneth Poon on 26/4/17.
//  Copyright © 2017 Kenneth Poon. All rights reserved.
//

import Foundation
import UIKit

class BeaconContentViewController: UIViewController {
    
    var webView = UIWebView()
    let imageFile: String
    
    init(imageFile: String) {
        self.imageFile = imageFile
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(webView)
        webView.fitToParentView()        
        webView.loadHTMLString(self.generateHtmlString(fileName: self.imageFile), baseURL: URL(fileURLWithPath: Bundle.main.bundlePath))
        
        let backButton = UIButton(frame: CGRect(x:20, y: 30, width: 30, height: 30))
        backButton.setImage(UIImage(named: "delete"), for: .normal)
        backButton.addTarget(self, action: #selector(closeContent), for: .touchUpInside)
        self.view.addSubview(backButton)
        
    }
    
    func generateHtmlString(fileName: String) -> String {
        return "<html><head><script src=\"https://aframe.io/releases/0.5.0/aframe.min.js\"></script></head><body><a-scene><a-sky src=\"\(fileName)\" rotation=\"0 -130 0\"></a-sky></a-scene></body></html>"    
    }
    
    func closeContent(){
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

public extension UIView {
    func fitToParentView(left:Int = 0,right:Int  = 0,top:Int  = 0,bottom:Int = 0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: CGFloat(top)))
        superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: CGFloat(left)))
        superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: CGFloat(bottom)))
        superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: CGFloat(right)))
    }
}

