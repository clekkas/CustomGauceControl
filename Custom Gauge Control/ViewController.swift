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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 1){
                test.value = 33
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            UIView.animate(withDuration: 1){
                test.value = 66
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            UIView.animate(withDuration: 1){
                test.value = 0
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 12) {
            UIView.animate(withDuration: 1){
                test.value = 99
            }
        }

    }


}

