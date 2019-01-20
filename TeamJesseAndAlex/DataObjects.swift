//
//  DataObjects.swift
//  TeamJesseAndAlex
//
//  Created by Brian Salisbury on 1/20/19.
//  Copyright © 2019 TOM Vanderbilt 2019. All rights reserved.
//

import Foundation

struct Board: Codable {
    
    var id: UUID
    var name: String?
    var choices: [Choice]
    
    var numberOfChoices: Int {
        return choices.count
    }
    
    init() {
        self.id = UUID()
        choices = []
    }
}

struct Choice: Codable{
    
    var id: UUID
    var name: String?
    var imageName: String?
    var audioRecordingName: String?
    
    init() {
        self.id = UUID()
    }
}
