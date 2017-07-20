//
//  CounterView.swift
//  PuzzleGame
//
//  Created by Abhijith on 16/07/17.
//  Copyright © 2017 Abhijith. All rights reserved.
//

import Foundation
import UIKit

class PGCounterView: UIView {
    
    
    var originalFrame : CGRect?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        originalFrame = frame
        self.contentMode = .bottom
        self.backgroundColor = UIColor(hexString: "#899edc")
        startAnimation()
        
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }

    func startAnimation() {
        
        
        let originalY = self.frame.origin.y
        let originalH = self.bounds.size.height
        
        UIView.animate(withDuration: 20.0, animations: {
            self.frame = CGRect(x: (self.originalFrame?.origin.x)!, y: originalY + originalH, width: (self.originalFrame?.size.width)!, height: 0)
        })


    }

}
