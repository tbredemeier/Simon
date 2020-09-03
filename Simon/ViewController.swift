//
//  ViewController.swift
//  Simon
//
//  Created by tbredemeier on 9/2/20.
//  Copyright © 2020 tbredemeier. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet var colorDisplays: [UIView]!
    @IBOutlet weak var colorsFrame: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        flashColor(number: 0)
        flashColor(number: 1)
        flashColor(number: 2)
        flashColor(number: 3)
    }

    func flashColor(number: Int) {
        UIView.transition(with: colorDisplays[number], duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.colorDisplays[number].alpha = 1.0
        }) { (true) in
            UIView.transition(with: self.colorDisplays[number], duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.colorDisplays[number].alpha = 0.4
            }, completion: nil)
        }
    }

    @IBAction func onStartButtonTapped(_ sender: Any) {
    }

    @IBAction func onColorTapped(_ sender: UITapGestureRecognizer) {
        for index in 0..<colorDisplays.count {
             if colorDisplays[index].frame.contains(sender.location(in: colorsFrame)) {
                 flashColor(number: index)
             }
         }
    }

}

