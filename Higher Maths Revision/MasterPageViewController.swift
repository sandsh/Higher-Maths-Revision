//
//  MasterQsViewController.swift
//  Higher Maths Revision
//
//  Created by Sandra Houston on 09/07/2018.
//  Copyright © 2018 sandshouston. All rights reserved.
//

import UIKit

class MasterPageViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    //passed in variables
    var questionsList: [Question] = []      //all that particular area questions passed in
    var titleName: String = "Practice"      //the topic that was selected and passed in
    var testType: String!                   //Is this practice or test - hide certain buttons for test - but allow the formulae
    
    var pageControl = UIPageControl()             //to display the dots with this
    var pageViewController:UIPageViewController!  //to let this know it is a pageView
    
    //class variables
    let manageData = ManageQuestionData()
    var randomOrderQuestions: [Question] = []       //holds the randomised list of fall
    var currentQuestions: [Question] = []           //the currentQuestions we are going to display
    var childViews: [UIViewController] = []         //the array that contains the instances of the child viewControllers
    
    var resultsData = ResultsDBTable()              //set up  the results table
    var questionResults: [Results] = []             //holds the results of each question passed on
    
    //Setup the page controls
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = titleName

        //find only the questions on the topic selected - as we pass in all area questions
        //test questions will have already been organised 
        if testType == "Test" || testType == "Revision" {
            currentQuestions = questionsList
        } else {
            //get the topic
            for loop in 0..<questionsList.count {
                if titleName == questionsList[loop].title {
                    // if we find this type of question lets take note of its index
                    currentQuestions.append(questionsList[loop])
                }
            }
        }
        
        
        //Get a new randomised array of the questions
        randomOrderQuestions = manageData.randomiseQuestions(questionsIn: currentQuestions)
        
        self.pageViewController = (self.storyboard?.instantiateViewController(withIdentifier: "MasterPageViewController"))! as! UIPageViewController
        
        //each page is its own delegate and datasource
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        print("still in master")
        //set up the first instance of the page
        let initialContentVC = self.questionPageAtIndex(index: 0)
        childViews =  [initialContentVC]
        self.pageViewController.setViewControllers(childViews as [UIViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        
        //set up parent child relationship
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMove(toParentViewController: self)

        
        //call to set up the display for the dots on the screen
        configurePageControl()
    }
    
    
    //this gets an instance of the QuestionpageVC, sets up and sends data
    func questionPageAtIndex(index: Int ) -> QuestionViewController {
        let pageContentVC: QuestionViewController
        
        //Only create a new instance if it has not been done before
        if childViews.count <= index {
            pageContentVC = self.storyboard?.instantiateViewController(withIdentifier: "QuestionViewController") as! QuestionViewController
            childViews.append(pageContentVC)       //store this instance
        } else { //get the instance stored
            pageContentVC = childViews[index] as! QuestionViewController
        }
        
        
        //set up the results to pass in to each question - has to be set up here so it can be passed along each time
        
//        if testType == "Test"  {
            pageContentVC.titleName = titleName
//        }
//        else {
//            pageContentVC.titleName = titleName
//        }
        pageContentVC.pageIndex = index
        print("on pageIndex \(index)")
        pageContentVC.testType = testType
        
        pageContentVC.questionList = randomOrderQuestions
        
        //limit it to 12 questions - could amend this to user choice later
        if randomOrderQuestions.count > 12 {
            pageContentVC.numberOfQuestions = 12
        } else {
            pageContentVC.numberOfQuestions = randomOrderQuestions.count
        }
        
        //set up results array - need to pass it in
        pageContentVC.resultsH = { result in
                        print("passed back \(result)")
        // only updated depending on attempts - 0 before any attempts
            if result.attempts == 0 {
                self.questionResults.append(result)
            } else {
                //only update the score and number of attempts
                print("attempts and scrore \(result.attempts) \(result.score)")
                self.questionResults[index].attempts = result.attempts
                self.questionResults[index].score = result.score
            }
            //
            return self.questionResults
        }

        return pageContentVC
    }
    
    // controls the previous page view
   func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let viewController = viewController as! QuestionViewController
        
        var index = viewController.pageIndex as Int
        if (index == 0 || index == NSNotFound) {
            return nil
        }
        index -= 1
        
        return self.questionPageAtIndex(index: index)
        
    }
    //controls the next page view
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let viewController = viewController as! QuestionViewController
        var index = viewController.pageIndex as Int
        
        if  index == NSNotFound {
            return nil
        }
        index += 1
        //check if we haave reached end of questions - or the limit of 12
        if (index == 12 || index == randomOrderQuestions.count){ //maximum number of questions
            return nil
        }
        return self.questionPageAtIndex(index: index)
        
    }
    
    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 70,width: UIScreen.main.bounds.width,height: 40))
        if randomOrderQuestions.count > 12 {
            pageControl.numberOfPages = 12
        } else {
            pageControl.numberOfPages = randomOrderQuestions.count    //not viewControllers.count as this only gives one dot 
        }
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = true
        pageControl.tintColor = UIColor.lightGray
        pageControl.pageIndicatorTintColor = UIColor.blue
        pageControl.currentPageIndicatorTintColor = UIColor.red
        view.addSubview(pageControl)
        view.bringSubview(toFront: pageControl)        //need to make sure dots appeared on top of view
    }
//
    // makes the dots colour transition with each question
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        pageControl.currentPage = childViews.index(of: pageContentViewController)!
    }
    
    //need to set up a blank array that can be passed and updated between the pages
    func setUpBlankArray(numQuestions: Int) -> [Results] {
        
        var resultsAry: [Results] = []
        print ("set up blank")
        //only set up for the number of questions - that starts at 1
        for _ in 0..<numQuestions {
            //initialise array with instances of results - blank initialise
            resultsAry.append(Results())
            print("create a blank one")
        }
        return resultsAry
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}



