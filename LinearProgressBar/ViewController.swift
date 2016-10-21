//
//  ViewController.swift
//  LinearProgressBar
//
//  Created by Philippe on 07/10/2016.
//  Copyright © 2016 CookMinute. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
	var linearBar: LinearProgressBar = {
		
		var bar = LinearProgressBar(frame: CGRect(x: 10, y: UIScreen.main.bounds.height - 200, width: UIScreen.main.bounds.width - 20, height: 0))
		
		bar.backgroundColor = UIColor(red:0.68, green:0.81, blue:0.72, alpha:1.0)
		bar.progressBarColor = UIColor(red:0.26, green:0.65, blue:0.45, alpha:1.0)
		bar.heightForLinearBar = 5
		bar.widthRatioOffset = 0.78
		bar.xOffset = 15
		bar.keyframeDuration = 1.2
		
		return bar
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.addSubview(linearBar)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func startAnimation(_ sender: AnyObject) {
		self.linearBar.show(duration: 0.3, delay: 0.0)
    }
    
    @IBAction func stopAnimation(_ sender: AnyObject) {
        self.linearBar.dismiss(duration: 0.3)
    }
}

