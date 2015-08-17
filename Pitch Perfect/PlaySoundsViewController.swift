//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Kent Huang on 8/15/15.
//  Copyright (c) 2015 Kent Huang. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordingAudio!
    var audioEngine: AVAudioEngine!
    var myAudioFile: AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if (receivedAudio != nil) {
            audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL, error: nil)
            audioPlayer.enableRate = true
            audioEngine = AVAudioEngine()
            myAudioFile = AVAudioFile(forReading: receivedAudio.filePathURL, error: nil)
        } else {
            println("path is empty")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playAudioAtRate(rate: Float) {
        stopAll()
        
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    func playAudioAtFreq(freq: Float) {
        stopAll()
        
        var pitchPlayer = AVAudioPlayerNode()
        var pitchShifter = AVAudioUnitTimePitch()
        
        pitchShifter.pitch = freq
        
        audioEngine.attachNode(pitchPlayer)
        audioEngine.attachNode(pitchShifter)
        
        audioEngine.connect(pitchPlayer, to: pitchShifter, format: myAudioFile.processingFormat)
        audioEngine.connect(pitchShifter, to: audioEngine.outputNode, format: myAudioFile.processingFormat)
        
        pitchPlayer.scheduleFile(myAudioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        pitchPlayer.play()
    }
    
    func stopAll() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    @IBAction func makeSlow(sender: UIButton) {
        playAudioAtRate(0.5)
    }

    @IBAction func makeFast(sender: UIButton) {
        playAudioAtRate(2.0)
    }
    
    @IBAction func makeChipmunk(sender: UIButton) {
        playAudioAtFreq(1000)
    }
    
    @IBAction func makeDarth(sender: UIButton) {
        playAudioAtFreq(-1000)
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        stopAll()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
