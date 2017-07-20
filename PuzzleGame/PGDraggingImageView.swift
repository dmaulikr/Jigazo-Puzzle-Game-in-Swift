//
//  DraggingImageView.swift
//  PuzzleGame
//
//  Created by Abhijith on 08/07/17.
//  Copyright © 2017 Abhijith. All rights reserved.
//

import Foundation
import UIKit

protocol DraggingImageViewProtocol : NSObjectProtocol {
    
    func didDgraggedToPoint(toPoint:CGPoint,imageView:PGDraggingImageView,InitialPoint:CGRect)
}


class PGDraggingImageView: UIImageView {
    
    
    var dragStartPositionRelativeToCenter : CGPoint?
    var initialPosition : CGRect?
    var isOrderedArrangement : UIImage?
    var isInCorrectPosition : Bool = false
    var correctFrame : CGRect?
    
    
    weak var delegate : DraggingImageViewProtocol?
    
    override init(image: UIImage!) {
        super.init(image: image)
        
        self.isUserInteractionEnabled = true   //< w00000t!!!1
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        self.addGestureRecognizer(gestureRecognizer)
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 2
        layer.borderWidth = 2
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleTap(panGesture: UIPanGestureRecognizer) {
        
    }
    
    func handlePan(_ nizer: UIPanGestureRecognizer!) {
        
        self.layer.zPosition = 1
        
        if nizer.state == UIGestureRecognizerState.began {
            let locationInView = nizer.location(in: superview)
            initialPosition = self.frame
            dragStartPositionRelativeToCenter = CGPoint(x: locationInView.x - center.x, y: locationInView.y - center.y)
            
            layer.shadowOffset = CGSize(width: 0, height: 20)
            layer.shadowOpacity = 0.3
            layer.shadowRadius = 6
            
            return
        }
        
        if nizer.state == UIGestureRecognizerState.ended {
            
            self.layer.zPosition = 0
            
            let locationInView = nizer.location(in: superview)
            dragStartPositionRelativeToCenter = nil
            
            layer.shadowOffset = CGSize(width: 0, height: 3)
            layer.shadowOpacity = 0.5
            layer.shadowRadius = 2
            
            if delegate != nil {
                
                delegate?.didDgraggedToPoint(toPoint: locationInView,imageView:self,InitialPoint:initialPosition!)
            }
            
            return
        }
        
        let locationInView = nizer.location(in: superview)
        
        UIView.animate(withDuration: 0.1) {
            self.center = CGPoint(x: locationInView.x - self.dragStartPositionRelativeToCenter!.x,
                                  y: locationInView.y - self.dragStartPositionRelativeToCenter!.y)
        }
    }
    
    func checkImageViewInCorrectPosition()-> Bool {
        
        if self.frame.equalTo(correctFrame!) {
            
            return true
        }
        
        return false
        
    }

    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */   
}

