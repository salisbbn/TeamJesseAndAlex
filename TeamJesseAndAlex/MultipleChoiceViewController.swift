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
    
    @IBOutlet weak var saveBoardButton: UIBarButtonItem?
    var board: Board?
    var saveDisabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if saveDisabled {
            self.navigationItem.rightBarButtonItem = nil;            
        }
        
        
        NotificationCenter.default.addObserver(forName: Notification.Name("choiceConfigured"), object: nil, queue: .main){ notification in
            let choice = notification.userInfo?["choice"] as! Choice
            self.board?.choices.append(choice);
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name("disableYoruself"), object: nil, queue: .main){ notification in
            self.saveBoardButton?.isEnabled = true
        }
        
        if self.board == nil {
            board = Board()
        }
        
        var numChoices = 0
        numChoices = board?.choices.count != 0 ? board?.choices.count ?? 0 : numberOfDesiredChoices
        
        for index in 0..<numChoices {
            let choiceVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "choiceViewController") as! ChoiceViewController
            self.addChild(choiceVC)
            stackView.addArrangedSubview(choiceVC.view)
            
            if index < board?.choices.count ?? 0, let c = board?.choices[index]{
                choiceVC.choice = c
                NotificationCenter.default.post(name: Notification.Name("choiceConfigured"), object: nil, userInfo: ["choice": choiceVC.choice])
            }
        }
        
    }
    
    @IBAction func save(_ sender: Any) {
        
        let alert = UIAlertController(title: "Name this board:", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil);
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
            if self.board != nil{
                self.board!.name = alert.textFields?[0].text
                UIApplication.shared.delegate?.dataManager.writeToDisk(b: self.board!)
                self.saveBoardButton?.isEnabled = false
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
        
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
