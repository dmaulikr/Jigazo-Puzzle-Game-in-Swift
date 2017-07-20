//
//  PGActivityLoader.swift
//  PuzzleGame
//
//  Created by Abhijith on 19/07/17.
//  Copyright © 2017 Abhijith. All rights reserved.
//

import Foundation
import UIKit

class PGProgressIndicator: UIView {
    
    var indicatorColor:UIColor
    var loadingViewColor:UIColor
    var loadingMessage:String
    var holderView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    init(inview:UIView,loadingViewColor:UIColor,indicatorColor:UIColor,msg:String){
        
        self.indicatorColor = indicatorColor
        self.loadingViewColor = loadingViewColor
        self.loadingMessage = msg
        super.init(frame: CGRect(x:inview.frame.midX , y:inview.frame.midY  , width:50, height:50))
        self.center = inview.center
        initalizeIndicator()
        
    }
    convenience init(inview:UIView) {
        
        self.init(inview: inview,loadingViewColor: UIColor.brown,indicatorColor:UIColor.black, msg: "Loading..")
    }
    
    convenience init(inview:UIView,messsage:String) {
        
        
        self.init(inview: inview,loadingViewColor: UIColor.brown,indicatorColor:UIColor.black, msg: messsage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    func initalizeIndicator(){
        
        holderView.frame = self.bounds
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activityIndicator.tintColor = indicatorColor
        activityIndicator.hidesWhenStopped = true
        activityIndicator.frame = CGRect(x: holderView.frame.midX, y: holderView.frame.midY, width: 20, height: 20)
        activityIndicator.center = holderView.center
        print(activityIndicator.frame)
        holderView.layer.cornerRadius = 15
        holderView.backgroundColor = loadingViewColor
        holderView.alpha = 0.8
        holderView.addSubview(activityIndicator)
        
        
    }
    
    func  start(){
        //check if view is already there or not..if again started
        if !self.subviews.contains(holderView){
            
            activityIndicator.startAnimating()
            self.addSubview(holderView)
            
        }
    }
    
    func stop(){
        
        if self.subviews.contains(holderView){
            
            activityIndicator.stopAnimating()
            holderView.removeFromSuperview()
            
        }
}
}
