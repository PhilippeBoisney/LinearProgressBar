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

public class LinearProgressBar: UIView {
    
    //FOR DATA
    private var screenSize: CGRect = UIScreen.mainScreen().bounds
    private var isAnimationRunning = false
    
    //FOR DESIGN
    private var progressBarIndicator: UIView!
    
    //PUBLIC VARS
    public var backgroundProgressBarColor: UIColor = UIColor(red:0.73, green:0.87, blue:0.98, alpha:1.0)
    public var progressBarColor: UIColor = UIColor(red:0.12, green:0.53, blue:0.90, alpha:1.0)
    public var heightForLinearBar: CGFloat = 5
    public var widthForLinearBar: CGFloat = 0
    
    public init () {
        super.init(frame: CGRectMake(0, 20, screenSize.width, 0))
        self.progressBarIndicator = UIView(frame: CGRectMake(0, 0, 0, heightForLinearBar))
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.progressBarIndicator = UIView(frame: CGRectMake(0, 0, 0, heightForLinearBar))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: LIFE OF VIEW
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.screenSize = UIScreen.mainScreen().bounds
        
        if widthForLinearBar == 0 || widthForLinearBar == self.screenSize.height {
            widthForLinearBar = self.screenSize.width
        }
        
        if (UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation)) {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, widthForLinearBar, self.frame.height)
        }
        
        if (UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation)) {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, widthForLinearBar, self.frame.height)
        }
    }
    
    //MARK: PUBLIC FUNCTIONS    ------------------------------------------------------------------------------------------
    
    //Start the animation
    public func startAnimation(){

        self.configureColors()

        if !isAnimationRunning {
            self.isAnimationRunning = true

            UIView.animateWithDuration(0.5, delay:0, options: [], animations: {
                self.frame = CGRect(x: 0, y: self.frame.origin.y, width: self.widthForLinearBar, height: self.heightForLinearBar)
                }, completion: { animationFinished in
                    self.addSubview(self.progressBarIndicator)
                    self.configureAnimation()
            })
        }
    }
    
    //Start the animation
    public func stopAnimation() {
        
        self.isAnimationRunning = false
        
        UIView.animateWithDuration(0.5, animations: {
            self.progressBarIndicator.frame = CGRect(x: 0, y: 0, width: self.widthForLinearBar, height: 0)
            self.frame = CGRect(x: 0, y: self.frame.origin.y, width: self.widthForLinearBar, height: 0)
        })
    }
    
    //MARK: PRIVATE FUNCTIONS    ------------------------------------------------------------------------------------------
    
    private func configureColors(){
        
        self.backgroundColor = self.backgroundColor
        self.progressBarIndicator.backgroundColor = self.progressBarColor
    }
    
    private func configureAnimation() {
        
        self.progressBarIndicator.frame = CGRectMake(0, 0, 0, heightForLinearBar)

        UIView.animateWithDuration(0.5, delay:0, options: [], animations: {
            self.progressBarIndicator.frame = CGRect(x: 0, y: 0, width: self.widthForLinearBar*0.7, height: self.heightForLinearBar)
            }, completion: nil)
        
        UIView.animateWithDuration(0.4, delay:0.4, options: [], animations: {
            self.progressBarIndicator.frame = CGRect(x: self.frame.width, y: 0, width: 0, height: self.heightForLinearBar)
            }, completion: { animationFinished in
                if (self.isAnimationRunning){
                    self.configureAnimation()
                }
        })
    }
}