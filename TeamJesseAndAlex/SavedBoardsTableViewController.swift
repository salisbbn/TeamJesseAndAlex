//
//  SavedBoardsTableViewController.swift
//  TeamJesseAndAlex
//
//  Created by Brian Salisbury on 1/19/19.
//  Copyright © 2019 TOM Vanderbilt 2019. All rights reserved.
//

import UIKit

class SavedBoardsTableViewController: UITableViewController {

    var boards: [Board]?
    
    @IBOutlet weak var editBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.boards = UIApplication.shared.delegate?.dataManager.readFromDisk()
        
        editBtn.isEnabled = true
        self.tableView.isEditing = false
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let b = self.boards {
            return b.count
        }
        
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        
        if let board = self.boards?[indexPath.row]{
            if let name = board.name{
                cell.textLabel?.text = name
            }else{
                cell.textLabel?.text = board.id.uuidString
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let board = boards?[indexPath.row]{
            self.performSegue(withIdentifier: "choices", sender: board)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as! MultipleChoiceViewController).board = sender as? Board
        (segue.destination as! MultipleChoiceViewController).saveDisabled = true
    }
    
    @IBAction func deleteBoards(_ sender: Any) {
        self.tableView.isEditing = !self.tableView.isEditing
        if self.tableView.isEditing {
            self.navigationItem.rightBarButtonItem?.title = "Done"
        }else{
            self.navigationItem.rightBarButtonItem?.title = "Edit"
        }
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
    
            //get the board
            let board = self.boards?[indexPath.row]
            
            //delete board from disk
            (UIApplication.shared.delegate as! AppDelegate).dataManager.deleteFromDisk(b: board!)
            self.boards = UIApplication.shared.delegate?.dataManager.readFromDisk()
            
            //reload the table view
            self.tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .left)
            
        }
    }

}
