//
//  ManageQuestionData.swift
//  Higher Maths Revision
//
//  Created by Sandra Houston on 11/07/2018.
//  Copyright © 2018 sandshouston. All rights reserved.
//

import Foundation

class ManageQuestionData {
    
    var algebraList = [Question]()
    var functionList = [Question]()
    var vectorList = [Question]()
    var trigList = [Question]()
    var errorList = [Question]()
    var diffnList = [Question]()
    var equationList = [Question]()
    var trigEqnList = [Question]()
    var integrationList = [Question]()
    var straightLineList = [Question]()
    var circleList = [Question]()
    var sequenceList = [Question]()
    var calculusList = [Question]()
//
//    enum questionTags {
//        case topic(String)
//        case tags([String])
//    }
    
    func createLists (questionList: [Question]) {
        
        for question in questionList {          //sort all questions into their area
            let areaType = question.topic.lowercased()
            switch areaType {
            case "alg" :
                algebraList.append(question)
            case "algebra":
                algebraList.append(question)
            case "fun":
                functionList.append(question)
            case "function":
                functionList.append(question)
            case "tri":
                trigList.append(question)
            case "trig id":
                trigList.append(question)
            case "vec":
                vectorList.append(question)
            case "vectors":
                vectorList.append(question)
            case "diff":
                diffnList.append(question)
            case "eqn":
                equationList.append(question)
            case "trig eqn":
                trigEqnList.append(question)
            case "int":
                integrationList.append(question)
            case "strl":
                straightLineList.append(question)
            case "cir":
                circleList.append(question)
            case "seq":
                sequenceList.append(question)
            case "calc":
                calculusList.append(question)
            default :
                print ("no Area set")
                errorList.append(question)
            }
        }
    }
    
    func getTopicsList (currentList: [Question]) -> ([[String]]) {
        //Want to get a unique list of topcis for display
        //And want to get a list of tags that can be searched
        var uniqueTopics: [String] = []
        var topicTags: [[String]] = []
        var questString: [String] = []
        
        print("getting topics")
        for question in currentList {
            let questTopic = question.title
            let questTags = question.tags
            //if the curent questions is the same add it to the list
            if !(uniqueTopics.contains(questTopic)) {
                //add the topic to the unique topics
                uniqueTopics.append(questTopic)
                //add the title to the first element of the array
                questString.append(questTopic)
                for tag in questTags {
                    //add the tags to the array
                    questString.append(tag)
                }
                //now add the array to the collection
                topicTags.append(questString)
                //empty this array so we start again
                questString.removeAll(keepingCapacity: true)
            }
        }
        return topicTags
    }
    
    func getCurrentList(areaName: String, questionList: [Question]) -> [Question] {
        
        var currentList = [Question]()
        print ("current area is \(areaName)")
        switch areaName {
        case "Algebra":
            currentList = algebraList
        case "Trig Expressions":
            currentList = trigList
        case "Functions":
            currentList = functionList
        case "Vectors":
            currentList = vectorList
            print("setting vectors")
        case "Equations":
            currentList = equationList
        case "Differentiation":
            currentList = diffnList
        case "Trig Equations":
            currentList = trigEqnList
        case "Integration":
            currentList = integrationList
        case "Straight Lines":
            currentList = straightLineList
        case "Circles":
            currentList = circleList
        case "Sequences":
            currentList = sequenceList
        case "Calculus":
            currentList = calculusList
        default:      //let this be for revision ? get all questions ?? atm - but want only that area
            currentList = questionList
            print ("setting default")
        }
      return currentList
    }
    func getUnitRevisionQuestions(unitName:String, QuestionList: [Question])-> [Question] {
        
        var revisionQuestions: [Question] = []
        
        switch unitName {
        case "Unit 1":
            revisionQuestions.append(contentsOf: algebraList)
            revisionQuestions.append(contentsOf: trigList)
            revisionQuestions.append(contentsOf: functionList)
            revisionQuestions.append(contentsOf: vectorList)
        case "Unit 2":
            revisionQuestions.append(contentsOf: diffnList)
            revisionQuestions.append(contentsOf: trigEqnList)
            revisionQuestions.append(contentsOf: equationList)
            revisionQuestions.append(contentsOf: integrationList)
        case "Unit 3":
            revisionQuestions.append(contentsOf: straightLineList)
            revisionQuestions.append(contentsOf: circleList)
            revisionQuestions.append(contentsOf: sequenceList)
            revisionQuestions.append(contentsOf: calculusList)
        default:
            //return all questions
            revisionQuestions = QuestionList
        }
        print ("Number of revision questions \(revisionQuestions.count)")
        return revisionQuestions
    }
    func randomiseQuestions(questionsIn: [Question]) -> [Question]{
    
        var randNum: Int
        var newOrderAry: [Question] = []
        var questSeq: [Int] = []
        print("in random")
        //my second version of randomising - setting array in opposite way
        for _ in 0..<questionsIn.count {
            //get a random number up to the number of questions we have
            randNum = Int(arc4random_uniform(UInt32(questionsIn.count)))
            // check if we've used this number before
            while questSeq.contains(randNum) {
                //get another number if it's used
                randNum = Int(arc4random_uniform(UInt32(questionsIn.count)))
            }
            //set our next question in sequence to a random question
            newOrderAry.append(questionsIn[randNum])
            //add this number to our sequence so we know it's used
            questSeq.append(randNum)
        }
        //return a new question array of random questions
        //not limiting questions returned so we can use this list to get a new question if needed
        return newOrderAry
        
    }
}
