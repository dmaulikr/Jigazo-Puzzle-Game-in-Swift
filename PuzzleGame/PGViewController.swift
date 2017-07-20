//
//  ViewController.swift
//  PuzzleGame
//
//  Created by Abhijith on 08/07/17.
//  Copyright © 2017 Abhijith. All rights reserved.
//

import UIKit


class PGViewController: UIViewController,DraggingImageViewProtocol,UIGestureRecognizerDelegate {
    
    var imageArray = [UIImage]()
    var numberOfMoves = 0
    var counter = PGConstants.counterTime
    var countLabel : UILabel?
    var closeButton : UIButton?
    var timer = Timer()
    var indicator:PGProgressIndicator?
    
    let startImageView = UIImageView()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.layerGradient()
        
        //** start puzzle by default
        showStartImage()
        
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscape
    }
    
    //MARK: Custom Methods
    
    //** call this methode to start a new puzzle
    
    func showStartImage() {
        
        //**Clear screen
        let subViews = self.view.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
        
        startImageView.frame = self.view.bounds
        startImageView.contentMode = .scaleAspectFit
        self.view.addSubview(startImageView)
        
        indicator = PGProgressIndicator(inview:self.view,loadingViewColor: UIColor.lightGray, indicatorColor: UIColor.black, msg: "")
        startImageView.addSubview(indicator!)
        indicator!.start()

        
        PGServices.getImageFromWeb(PGConstants.imageUrl) { (image) in
            if image != nil {
                var image = image!
                DispatchQueue.main.async {
                    
                    image = image.resizeImage(newWidth: UIScreen.main.bounds.width-60)!
                    self.startImageView.image = image
                    DispatchQueue.main.asyncAfter(deadline: .now() + PGConstants.imageDisplayTime ) {
                        self.startPuzzle(image:image)
                    }
                    self.indicator!.stop()
                }
            }

        }
        
    }
    
    //** Start the puzzle
    
    func startPuzzle(image:UIImage) {

            self.imageArray.removeAll()
            self.startImageView.removeFromSuperview()
            self.imageArray = image.splitImage()
            self.createImageGrid(image: image)
            self.shuffleImageGrid(image: image)
            self.addCounterView()
            self.timer.invalidate()
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCounter), userInfo: nil, repeats: true)
        
    }

    


}

//MARK:Image Grid view related

extension PGViewController {
    
    //MARK: DraggingImageView Delegate methods
    
