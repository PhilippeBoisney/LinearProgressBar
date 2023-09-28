//
//  LinearProgressBar.swift
//  CookMinute
//
//  Created by Philippe Boisney on 18/11/2015.
//  Copyright © 2015 CookMinute. All rights reserved.
//
//  Google Guidelines: https://www.google.com/design/spec/components/progress-activity.html#progress-activity-types-of-indicators
//

import UIKit

open class LinearProgressBar: UIView {
    
    //FOR DATA
    fileprivate var screenSize: CGRect = UIScreen.main.bounds
    fileprivate var isAnimationRunning = false
    fileprivate var blurEffectView = UIVisualEffectView()
    fileprivate var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    
    //FOR DESIGN
    fileprivate var progressBarIndicator: UIView!
    
    //PUBLIC VARS
    open var backgroundProgressBarColor: UIColor = UIColor(red:0.73, green:0.87, blue:0.98, alpha:1.0)
    open var progressBarColor: UIColor = UIColor(red:0.12, green:0.53, blue:0.90, alpha:1.0)
    open var heightForLinearBar: CGFloat = 5
    open var widthForLinearBar: CGFloat = 0
    
    public init () {
        
        var yPosition : CGFloat = 20.0
        if #available(iOS 11.0, *) {
            let safeAreatop = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0.0
            yPosition = UIApplication.shared.statusBarFrame.height
            if (safeAreatop > 20) && (safeAreatop < 50){
                yPosition = UIApplication.shared.statusBarFrame.height-10
            }
        }
        
        super.init(frame: CGRect(origin: CGPoint(x: 0,y : yPosition), size: CGSize(width: screenSize.width, height: 0)))
        self.progressBarIndicator = UIView(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 0, height: heightForLinearBar)))
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.progressBarIndicator = UIView(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 0, height: heightForLinearBar)))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: LIFE OF VIEW
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.screenSize = UIScreen.main.bounds
        
        if widthForLinearBar == 0 || widthForLinearBar == self.screenSize.height {
            widthForLinearBar = self.screenSize.width
        }
        
        if (UIDevice.current.orientation.isLandscape) {
           self.frame = CGRect(origin: CGPoint(x: self.frame.origin.x,y :self.frame.origin.y), size: CGSize(width: widthForLinearBar, height: self.frame.height))
        }
        
        if (UIDevice.current.orientation.isPortrait) {
            self.frame = CGRect(origin: CGPoint(x: self.frame.origin.x,y :self.frame.origin.y), size: CGSize(width: widthForLinearBar, height: self.frame.height))
        }
    }
    
    //MARK: PUBLIC FUNCTIONS    ------------------------------------------------------------------------------------------
    
    //Start the animation
    open func startAnimation(){

        //self.superview?.isUserInteractionEnabled = true
        self.configureColors()
        
        self.show()
                
        if !isAnimationRunning {
            self.isAnimationRunning = true
            
            UIView.animate(withDuration: 0.5, delay:0, options: [], animations: {
                self.frame = CGRect(x: 0, y: self.frame.origin.y, width: self.widthForLinearBar, height: self.heightForLinearBar)
                }, completion: { animationFinished in
                    self.addSubview(self.progressBarIndicator)
                    self.configureAnimation()
            })
        }
    }
    
    open func startAnimationWithInteraction(enabled : Bool){
        if enabled {
            self.superview?.isUserInteractionEnabled = true
        }
        else {
            self.superview?.isUserInteractionEnabled = false
        }

        self.configureColors()
        
        self.show()
        
        if !isAnimationRunning {
            self.isAnimationRunning = true
            
            UIView.animate(withDuration: 0.5, delay:0, options: [], animations: {
                self.frame = CGRect(x: 0, y: self.frame.origin.y, width: self.widthForLinearBar, height: self.heightForLinearBar)
                }, completion: { animationFinished in
                    self.addSubview(self.progressBarIndicator)
                    self.configureAnimation()
            })
        }
    }
    
    //Start the animation
    open func stopAnimation() {
       
        //self.superview?.isUserInteractionEnabled = false
        self.isAnimationRunning = false
        
        UIView.animate(withDuration: 0.5, animations: {
            self.progressBarIndicator.frame = CGRect(x: 0, y: 0, width: self.widthForLinearBar, height: 0)
            self.frame = CGRect(x: 0, y: self.frame.origin.y, width: self.widthForLinearBar, height: 0)
        })
    }
    
    //Start the animation
    open func startActivityAnimation(){
        
        self.configureActivityColors()
        
        if !actInd.isAnimating {
            if let topController = getTopViewController() {
                actInd.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
                actInd.style =
                    UIActivityIndicatorView.Style.whiteLarge
                actInd.center = CGPoint(x: topController.view.frame.size.width / 2, y: topController.view.frame.size.height / 2)
                topController.view.addSubview(actInd)
                actInd.startAnimating()
            }
        }
    }
    
    open func stopActivityAnimation(){
        actInd.stopAnimating()
        actInd.removeFromSuperview()
    }
    
    
    open func showBlurrView () {
        if let topController = getTopViewController() {
            if #available(iOS 10.0, *) {
                let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
                blurEffectView = UIVisualEffectView(effect: blurEffect)
                blurEffectView.frame = topController.view.bounds
                blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                topController.view.addSubview(blurEffectView)
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    open func hideBlurrView () {
        blurEffectView.removeFromSuperview()
    }
    

    //MARK: PRIVATE FUNCTIONS    ------------------------------------------------------------------------------------------
    
    fileprivate func show() {
        
        // Only show once
        if self.superview != nil {
            return
        }
        
        // Find current top viewcontroller
        if let topController = getTopViewController() {
            let superView: UIView = topController.view
            superView.addSubview(self)
        }
    }
    
    fileprivate func configureColors(){
        DispatchQueue.main.async {
            self.backgroundColor = self.backgroundProgressBarColor
        }
        self.progressBarIndicator.backgroundColor = self.progressBarColor
        self.layoutIfNeeded()
    }
    
    fileprivate func configureActivityColors(){
        self.actInd.color = self.progressBarColor
        self.layoutIfNeeded()
    }
    
    fileprivate func configureAnimation() {
        
        guard let superview = self.superview else {
            stopAnimation()
            return
        }
        
        self.progressBarIndicator.frame = CGRect(origin: CGPoint(x: 0, y :0), size: CGSize(width: 0, height: heightForLinearBar))
        
        UIView.animateKeyframes(withDuration: 1.0, delay: 0, options: [], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                self.progressBarIndicator.frame = CGRect(x: 0, y: 0, width: self.widthForLinearBar*0.7, height: self.heightForLinearBar)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                self.progressBarIndicator.frame = CGRect(x: superview.frame.width, y: 0, width: 0, height: self.heightForLinearBar)
                
            })
            
        }) { (completed) in
            if (self.isAnimationRunning){
                self.configureAnimation()
            }
        }
    }
    
    // -----------------------------------------------------
    //MARK: UTILS    ---------------------------------------
    // -----------------------------------------------------
    
    fileprivate func getTopViewController() -> UIViewController? {
        var topController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        while topController?.presentedViewController != nil {
            topController = topController?.presentedViewController
        }
        return topController
    }
}
