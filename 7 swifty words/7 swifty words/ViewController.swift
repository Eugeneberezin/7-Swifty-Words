//
//  ViewController.swift
//  7 swifty words
//
//  Created by Eugene Berezin on 9/30/19.
//  Copyright © 2019 Eugene Berezin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
           var cluesLabel: UILabel!
           var answersLabel: UILabel!
           var currentAnswer: UITextField!
           var scoreLabel: UILabel!
           var letterButtons = [UIButton]()
           var activatedButtons = [UIButton]()
           var solutions = [String]()

    var score = 0 {
        didSet {
            scoreLabel.text = "Your score is: \(score)"
        }
    }
           var level = 1
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = {
            let label = UILabel()
            label.textAlignment                             = .right
            label.text                                      = "Score: 0"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        view.addSubview(scoreLabel)
        
        cluesLabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text                                      = "CLUES"
            label.font                                      = UIFont.systemFont(ofSize: 24)
            label.numberOfLines                             = 0
            return label
    
        }()
        view.addSubview(cluesLabel)
        
        answersLabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font                                      = UIFont.systemFont(ofSize: 24)
            label.text                                      = "ANSWER"
            label.numberOfLines                             = 0
            label.textAlignment                             = .right
           return label
        }()
        view.addSubview(answersLabel)
        
        currentAnswer = {
            let tf = UITextField()
            tf.translatesAutoresizingMaskIntoConstraints = false
            tf.placeholder = "Tap letters to guess"
            tf.textAlignment = .center
            tf.font = UIFont.systemFont(ofSize: 44)
            tf.isUserInteractionEnabled = false
            return tf
        }()
        view.addSubview(currentAnswer)
        
        // You can fofigure your UI elements either in closure or like that.
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submit)

        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        view.addSubview(clear)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        
        NSLayoutConstraint.activate([
               scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
               scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 0),
               cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
               cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
               cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
               answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
               answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),

               // make the answers label take up 40% of the available space, minus 100
               answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),

               // make the answers label match the height of the clues label
               answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
               currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
               currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
               currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
               submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
               submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
               submit.heightAnchor.constraint(equalToConstant: 44),

               clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
               clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
               clear.heightAnchor.constraint(equalToConstant: 44),
               buttonsView.widthAnchor.constraint(equalToConstant: 750),
               buttonsView.heightAnchor.constraint(equalToConstant: 320),
               buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
               buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
               buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
            
            
            
           ])
        
        // set some values for the width and height of each button
        let width = 150
        let height = 80

        // create 20 buttons as a 4x5 grid
        for row in 0..<4 {
            for col in 0..<5 {
                // create a new button and give it a big font size
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)

                // give the button some temporary text so we can see it on-screen
                letterButton.setTitle("WWW", for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)

                // calculate the frame of this button using its column and row
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame

                // add it to the buttons view
                buttonsView.addSubview(letterButton)

                // and also to our letterButtons array
                letterButtons.append(letterButton)
            }
        }
        
        
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        
    }

    override func viewDidLoad() {
    
        super.viewDidLoad()
        loadLevel()
        
    
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        activatedButtons.append(sender)
        sender.isHidden = true
    }

    @objc func submitTapped(_ sender: UIButton) {
        guard let answerText = currentAnswer.text else { return }

           if let solutionPosition = solutions.firstIndex(of: answerText) {
               activatedButtons.removeAll()

               var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
               splitAnswers?[solutionPosition] = answerText
               answersLabel.text = splitAnswers?.joined(separator: "\n")

               currentAnswer.text = ""
               score += 1
               

               if score % 7 == 0 {
                   let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
                   ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
                   present(ac, animated: true)
               }
           }
        
    }
    
    func levelUp(action: UIAlertAction) {
        level += 1
        solutions.removeAll(keepingCapacity: true)

        loadLevel()

        for btn in letterButtons {
            btn.isHidden = false
        }
    }

    @objc func clearTapped(_ sender: UIButton) {
        currentAnswer.text = ""

        for btn in activatedButtons {
            btn.isHidden = false
        }

        activatedButtons.removeAll()

    }
    
    
    func loadLevel() {
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()

        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL) {
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()

                for (index, line) in lines.enumerated() {
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]

                    clueString += "\(index + 1). \(clue)\n"

                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)

                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }

        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        letterButtons.shuffle()
        if letterButtons.count == letterBits.count {
            for i in 0..<letterBits.count {
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
        
    }


}

