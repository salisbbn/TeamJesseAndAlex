//
//  MainViewController.swift
//  TeamJesseAndAlex
//
//  Created by Brian Salisbury on 1/18/19.
//  Copyright © 2019 TOM Vanderbilt 2019. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var twoChoicesBtn: UIButton!
    @IBOutlet weak var threeChoicesBtn: UIButton!
    @IBOutlet weak var fourChoicesBtn: UIButton!
    
    @IBOutlet weak var savedBoardBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let appleBlue = UIColor.init(red: 47.0/255, green: 124.0/255, blue: 246.0/255, alpha: 1.0).cgColor;
        
        twoChoicesBtn.layer.borderColor = appleBlue
        twoChoicesBtn.layer.borderWidth = 1.0
        twoChoicesBtn.layer.cornerRadius = 8.0
        
        threeChoicesBtn.layer.borderColor = appleBlue
        threeChoicesBtn.layer.borderWidth = 1.0
        threeChoicesBtn.layer.cornerRadius = 8.0
        
        fourChoicesBtn.layer.borderColor = appleBlue
        fourChoicesBtn.layer.borderWidth = 1.0
        fourChoicesBtn.layer.cornerRadius = 8.0
        
        savedBoardBtn.layer.borderColor = appleBlue
        savedBoardBtn.layer.borderWidth = 1.0
        savedBoardBtn.layer.cornerRadius = 8.0
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MultipleChoiceViewController{
            if segue.identifier == "three"{
                destination.numberOfDesiredChoices = 3
            }else if segue.identifier == "four"{
                destination.numberOfDesiredChoices = 4
            }else {
                destination.numberOfDesiredChoices = 2
            }
        }
    }
    
    
}

