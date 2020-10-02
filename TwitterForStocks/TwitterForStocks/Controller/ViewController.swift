//
//  ViewController.swift
//  TwitterForStocks
//
//  Created by Aditya Ambekar on 18/09/20.
//  Copyright © 2020 Radioactive Apps. All rights reserved.
//

import UIKit
import CoreML
import SwifteriOS
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    let sentimentClassifier = TweetSentimentClassifier()
    
    let swifter = Swifter(consumerKey: "30pHD6rGzNEXhsT2hrQlpEnT0",
                          consumerSecret: "aulZeYSP0YPyO1i3s9r3v5agOXzu5a4RLDVN3AHEsCEVVKgpmJ")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///        checking if ml model is integrated or not
        
        //        let prediction = try! sentimentClassifier.prediction(text: "@Apple is terrible company")
        //        print(prediction.label)
        
        
    }
    
    @IBAction func predictPressed(_ sender: Any) {
        
        if let searchText = textField.text {
            
            /// Calling twitter api and getting the recent 100 tweets
            swifter.searchTweet(using: searchText, lang: "en", count: 100, tweetMode: .extended, success: {[weak self] (results, metadata) in
                
                //print(results)
                guard let strongSelf = self else {
                    return
                }
                
                var tweets = [TweetSentimentClassifierInput]()
                
                for i in 0..<100 {
                    if let fullTextOfTweet = results[i]["full_text"].string {
                        let tweet = TweetSentimentClassifierInput(text: fullTextOfTweet)
                        tweets.append(tweet)
                    }
                }
                
                //Making prediction
                do {
                    let predictions = try strongSelf.sentimentClassifier.predictions(inputs: tweets)
                    var sentimentScore = 0.0
                    
                    for prediction in predictions {
                        
                        let sentiment = prediction.label
                        
                        if sentiment == "Pos" {
                            sentimentScore += 1.0
                        }
                        else if sentiment == "Neutral" {
                            sentimentScore += 0.5
                        }
                        else if sentiment == "Neg" {
                            sentimentScore -= 1.0
                        }
                    }
                    
                    strongSelf.setSentimentLabel(sentimentScore: sentimentScore)
                    
                }
                catch {
                    print("There was an error in prediction ...")
                }
                
                
            }) { (error) in
                print("Error with twitter api request :\(error)")
            }
            
        }
    }
    
    public func setSentimentLabel(sentimentScore: Double) {
        
        print(sentimentScore)
        if sentimentScore > 40 {
            sentimentLabel.text = "😍"
        }
        else if sentimentScore > 20 {
            sentimentLabel.text = "😊"
        }
        else if sentimentScore > 10 {
            sentimentLabel.text = "🙂"
        }
        else if sentimentScore >= 0 {
            sentimentLabel.text = "😐"
        }
        else if sentimentScore > -10 {
        sentimentLabel.text = "😕"
        }
        else if sentimentScore > -20 {
            sentimentLabel.text = "😡"
        }
        else {
            sentimentLabel.text = "🤮"
        }
        
    }
}



