//
//  AudioClassifier.swift
//  AudioML
//
//  Created by paritosh on 15/04/20.
//  Copyright © 2020 paritosh. All rights reserved.
//

import Foundation
import AVFoundation
import SoundAnalysis
class AudioClassifier : NSObject, SNResultsObserving{
    private let model : MLModel
    private var answer: String = ""
    private let request: SNClassifySoundRequest
    private var completion : (String?)->() = { _ in }
    init?(model: MLModel){
        guard let request = try? SNClassifySoundRequest(mlModel: model) else{
            return nil
        }
        self.model = model
        self.request = request
    }
    func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let results = result as? SNClassificationResult, let result = results.classifications.first
            else{return}
        answer = result.identifier
        
    }
    func requestDidComplete(_ request: SNRequest) {
      
        
        
        
        self.completion(answer)
    }
    func classify(audioFile: URL, completion: @escaping (String?)-> Void){
        self.completion = completion
        guard let analyzer = try? SNAudioFileAnalyzer(url: audioFile), let _ = try? analyzer.add(self.request, withObserver: self)else{
            return
        }
        analyzer.analyze()
    }
}
