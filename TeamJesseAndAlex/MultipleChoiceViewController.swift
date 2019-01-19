//
//  MultipleChoiceViewController.swift
//  TeamJesseAndAlex
//
//  Created by Brian Salisbury on 1/18/19.
//  Copyright © 2019 TOM Vanderbilt 2019. All rights reserved.
//

import UIKit

class MultipleChoiceViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var saveContainer: UIView!
    
    var numberOfDesiredChoices = 2
    
    var board: Board?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        board = Board()
        
        for index in 0..<numberOfDesiredChoices {
            let choiceVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "choiceViewController") as! ChoiceViewController
            choiceVC.tag = index
            self.addChild(choiceVC)
            stackView.addArrangedSubview(choiceVC.view)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
