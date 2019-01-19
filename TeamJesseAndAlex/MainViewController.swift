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
    @IBOutlet weak var imageLibraryBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let appleGrey = UIColor.init(red: 74.0/255, green: 74.0/255, blue: 74.0/255, alpha: 1.0).cgColor;
        
        twoChoicesBtn.layer.borderColor = appleGrey
        twoChoicesBtn.layer.borderWidth = 1.0
        twoChoicesBtn.layer.cornerRadius = 8.0
        
        threeChoicesBtn.layer.borderColor = appleGrey
        threeChoicesBtn.layer.borderWidth = 1.0
        threeChoicesBtn.layer.cornerRadius = 8.0
        
        fourChoicesBtn.layer.borderColor = appleGrey
        fourChoicesBtn.layer.borderWidth = 1.0
        fourChoicesBtn.layer.cornerRadius = 8.0
        
        savedBoardBtn.layer.borderColor = appleGrey
        savedBoardBtn.layer.borderWidth = 1.0
        savedBoardBtn.layer.cornerRadius = 8.0
        
        imageLibraryBtn.layer.borderColor = appleGrey
        imageLibraryBtn.layer.borderWidth = 1.0
        imageLibraryBtn.layer.cornerRadius = 8.0
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MultipleChoiceViewController{
            if segue.identifier == "three"{
                destination.numberOfChoices = 3
            }else if segue.identifier == "four"{
                destination.numberOfChoices = 4
            }else {
                destination.numberOfChoices = 2
            }
        }
    }
    
    
}

