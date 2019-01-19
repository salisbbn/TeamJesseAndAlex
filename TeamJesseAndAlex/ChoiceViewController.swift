//
//  ChoiceViewController.swift
//  TeamJesseAndAlex
//
//  Created by Brian Salisbury on 1/18/19.
//  Copyright © 2019 TOM Vanderbilt 2019. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class ChoiceViewController: UIViewController, UINavigationControllerDelegate,  UIImagePickerControllerDelegate, AVAudioPlayerDelegate {
    
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraView: UIImageView!
    @IBOutlet weak var textLb: UILabel!
    
    var tag: Int?
    var soundURL: URL?
    var audioPlayer: AVAudioPlayer?
    
    
    override func viewDidLoad() {
        self.navigationItem.title = "Create Choices"
        checkPermission()
        
        NotificationCenter.default.addObserver(forName: Notification.Name("readyForSelection"), object: nil, queue: .main){ notification in
            let info = notification.userInfo?["info"] as! (String, String, Any, Int, URL)
            if info.3 == self.tag{
                self.cameraView.isHidden = true
                self.textLb.isHidden = false
                self.textLb.text = info.1.uppercased()
                
                self.selectButton.removeTarget(self, action: #selector(self.selectImage(sender:)), for: .touchUpInside)
                self.selectButton.addTarget(self, action: #selector(self.selectChoice), for: .touchUpInside)
                
                do{
                    try self.audioPlayer = AVAudioPlayer(contentsOf: (info.4))
                    self.audioPlayer!.delegate = self
                    self.audioPlayer!.prepareToPlay()
                }catch let error as NSError{
                    print("audioPlayer error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    var imagePicker = UIImagePickerController()
    @IBAction func selectImage(sender: UIButton){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func selectChoice(sender: UIButton){
        //self.parent?.performSegue(withIdentifier: "choice", sender: nil)
        self.selectButton.layer.borderColor = UIColor.green.cgColor
        self.selectButton.layer.borderWidth = 20
        
        self.audioPlayer!.play()
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var mutableInfo = info;
        self.dismiss(animated: true, completion: { () -> Void in
            
        })
        mutableInfo["selection"] = self.tag!
        let notification = NotificationCenter.default.post(name: Notification.Name("imageSelected"), object: nil, userInfo: mutableInfo)
        imageView.image = info["UIImagePickerControllerOriginalImage"] as? UIImage
    }
    
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        }
    }


}
