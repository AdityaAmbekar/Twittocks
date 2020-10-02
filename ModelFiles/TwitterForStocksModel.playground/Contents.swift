
import Cocoa
import CreateML

let data = try MLDataTable(contentsOf: URL(fileURLWithPath: "/Users/aditya/Desktop/Folder/IOS/TwitterForStocks/ModelFiles/twitter-sanders-apple3.csv"))

//Training on 70% data and randomizing with seed value 5 which yeilds max accuracy
let(trainingData, testingData) = data.randomSplit(by: 0.8, seed: 5)

//Using classifier on training data
let sentimentClassifier = try MLTextClassifier(trainingData: trainingData, textColumn: "text", labelColumn: "class")

//testing on Testing data
let evaluationMetrics = sentimentClassifier.evaluation(on: testingData, textColumn: "text", labelColumn: "class")

//Accuracy check
let evalAccuracy = (1 - evaluationMetrics.classificationError) * 100

//Metadata
let metadata = MLModelMetadata(author: "Aditya Ambekar",
                               shortDescription: "A model to classify whether the tweet is negative or positive",
                               license: nil,
                               version: "1.0.0")

//Creating the model
try sentimentClassifier.write(to: URL(fileURLWithPath: "/Users/aditya/Desktop/Folder/IOS/TwitterForStocks/ModelFiles/TweetSentimentClassifier.mlmodel"))



//checking if it is predicting right or not
//try sentimentClassifier.prediction(from: "@apple is good though")