    func didDgraggedToPoint(toPoint:CGPoint,imageView:PGDraggingImageView,InitialPoint initialPoint:CGRect) {
        
        
        swapViews(currentImageView: imageView,initialPosition:initialPoint)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.checkImageViewsInOrder() {
                
                let alert = UIAlertController(title: "Good job..!", message: "\(self.numberOfMoves) Moves", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        
        
    }
    
    //MARK: Custom methods
    
    func shuffleImageGrid(image:UIImage) {
        
        var allImageViews = self.view.subviews.filter{$0 is PGDraggingImageView}.shuffled()
        
        let width = Double(image.size.width/CGFloat(PGConstants.gridColumnCount))
        let height = Double((image.size.height/CGFloat(PGConstants.gridRowCount)))
        var p  = 0.0
        var q  = 0.0
        
        for i in 1 ... PGConstants.totalGridsCount {
            
            let imageView = allImageViews [i-1] as! PGDraggingImageView
            
            //**Adding margin
            //let marginOffest = 10
            //let marginYoffset = Double(UIScreen.main.bounds.height-image.size.height)/2
            let positionX = width*p //+ Double(marginOffest)
            let positionY = height*q //+ marginYoffset

            let rect = CGRect(x: positionX, y: positionY, width: width, height: height)
            imageView.frame = rect
            
            print(rect)
            
            //**Some views can be in correct position even after shuffle.So check adn add the position flag.
            if imageView.checkImageViewInCorrectPosition() {
                imageView.isInCorrectPosition = true
            }
            else {
                imageView.isInCorrectPosition = false
            }
            imageView.tag = i
            imageView.isUserInteractionEnabled = true
            imageView.delegate = self
            self.view.addSubview(imageView)
            
            p += 1
            
            if i % PGConstants.gridColumnCount == 0 {
                p = 0
                q += 1
            }
            
        }
        
        
    }
    
    
    
    func createImageGrid(image:UIImage) {
        
        let width = Double(image.size.width/CGFloat(PGConstants.gridColumnCount))
        let height = Double((image.size.height/CGFloat(PGConstants.gridRowCount)))
        var p  = 0.0
        var q  = 0.0
        
        for i in 1 ... PGConstants.totalGridsCount {
            
            let image = imageArray[i-1] as UIImage
            let imageView = PGDraggingImageView(image:image)
            
            //**Adding margin
            //let marginOffest = 10
            //let marginYoffset = Double(UIScreen.main.bounds.height-image.size.height)/2
            let positionX = width*p //+ Double(marginOffest)
            let positionY = height*q //+ marginYoffset
            
            let rect = CGRect(x: positionX, y: positionY, width: width, height: height)
            
            print("\(i) -- \(rect)")
            
            imageView.frame = rect
            imageView.isInCorrectPosition = true
            //imageView.contentMode = .top
            imageView.isUserInteractionEnabled = true
            imageView.correctFrame = rect
            imageView.tag = i
            imageView.delegate = self
            self.view.addSubview(imageView)
            
            p += 1
            
            if i%4 == 0 {
                p = 0
                q += 1
            }
            
        }
        
        
        
        
        //shuffle
        
        imageArray = imageArray.shuffled()
        
        
    }
    
    func checkImageViewsInOrder()-> Bool {
        
        var allImageViews = self.view.subviews.filter{$0 is PGDraggingImageView}
        
        for i in 1 ... PGConstants.totalGridsCount {
            
            //let image = imageArray[i-1] as UIImage
            let imageView = allImageViews [i-1] as! PGDraggingImageView
            
            if imageView.isInCorrectPosition {
                print("correct..")
                continue
            }
            else {
                print("wrong..")
                print(i)
                return false
            }
            
        }
        
        return true
        
    }
    
    
    func swapViews(currentImageView:PGDraggingImageView,initialPosition:CGRect) {
        

        let currentPoint = currentImageView.center
        let newImgView = getSubViewInPoint(point: currentPoint,currrentImageView : currentImageView)
        
        newImgView?.layer.zPosition = 1
        currentImageView.layer.zPosition = 1
        
        if newImgView != nil {
            
            
            if newImgView?.tag == currentImageView.tag {
                UIView.animate(withDuration: 0.15,
                               delay: 0.1,
                               options: UIViewAnimationOptions.curveEaseIn,
                               animations: { () -> Void in
                                
                                currentImageView.frame = initialPosition
                                
                                
                    }, completion: { (finished) -> Void in
                        // ....
                        currentImageView.layer.zPosition = 0
                        self.numberOfMoves += 1
                        if currentImageView.checkImageViewInCorrectPosition() {
                            currentImageView.isInCorrectPosition = true
                            print("BINGO>>>!")
                        }

                })
            }
            else {
                
                UIView.animate(withDuration: 0.15,
                               delay: 0.1,
                               options: UIViewAnimationOptions.curveEaseIn,
                               animations: { () -> Void in
                                
                                currentImageView.frame = (newImgView?.frame)!
                                newImgView?.frame = initialPosition
                                
                    }, completion: { (finished) -> Void in
                        currentImageView.layer.zPosition = 0
                        newImgView?.layer.zPosition = 0
                        self.numberOfMoves += 1
                        if currentImageView.checkImageViewInCorrectPosition() {
                            currentImageView.isInCorrectPosition = true
                            print("BINGO>>>!")
                        }
                        if (newImgView?.checkImageViewInCorrectPosition())! {
                            newImgView?.isInCorrectPosition = true
                            print("BINGO>>>!")
                        }

                })
            }
            
        }
        else {
            
            UIView.animate(withDuration: 0.2,
                           delay: 0.1,
                           options: UIViewAnimationOptions.curveEaseIn,
                           animations: { () -> Void in
                            
                            currentImageView.frame = initialPosition
                            
                }, completion: { (finished) -> Void in
                    // ....
                    
                    if currentImageView.checkImageViewInCorrectPosition() {
                        currentImageView.isInCorrectPosition = true
                        print("BINGO>>>!")
                    }
            })
        }
        
        
        
    }
    
    func getSubViewInPoint(point:CGPoint,currrentImageView:PGDraggingImageView) -> PGDraggingImageView? {
        
        let imageViewArray = self.view.subviews.filter{$0 is PGDraggingImageView}
        
        for imgView in imageViewArray {
            
            if imgView.tag != currrentImageView.tag {
                
                let grabImgView = imgView as! PGDraggingImageView
                print(imgView.bounds)
                
                if (imgView.frame.contains(point)) {
                    
                    return grabImgView
                    
                }
            }
            
            
            
        }
        
        return nil
        
    }
    

    
}

//MARK: Counter view related

extension PGViewController {

    func addCounterView() {
        
        let bgView = UIImageView(frame: CGRect(x: UIScreen.main.bounds.width-50, y: 40, width: 35, height: UIScreen.main.bounds.height-45))
        bgView.image = UIImage(named:"counter_background")
        self.view.addSubview(bgView)
        
        let counterView = PGCounterView(frame: bgView.frame)
        self.view.addSubview(counterView)
        
        closeButton = UIButton(frame: CGRect(x: bgView.frame.origin.x+3, y: 5, width: 30, height: 30))
        closeButton?.setImage(UIImage(named:"cancel_button"), for: .normal)
        closeButton?.addTarget(self, action:#selector(self.closeButtonClicked), for: .touchUpInside)
        closeButton?.isEnabled = false
        self.view.addSubview(closeButton!)
        
        countLabel = UILabel(frame: CGRect(x: bgView.frame.origin.x+7, y: bgView.frame.origin.y+bgView.frame.size.height-30, width: 22, height: 22))
        
        countLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 17.0)
        countLabel?.textColor = UIColor.white
        counter = PGConstants.counterTime
        countLabel?.text = "\(counter)"
        
        self.view.addSubview(countLabel!)
        
    }
    
    func updateCounter() {
        if counter > 0 {
            counter -= 1
        }
        
        if counter == 0 {
            
            closeButton?.isEnabled = true
        }
        
        countLabel?.text = "\(counter)"
        
    }
    
    func closeButtonClicked() {
        
        if counter == 0 {
            showStartImage()
            closeButton?.isEnabled = false
        }
        
    }
    
}




