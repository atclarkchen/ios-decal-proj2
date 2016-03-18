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
    
    @IBOutlet weak var gameImage: UIImageView!

    
    var alert = UIAlertController(title: "Alert", message: "message", preferredStyle: UIAlertControllerStyle.Alert)

    
    var incorrectGuesses = ""
    var phrase = ""
    var phraseCount = 0 //num characters of phrase including spaces
    var displayText = ""
    var mod_phrase = ""
    var mod_phraseCount = 0
    var numCorrect = 0
    var numWrong = 0
    var numPhraseChars = 0 // num characters of phrase WITHOUT spaces
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        alert = UIAlertController(title: "Alert", message: "message", preferredStyle: UIAlertControllerStyle.Alert)
        
        self.userGuessField.delegate = self;
        
        let hangmanPhrases = HangmanPhrases()
        phrase = hangmanPhrases.getRandomPhrase().lowercaseString
        phrase = "abbc"
        print(phrase)
        var spacelessPhrase = phrase.stringByReplacingOccurrencesOfString(" ", withString: "")
        numPhraseChars = spacelessPhrase.characters.count
        print("number of characters in spaceless phrase")
        print(String(numPhraseChars))

//        phrase = "words of love" //hardcode for now
        
        
        // display n length "_ _ _ ... " depending on phrase'
        phraseCount = phrase.characters.count
        displayText = ""
        
        
        var numLetters = 0
        

        
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
        
        // display gameImage: default is hangman1.gif
        gameImage.image = UIImage(named: "hangman1.gif")
        
        
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

        // if user submitted more than 1 letter, alert
        if userGuess?.characters.count != 1 || userGuess?.characters.count == 0 {
            // show UIAlert
            print("user tried to submit 0 or more than 1 letter!")
            return
        }

        // user guessed correctly
        if phrase.rangeOfString(userGuess!) != nil {
            
            
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
                if mod_phraseChars[i] == userGuessChar { // user guesses correctly, updating display
                    displayChars[i] = userGuessChar
                    numCorrect += 1
                }
            }
            
            displayText = String(displayChars)
            displayLabel.text = displayText
            //check game state
//            if checkGameState() {
//                print ("Game ended!")
//                return
//            }
            
        } else {
            print("wrong guess!")
            if !incorrectGuesses.containsString(userGuess!) {
                incorrectGuesses = incorrectGuesses + userGuess! + " "
                wrongGuessLabel.text = incorrectGuesses
                numWrong += 1
                
                //display Image depending on how many incorrect guesses
                
                
                
            }
        }
        if checkGameState() {
            print ("Game ended!")
            return
        }
        
    }
    
    // return true for end game. False for keep going.
    func checkGameState() -> Bool {
        //Check for win
        if numCorrect == numPhraseChars {

            alert.addAction(UIAlertAction(title: "You won!", style: UIAlertActionStyle.Default, handler: nil))
            alert.message = "You should feel good about yourself."
            self.presentViewController(alert, animated: true, completion: nil)


            
            
            
            print("you win!")
            return true
        }
        
        switch numWrong {
            case 1 :
                gameImage.image = UIImage(named: "hangman2.gif")
            case 2 :
                gameImage.image = UIImage(named: "hangman3.gif")
            case 3 :
                gameImage.image = UIImage(named: "hangman4.gif")
            case 4 :
                gameImage.image = UIImage(named: "hangman5.gif")
            case 5 :
                gameImage.image = UIImage(named: "hangman6.gif")
            case 6:
                gameImage.image = UIImage(named: "hangman7.gif")
            default:
                break
        }
        
        
        if numWrong == 6 {
            
            alert.addAction(UIAlertAction(title: "You lost!", style: UIAlertActionStyle.Default, handler: nil))
            alert.message = "Don't be down. This happens. Rarely."
            self.presentViewController(alert, animated: true, completion: nil)
            
            print("You've lost the game")
            return true
        }
        
        return false
    }
    
    
    @IBAction func startOver(sender: AnyObject) {
        incorrectGuesses = ""
        phrase = ""
        phraseCount = 0 //num characters of phrase including spaces
        displayText = ""
        mod_phrase = ""
        mod_phraseCount = 0
        numCorrect = 0
        numWrong = 0
        numPhraseChars = 0 // num characters of phrase WITHOUT spaces
        
//        @IBOutlet weak var displayLabel: UILabel!
//        @IBOutlet weak var wrongGuessLabel: UILabel!
//        
//        @IBOutlet weak var userGuessField: UITextField!
//        
//        @IBOutlet weak var gameImage: UIImageView!
        
        self.viewDidLoad()
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
