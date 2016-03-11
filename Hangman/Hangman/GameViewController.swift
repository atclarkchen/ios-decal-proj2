//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UITextFieldDelegate {


    
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var wrongGuessLabel: UILabel!
    
    @IBOutlet weak var userGuessField: UITextField!
    

    
    var incorrectGuesses = ""
    var phrase = ""
    var phraseCount = 0
    var displayText = ""
    var mod_phrase = ""
    var mod_phraseCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.userGuessField.delegate = self;
        
        let hangmanPhrases = HangmanPhrases()
        phrase = hangmanPhrases.getRandomPhrase().lowercaseString
        print(phrase)

//        phrase = "words of love" //hardcode for now
        
        
        // display n length "_ _ _ ... " depending on phrase'
        phraseCount = phrase.characters.count
        displayText = ""
        
        
        var numLetters = 0
        
        print(String(phraseCount))
        
        for var i = 0; i < phraseCount; i+=1 {
            var end = i + 1
            var c = phrase.substringWithRange(Range<String.Index>(start: phrase.startIndex.advancedBy(i), end: phrase.startIndex.advancedBy(end)))
            
            if c == " " {
                displayText += "  "
                continue
            }
            numLetters += 1
            if i == phraseCount - 1 {
                displayText += "_"
            }
            else if i != 0 && i % 10 == 0 {
                displayText += "\n"
                displayText += "_ "
            }
            else {
                displayText += "_ "
            }
        }
        
        for var i = 0; i < phraseCount; i+=1 {
            var end = i + 1
            var c = phrase.substringWithRange(Range<String.Index>(start: phrase.startIndex.advancedBy(i), end: phrase.startIndex.advancedBy(end)))
            
            if c == " " {
                mod_phrase += "  "
                continue
            }
            numLetters += 1
            if i == phraseCount - 1 {
                mod_phrase += c
            }
            else if i != 0 && i % 10 == 0 {
                mod_phrase += "\n"
                mod_phrase = mod_phrase + c + " "
            }
            else {
                mod_phrase = mod_phrase + c + " "
            }
        }
        
        
        print("mod_phrase is: ")
        print(mod_phrase)
        print(String(mod_phrase.characters.count))
        
        mod_phraseCount = mod_phrase.characters.count
        
        print("displayText is: ")
        print(String(displayText))
        print(String(displayText.characters.count))
        
        displayLabel.text = displayText;
        
        
        
    }

//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        self.view.endEditing(true)
//        return false
//    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /** For when user types an INCORRECT guess.
     Each tap of this button will display the letter in the TextField as an Incorrect Guess on the same screen
     */
//    @IBAction func incorrectGuess(sender: AnyObject) {
//        // if phrase DOES NOT CONTAINS character in "userGuessField"
//        let userGuess = userGuessField.text?.lowercaseString.substringWithRange(Range<String.Index>(start: phrase.startIndex, end: phrase.startIndex.advancedBy(1)))
//
//        
//    }
    
    
    
    /** For when user types a CORRECT guess.
     Each tap of this button will remove an "_" from the puzzle label
    */
    @IBAction func correctGuess(sender: AnyObject) {
        let userGuess = userGuessField.text?.lowercaseString.substringWithRange(Range<String.Index>(start: phrase.startIndex, end: phrase.startIndex.advancedBy(1)))

//        print("userGuessChar is: ")
//        print(userGuessChar)

//        var end = i + 1
//        var c = phrase.substringWithRange(Range<String.Index>(start: phrase.startIndex.advancedBy(i), end: phrase.startIndex.advancedBy(end)))

        // user guess could be right
        if phrase.rangeOfString(userGuess!) != nil {
            //can only submit 1 LETTER
            
            let userGuessChar: Character = userGuess![(userGuess?.startIndex)!]
            print("right guess!")
            
            
            var displayChars = Array(displayText.characters)

            // if user_guess == phrase[i], then display[i] = user_guess
            // else: go onto phrase[i+1]
            // iterate through
            
            var mod_phraseChars = Array(mod_phrase.characters)
            
            for var i = 0; i < mod_phraseCount; i++ {
                if mod_phraseChars[i] == " " || mod_phraseChars[i] == "\n" {
                    continue
                }
                if mod_phraseChars[i] == userGuessChar {
                    displayChars[i] = userGuessChar
                }
            }
            
            displayText = String(displayChars)
            displayLabel.text = displayText
        } else {
            print("wrong guess!")
            if !incorrectGuesses.containsString(userGuess!) {
                incorrectGuesses = incorrectGuesses + userGuess! + " "
                wrongGuessLabel.text = incorrectGuesses
            }
        }
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
