//
//  QuestionResultsViewController.swift
//  Higher Maths Revision
//
//  Created by Sandra Houston on 02/08/2018.
//  Copyright © 2018 sandshouston. All rights reserved.
//

import UIKit

class QuestionResultsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    //passed in data
    var questsResults: [Results] = []
    
    @IBOutlet weak var testTitle: UILabel!
    @IBOutlet weak var resultView: UIView!
    
    @IBOutlet weak var testGradeLabel: UILabel!
    @IBOutlet weak var questionGradesCV: UICollectionView!
    
    //class variables
    var resultsTable = ResultsDBTable()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //calculate some numbers and update
        displayResults()
        
        //need this to display the cell contents
        self.questionGradesCV.delegate = self
        self.questionGradesCV.dataSource = self
        
        //update the table with the data
        resultsTable.openORCreateResultsTable()
        //add the results to the table
        updateResultsDB(resultList: questsResults)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK - Question Reults Collection View
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return questsResults.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = questionGradesCV.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath)
        // set label to text from array
        let resultCell = cell as! QuestionResultsCollectionViewCell
    
        //set the question number as 1 more than page index - as index starts at 0
        resultCell.questionNum.text = String(indexPath.row + 1)
        print("score is  \(questsResults[indexPath.row].score)" )
        let attempts = questsResults[indexPath.row].attempts
        if questsResults[indexPath.row].score > 49  {
            resultCell.gradeImageBtn.setTitle("✵", for: .normal)
            resultCell.gradeImageBtn.setTitleColor(UIColor.green, for: .normal)
            resultCell.layer.borderWidth = 0.8
            resultCell.layer.borderColor = UIColor.green.cgColor
            resultCell.questionScore.text = String(questsResults[indexPath.row].score)
        } else if attempts > 0 {
            resultCell.gradeImageBtn.setTitle("💥", for: .normal)
            resultCell.gradeImageBtn.setTitleColor(UIColor.purple, for: .normal)
            resultCell.layer.borderWidth = 0.8
            resultCell.layer.borderColor = UIColor.purple.cgColor
            resultCell.questionScore.text = String(questsResults[indexPath.row].score)
        } else  {
            resultCell.gradeImageBtn.setTitle("❓", for: .normal)
            resultCell.gradeImageBtn.setTitleColor(UIColor.yellow, for: .normal)
            resultCell.layer.borderWidth = 0.8
            resultCell.layer.borderColor = UIColor.yellow.cgColor
            resultCell.questionScore.text = String(questsResults[indexPath.row].score)
        }
        
        return resultCell
    }
    
    func displayResults() {
        
        testTitle.text = questsResults[0].testTitle
        let testAverage = calculateTotalScore()
        
        var correctAns: Int = 0
        for questions in questsResults {
            if questions.score > 50 {
                correctAns = correctAns + 1
            }
        }
        testGradeLabel.text = "Total score of " + String(testAverage) + "%" + " with " + String(correctAns) + " out of \(questsResults.count) correct"
        
    }
    
    
    //MARK: Total Score
    
    
    func calculateTotalScore() -> Int{
        
        var totalScore: Int = 0
        //add up all the scores
        for result in questsResults {
            totalScore = totalScore + result.score
            }
        //find the average score by dividing by how many questions were taken
        let averageScore = totalScore / questsResults.count
        
        return averageScore
    }
    func updateResultsDB(resultList: [Results]) {
        
        //just adding in results for now - need to add more info
        for result in resultList {
            resultsTable.addResult(newResult: result)
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
