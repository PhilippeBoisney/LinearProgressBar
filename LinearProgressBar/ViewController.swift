//
//  ViewController.swift
//  LinearProgressBar
//
//  Created by Philippe Boisney on 06/12/2015.
//  Copyright © 2015 Philippe Boisney. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let linearBar: LinearProgressBar = LinearProgressBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureLinearProgressBar()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startAnimation(sender: AnyObject) {
        self.linearBar.startAnimation()
    }
    
    
    @IBAction func stopAnimation(sender: AnyObject) {
        self.linearBar.stopAnimation()
    }

    func configureLinearProgressBar(){
        
        linearBar.backgroundColor = UIColor(red:0.68, green:0.81, blue:0.72, alpha:1.0)
        linearBar.progressBarColor = UIColor(red:0.26, green:0.65, blue:0.45, alpha:1.0)
        linearBar.heightForLinearBar = 5
        self.view.addSubview(linearBar)
        
    }


}

