//
//  SaveChoiceViewController.swift
//  TeamJesseAndAlex
//
//  Created by Brian Salisbury on 1/18/19.
//  Copyright © 2019 TOM Vanderbilt 2019. All rights reserved.
//

import UIKit
import AVFoundation

class SaveChoiceViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var dialogView: UIView!
    
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
    var currentSelection: [AnyHashable: Any]?
    
    var audioRecorder: AVAudioRecorder?

    
    override func viewDidLoad() {
        dialogView.layer.cornerRadius = 8
        NotificationCenter.default.addObserver(forName: Notification.Name("imageSelected"), object: nil, queue: .main){ notification in
            self.textField.becomeFirstResponder()
            self.currentSelection = notification.userInfo;
            self.view.superview?.alpha = 1
            self.imageView.image = notification.userInfo!["UIImagePickerControllerEditedImage"] as? UIImage
        }
        
        recordBtn.isEnabled = true
        stopBtn.isEnabled = false
        saveBtn.isEnabled = false
        
        let documentDirectory = UIApplication.shared.delegate?.dataManager.docsDir
        guard let soundFileURL = documentDirectory?.appendingPathComponent("sound.caf") else{
            return
        }
        
        let recordSettings = [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
                              AVEncoderBitRateKey: 16,
                              AVNumberOfChannelsKey: 2,
                              AVSampleRateKey: 44100.0] as [String : Any]
        
        let audioSession = AVAudioSession.sharedInstance()
        
        audioSession.perform(NSSelectorFromString("setCategory:error:"), with: AVAudioSession.Category.playAndRecord)
        do{
            try audioSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch let error as NSError{
            print("audioSession error: \(error.localizedDescription)")
        }
        
        do {
            try audioSession.setInputGain(1.0)
        } catch let error as NSError{
            print("audioSession error: \(error.localizedDescription)")
        }
//        do{
////            try audioSession.setCategory(AVAudioSession.Category.playAndRecord)
//            try audioSession.perform(NSSelectorFromString("setCategory:error:"), with: AVAudioSession.Category.playAndRecord)
//        }catch let error as NSError{
//            print("audioSession error: \(error.localizedDescription)")
//        }
        
        do{
            try audioRecorder = AVAudioRecorder(url: soundFileURL, settings: recordSettings as [String: AnyObject])
            audioRecorder?.prepareToRecord()
        }catch let error as NSError{
            print("audioSession error: \(error.localizedDescription)")
        }
    }
    
    @IBAction func record(_ sender: UIButton!) {
        if audioRecorder?.isRecording == false{
            recordBtn.isEnabled = false
            saveBtn.isEnabled = false
            stopBtn.isEnabled = true
            audioRecorder?.record()
        }
    }
    
    @IBAction func stopRecord(_ sender: UIButton!) {
        stopBtn.isEnabled = false
        saveBtn.isEnabled = true
        recordBtn.isEnabled = true
        
        audioRecorder?.stop()
    }
    
    @IBAction func save(sender: UIButton!){
        saveBtn.isEnabled = false
        self.textField.resignFirstResponder()
        UIView.animate(withDuration: 0.3){
            self.view.superview?.alpha = 0
        }
        
        UIView.animate(withDuration: 0.3, animations: { self.view.superview?.alpha = 0 }) {competion in
            self.textField.text = ""
        }
        

        var choice = currentSelection?["choice"] as? Choice
        choice?.name = textField.text
        
        let documentDirectory = UIApplication.shared.delegate?.dataManager.docsDir
        
        if let choiceId = choice?.id {
            choice?.audioRecordingName = "\(String(describing: choiceId)).caf"
            choice?.imageName = "\(String(describing: choiceId)).jpeg"
        }
        
        if let dataUrl = audioRecorder?.url{
            do {
                let data = try Data(contentsOf: dataUrl)
                if let fName = choice?.audioRecordingName, let url = documentDirectory?.appendingPathComponent(fName){
                    try data.write(to: url)
                }
            }catch let err {
                print("temp file isn't there :(")
            }
            
        }
        
        if let editedImage = currentSelection?["UIImagePickerControllerEditedImage"] as? UIImage{
            do {
                let data = editedImage.jpegData(compressionQuality: 1.0)
                if let fName = choice?.imageName, let url = documentDirectory?.appendingPathComponent(fName), let d = data{
                    try d.write(to: url)
                }
            }catch let err {
                print("temp file isn't there :(")
            }
            
        }
        
        
        
        if let c = choice{
            DataNotification.choiceConfigured(c: c).notify()
        }
        
    }
}
