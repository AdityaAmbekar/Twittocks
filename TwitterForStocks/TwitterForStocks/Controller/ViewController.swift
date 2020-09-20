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

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    let sentimentClassifier = TweetSentimentClassifier()
    
    let swifter = Swifter(consumerKey: "30pHD6rGzNEXhsT2hrQlpEnT0",
                          consumerSecret: "aulZeYSP0YPyO1i3s9r3v5agOXzu5a4RLDVN3AHEsCEVVKgpmJ")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let prediction = try! sentimentClassifier.prediction(text: "@Apple is terrible company")
        
        print(prediction.label)
        
        swifter.searchTweet(using: "@Apple", lang: "en", count: 10, tweetMode: .extended, success: { (results, metadata) in
//            print(results)
        }) { (error) in
            print("Error with twitter api request :\(error)")
        }
    }
    
    @IBAction func predictPressed(_ sender: Any) {
        
        
    }
    
}

