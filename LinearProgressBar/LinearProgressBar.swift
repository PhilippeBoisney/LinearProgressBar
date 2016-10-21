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
	fileprivate var heightForLinearBar: CGFloat
    fileprivate var isAnimationRunning = false
    
    //FOR DESIGN
	fileprivate lazy var progressBarIndicator: UIView = {
		let frame = CGRect(origin: CGPoint(x: 0, y:0), size: CGSize(width: 0, height: self.heightForLinearBar))
		return UIView(frame: frame)
	}()
		
    //PUBLIC VARS
    open var progressBarColor: UIColor = UIColor(red:0.12, green:0.53, blue:0.90, alpha:1.0)
	
	open var widthRatioOffset: CGFloat = 0.7
	open var xOffset: CGFloat = 0
	
	open var keyframeDuration: TimeInterval = 1.0
	
	public convenience init(height: CGFloat = 5) {
        self.init(frame: CGRect(origin: CGPoint(x: 0,y :20), size: CGSize(width: screenSize.width, height: height)))
    }
    
    override public init(frame: CGRect) {
		heightForLinearBar = frame.height
		var frame = frame
		frame.size.height = 0
		super.init(frame: frame)
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
		
		heightForLinearBar = self.frame.height
    }
    
    //MARK: PUBLIC FUNCTIONS    ------------------------------------------------------------------------------------------
    
	//Start the animation
	open func show(duration: TimeInterval = 0.5, delay: TimeInterval = 0) {
        
        self.show()
		
		guard !isAnimationRunning else {return}
        self.isAnimationRunning = true
		
		var rect = self.frame
		rect.size.height = self.heightForLinearBar
		
		UIView.animate(withDuration: duration, delay: delay, options: [], animations: {
			self.frame = rect
		}) { animationFinished in
			self.addSubview(self.progressBarIndicator)
			self.configureAnimations()
		}
    }
	
	//Animate specific progress value
	open func showProgress(progress: CGFloat, duration: TimeInterval = 0.5) {
		
		self.show()
		
		self.isAnimationRunning = false
		
		var rect = self.frame
		rect.size.height = self.heightForLinearBar
		
		var progressRect = self.progressBarIndicator.frame
		progressRect.origin = CGPoint.zero
		self.progressBarIndicator.frame = progressRect
		
		progressRect.size.width = self.frame.width * progress
		
		UIView.animate(withDuration: duration, delay: 0, options: [], animations: {
			self.frame = rect
		}) { animationFinished in
			self.addSubview(self.progressBarIndicator)
			UIView.animate(withDuration: duration) {
				self.progressBarIndicator.frame = progressRect
			}
		}
	}
	
    //Stop the animation
	open func dismiss(duration: TimeInterval = 0.5) {
		
		self.isAnimationRunning = false
		
		var rect = self.frame
		rect.size.height = 0
		
		UIView.animate(withDuration: duration, animations: {
			self.frame = rect
		}) { (finished: Bool) in
			self.progressBarIndicator.removeFromSuperview()
		}
    }
    
    //MARK: PRIVATE FUNCTIONS    ------------------------------------------------------------------------------------------
    
    fileprivate func show() {
		self.progressBarIndicator.backgroundColor = self.progressBarColor
		self.layoutIfNeeded()
		
        guard self.superview == nil, let view = getTopViewController()?.view else {return}
		view.addSubview(self)
    }
    
    fileprivate func configureAnimations() {
        
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
            guard self.isAnimationRunning else {return}
			self.configureAnimations()
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
