//
//  ViewController.swift
//  Simon
//
//  Created by tbredemeier on 9/2/20.
//  Copyright © 2020 tbredemeier. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet var colorDisplays: [UIView]!
    @IBOutlet weak var colorsFrame: UIView!
    @IBOutlet weak var startButton: UIButton!

    var sound = AVAudioPlayer()
    var timer = Timer()
    var pattern = [Int]()
    var index = 0
    var playerTurn = false
    var gameOver = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func flashColor(number: Int) {
        playSound(fileName: String(number))
        UIView.transition(with: colorDisplays[number], duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.colorDisplays[number].alpha = 1.0
        }) { (true) in
            UIView.transition(with: self.colorDisplays[number], duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.colorDisplays[number].alpha = 0.4
            }, completion: nil)
        }
    }

    func displayPattern() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.nextColor)), userInfo: nil, repeats: true)
    }

    @objc func nextColor() {
        if index < pattern.count {
            flashColor(number: pattern[index])
            index += 1
        }
        else {
            timer.invalidate()
            index = 0
            playerTurn = true
            messageLabel.text = "Your turn"
        }
    }

    func addToPattern() {
        pattern.append(Int.random(in: 0..<4))
    }

    func restart() {
        pattern.removeAll()
        index = 0
        addToPattern()
        startButton.alpha = 1.0
    }

    func playSound(fileName: String)
    {
        if let path = Bundle.main.path(forResource: fileName, ofType: "wav") {
            let url = URL(fileURLWithPath: path)
            do {
                sound = try AVAudioPlayer(contentsOf: url)
                sound.play()
            }
            catch {
                print("Can't find \(fileName).wav file")
            }
        }
    }

    @IBAction func onStartButtonTapped(_ sender: Any) {
        if gameOver {
            restart()
            displayPattern()
            gameOver = false
            startButton.alpha = 0.0
        }
    }

    @IBAction func onColorTapped(_ sender: UITapGestureRecognizer) {
        if playerTurn {
            for number in 0..<colorDisplays.count {
                if colorDisplays[number].frame.contains(sender.location(in: colorsFrame)) {
                    if pattern[index] == number {
                        flashColor(number: number)
                        index += 1
                        if index == pattern.count {
                            index = 0
                            playerTurn = false
                            messageLabel.text = ""
                            addToPattern()
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                                self.displayPattern()
                            }
                        }
                    }
                    else {
                        messageLabel.text = "Game Over"
                        gameOver = true
                        restart()
                    }
                }
            }
        }
    }
}

