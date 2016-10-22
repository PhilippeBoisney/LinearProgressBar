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
	
	// MARK: - Private Variables
    
    fileprivate var isAnimationRunning = false
	
	fileprivate lazy var progressBarIndicator: UIView = {
		let frame = CGRect(origin: CGPoint(x: 0, y:0), size: CGSize(width: 0, height: self.progressBarHeight))
		return UIView(frame: frame)
	}()
		
	
	// MARK: Public Variables
	
	open var progressBarHeight: CGFloat
	
	/// Background color for the progress bar
    open var progressBarColor: UIColor = UIColor(red:0.12, green:0.53, blue:0.90, alpha:1.0)
	
	/// Used to determine how much variation the progress bar should animate
	open var widthRatioOffset: CGFloat = 0.7
	
	/// The offset used to determine how far offscreen the progress bar should start and finish animation
	open var xOffset: CGFloat = 0
	
	/// The progress bar animation duration
	open var keyframeDuration: TimeInterval = 1.0
	
	
	// MARK: Deprecated
	
	@available(*, deprecated, message: "Please use backgroundColor instead", renamed: "backgroundColor")
	var backgroundProgressBarColor: UIColor = UIColor.white
	
	@available(*, deprecated, message: "Please use progressBarHeight instead", renamed: "progressBarHeight")
	var heightForLinearBar: CGFloat = 5
	
	@available(*, deprecated, message: "Please adjust frame.size.width instead")
	var widthForLinearBar: CGFloat = 0
	
	
	// MARK: Inits
	
	public convenience init(height: CGFloat = 5) {
        self.init(frame: CGRect(origin: CGPoint(x: 0,y :20), size: CGSize(width: screenSize.width, height: height)))
    }
    
    override public init(frame: CGRect) {
		progressBarHeight = frame.height
		var frame = frame
		frame.size.height = 0
		super.init(frame: frame)
		self.clipsToBounds = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public Functions
	
	override open func layoutSubviews() {
		super.layoutSubviews()
		
		var rect = self.frame
		
		if rect.width == 0 || rect.width == screenSize.height {
			rect.size.width = screenSize.width
		}
		
		self.frame = rect
	}
	
	/**
	Shows the view, if not currently shown, then starts the animation
	
	- parameters:
		- duration: The animation duration for showing the view. Defaults to `0.5`
		- delay: The delay for showing the view. Defaults to `0.0`
	*/
	open func show(duration: TimeInterval = 0.5, delay: TimeInterval = 0) {
        
        self.display()
		
		guard !isAnimationRunning else {return}
        self.isAnimationRunning = true
		
		var rect = self.frame
		rect.size.height = self.progressBarHeight
		
		UIView.animate(withDuration: duration, delay: delay, options: [], animations: {
			self.frame = rect
		}) { animationFinished in
			self.addSubview(self.progressBarIndicator)
			self.configureAnimations()
		}
    }
	
	/**
	Shows the view, if not currently shown, then displays a specific progress value. This is useful for displaying progress of a task.
	
	- parameters:
		- progress: The progress of the task. Should be a value between `0.0` & `1.0`
		- duration: The animation duration for showing the view. Defaults to `0.5`
	*/
	open func showProgress(_ progress: CGFloat, duration: TimeInterval = 0.5) {
		
		self.display()
		
		self.isAnimationRunning = false
		
		var rect = self.frame
		rect.size.height = self.progressBarHeight
		
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
	
	/**
	Dismisses the view, if currently shown.
	
	- parameters:
		- duration: The animation duration for dismissing the view. Defaults to `0.5`
	*/
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
	
	
	//MARK: Private Functions
    
    fileprivate func display() {
		self.progressBarIndicator.backgroundColor = self.progressBarColor
		self.layoutIfNeeded()
		
        guard self.superview == nil, let view = UIApplication.shared.keyWindow?.visibleViewController?.view else {return}
		view.addSubview(self)
    }
    
    fileprivate func configureAnimations() {
        
        guard let _ = self.superview else {
            dismiss()
            return
        }
		
		guard self.isAnimationRunning else {return}
        
        self.progressBarIndicator.frame = CGRect(origin: CGPoint(x: 0, y :0), size: CGSize(width: 0, height: progressBarHeight))
        
        UIView.animateKeyframes(withDuration: keyframeDuration, delay: 0, options: [], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: self.keyframeDuration/2) {
                self.progressBarIndicator.frame = CGRect(x: -self.xOffset, y: 0, width: self.frame.width * self.widthRatioOffset, height: self.progressBarHeight)
            }
            
            UIView.addKeyframe(withRelativeStartTime: self.keyframeDuration/2, relativeDuration: self.keyframeDuration/2) {
                self.progressBarIndicator.frame = CGRect(x: self.frame.width, y: 0, width: self.xOffset, height: self.progressBarHeight)
            }
            
        }) { (completed) in
            guard self.isAnimationRunning else {return}
			self.configureAnimations()
        }
    }
	
	
	// MARK: Deprecated
	
	@available(*, deprecated, message: "Please use show() instead", renamed: "show")
	func startAnimation() {
		self.show()
	}
	
	@available(*, deprecated, message: "Please use dismiss() instead", renamed: "dismiss")
	func stopAnimation() {
		self.dismiss()
	}
}


// MARK: -

fileprivate extension UIWindow {
	
	/**
	Returns the currently visible view controller
	
	- returns: The visible view controller
	*/
	var visibleViewController: UIViewController? {
		return getVisibleViewController(forRootController: rootViewController)
	}
	
	/**
	Returns the visible view controller
	
	- parameters:
		- currentRootViewController: Current Root View Controller
	- returns: The visible view controller
	*/
	func getVisibleViewController(forRootController currentRootViewController: UIViewController?) -> UIViewController? {
		
		guard let controller = currentRootViewController else {return nil}
		
		switch controller {
			
		case let navVC as UINavigationController:
			return getVisibleViewController(forRootController: navVC.viewControllers.last)
			
		case let tabVC as UITabBarController:
			return getVisibleViewController(forRootController: tabVC.selectedViewController)
			
		case let controller where controller.presentedViewController != nil:
			return getVisibleViewController(forRootController: controller.presentedViewController)
			
		default:
			return controller
		}
	}
}
