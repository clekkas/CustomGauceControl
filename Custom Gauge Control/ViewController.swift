//
//  ViewController.swift
//  Custom Gauge Control
//
//  Created by Lekkas, Chris (Hillsboro) on 12/17/18.
//  Copyright © 2018 Lekkas, Chris (Hillsboro). All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let test = GaugeView(frame: CGRect(x: 40, y: 40, width: 256, height: 256))
        test.backgroundColor = .clear
        view.addSubview(test)
    }


}

