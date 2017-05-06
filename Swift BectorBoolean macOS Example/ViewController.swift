//
//  ViewController.swift
//  Swift BectorBoolean macOS
//
//  Created by Hiroaki Yamane on 5/6/17.
//  Copyright © 2017 Startside Softworks. All rights reserved.
//

import Cocoa
import VectorBoolean

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let rect = NSBezierPath(rect: CGRect(x: 50, y: 50, width: 300, height: 200))
        let circle = NSBezierPath(ovalIn: NSRect(x: 40, y: 40, width: 100, height: 100))
        let union = rect.fb_difference(circle)
        
        view.wantsLayer = true
        let layer = CAShapeLayer()
        layer.path = union.cgPath
        view.layer?.addSublayer(layer)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

