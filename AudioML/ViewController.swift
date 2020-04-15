//
//  ViewController.swift
//  AudioML
//
//  Created by paritosh on 15/04/20.
//  Copyright © 2020 paritosh. All rights reserved.
//

import UIKit
import AVKit
import SoundAnalysis
import CoreML
class ViewController: UIViewController {
    var audioClassifier = AudioClassifier(model:AnimalSoundClassifier_1().model)
    private var audioRecoder = AudioRecorder()
    private var recording: Bool = false
    private var allowed: Bool = false
    private var classification: String = ""
    private var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return (paths.first!)
    }
    @IBOutlet weak var resultLabel: UILabel!
    private var audioFilePath: URL {
        print(documentsDirectory.appendingPathComponent("recordedAudio.m4a"))
        return documentsDirectory.appendingPathComponent("recordedAudio.m4a")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.audioRecoder.requestPermission { (allowed) in
                       DispatchQueue.main.async {
                           print(allowed)
                        self.allowed = allowed
                        
            }
        // Do any additional setup after loading the view.
        }
        
    }
    @IBAction func validateButton(_ sender: UIButton) {

        self.audioClassifier?.classify(audioFile: self.audioFilePath) { result in
            if let result = result {
                self.classification = result
                self.resultLabel.text = self.classification
            }
        }
         
    }
    
    @IBAction func recordButton(_ sender: UIButton) {
        if(self.recording)
        {
            sender.backgroundColor = UIColor.green
        }
        else
        {
            sender.backgroundColor = UIColor.red
        }
        self.recording = !self.recording
        if self.recording {
            audioRecoder.startRecording(fileURL: self.audioFilePath)
            
        } else {
            audioRecoder.stopRecording()
        }
    }
    
}

