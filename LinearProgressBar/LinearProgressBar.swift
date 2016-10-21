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

fileprivate var screenSize: CGRect {
	return UIScreen.main.bounds
}

open class LinearProgressBar: UIView {
    
    //FOR DATA
    fileprivate var isAnimationRunning = false
    
    //FOR DESIGN
    fileprivate var progressBarIndicator: UIView!
    
    //PUBLIC VARS
    open var backgroundProgressBarColor: UIColor = UIColor(red:0.73, green:0.87, blue:0.98, alpha:1.0)
    open var progressBarColor: UIColor = UIColor(red:0.12, green:0.53, blue:0.90, alpha:1.0)
    open var heightForLinearBar: CGFloat = 5
	
	open var widthRatioOffset: CGFloat = 0.7
	open var xOffset: CGFloat = 0
	
	open var keyframeDuration: TimeInterval = 1.0
	
    
    public convenience init() {
        self.init(frame: CGRect(origin: CGPoint(x: 0,y :20), size: CGSize(width: screenSize.width, height: 0)))
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.progressBarIndicator = UIView(frame: CGRect(origin: CGPoint(x: 0, y:0), size: CGSize(width: 0, height: heightForLinearBar)))
		self.clipsToBounds = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: LIFE OF VIEW
    override open func layoutSubviews() {
        super.layoutSubviews()
		
		var rect = self.frame
        
        if rect.width == 0 || rect.width == screenSize.height {
            rect.size.width = screenSize.width
        }
		
		self.frame = rect
    }
    
    //MARK: PUBLIC FUNCTIONS    ------------------------------------------------------------------------------------------
    
    //Start the animation
	open func show(duration: TimeInterval = 0.5, delay: TimeInterval = 0) {
        
        self.configureColors()
        self.show()
		
		guard !isAnimationRunning else {return}
        self.isAnimationRunning = true
		
		UIView.animate(withDuration: duration, delay: delay, options: [], animations: {
			self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: self.frame.width, height: self.heightForLinearBar))
		}) { animationFinished in
			self.addSubview(self.progressBarIndicator)
			self.configureAnimation()
		}
    }
	
    //Start the animation
	open func dismiss(duration: TimeInterval = 0.5) {
		
		guard isAnimationRunning else {return}
        self.isAnimationRunning = false
		
		UIView.animate(withDuration: duration, animations: { 
			self.frame = CGRect(x: 0, y: self.frame.origin.y, width: self.frame.width, height: 0)
		}) { (finished: Bool) in
			self.progressBarIndicator.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 0)
		}
    }
    
    //MARK: PRIVATE FUNCTIONS    ------------------------------------------------------------------------------------------
    
    fileprivate func show() {
        guard self.superview == nil, let view = getTopViewController()?.view else {return}
		view.addSubview(self)
    }
    
    fileprivate func configureColors() {
        self.backgroundColor = self.backgroundProgressBarColor
        self.progressBarIndicator.backgroundColor = self.progressBarColor
        self.layoutIfNeeded()
    }
    
    fileprivate func configureAnimation() {
        
        guard let _ = self.superview else {
            dismiss()
            return
        }
        
        self.progressBarIndicator.frame = CGRect(origin: CGPoint(x: 0, y :0), size: CGSize(width: 0, height: heightForLinearBar))
        
        UIView.animateKeyframes(withDuration: keyframeDuration, delay: 0, options: [], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: self.keyframeDuration/2) {
                self.progressBarIndicator.frame = CGRect(x: -self.xOffset, y: 0, width: self.frame.width * self.widthRatioOffset, height: self.heightForLinearBar)
            }
            
            UIView.addKeyframe(withRelativeStartTime: self.keyframeDuration/2, relativeDuration: self.keyframeDuration/2) {
                self.progressBarIndicator.frame = CGRect(x: self.frame.width, y: 0, width: self.xOffset, height: self.heightForLinearBar)
            }
            
        }) { (completed) in
            if (self.isAnimationRunning) {
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
