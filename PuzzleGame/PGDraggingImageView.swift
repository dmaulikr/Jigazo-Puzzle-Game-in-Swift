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
        
        self.isUserInteractionEnabled = true
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        self.addGestureRecognizer(gestureRecognizer)
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 0.5
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleTap(panGesture: UIPanGestureRecognizer) {
        
    }
    
    func handlePan(_ gesture: UIPanGestureRecognizer!) {
        
        self.layer.zPosition = 1
        
        if gesture.state == UIGestureRecognizerState.began {
            let locationInView = gesture.location(in: superview)
            initialPosition = self.frame
            dragStartPositionRelativeToCenter = CGPoint(x: locationInView.x - center.x, y: locationInView.y - center.y)
            
            return
        }
        
        if gesture.state == UIGestureRecognizerState.ended {
            
            self.layer.zPosition = 0
            
            let locationInView = gesture.location(in: superview)
            dragStartPositionRelativeToCenter = nil
            
            if delegate != nil {
                
                delegate?.didDgraggedToPoint(toPoint: locationInView,imageView:self,InitialPoint:initialPosition!)
            }
            
            return
        }
        
        let locationInView = gesture.location(in: superview)
        
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

