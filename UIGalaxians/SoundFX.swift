//
//  SoundFX.swift
//  UIViewInvaders
//
//  Created by Jonathan French on 26/02/2019.
//  Copyright © 2019 Jaypeeff. All rights reserved.
//
//Audio Stuff
//Set up as much to start with and play sounds on a new thread using a seperate audioplayer
//to allow different sounds to be played simultaniously
//You'll probably want to turn the sound off after a bit.....


import Foundation
import AVFoundation

final class SoundFX {
    
    var hitAudioPlayer: AVAudioPlayer?
    var shootAudioPlayer: AVAudioPlayer?
    var startAudioPlayer: AVAudioPlayer?
    var baseAudioPlayer: AVAudioPlayer?
    var invaderAudioPlayer: AVAudioPlayer?
    //var observe:obser
    lazy var shooturl = Bundle.main.url(forResource: "Galaxian_Fire", withExtension: "wav")
    lazy var starturl = Bundle.main.url(forResource: "Galaxian_Start", withExtension: "wav")
    lazy var killurl = Bundle.main.url(forResource: "Galaxian_Hit", withExtension: "wav")
    lazy var explosionurl = Bundle.main.url(forResource: "explosion", withExtension: "wav")
    lazy var ufourl = Bundle.main.url(forResource: "ufo_highpitch", withExtension: "wav")
    lazy var invurl = Bundle.main.url(forResource: "Galaxian_Background", withExtension: "wav")
    
    init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            shootAudioPlayer = try AVAudioPlayer(contentsOf: shooturl!, fileTypeHint: AVFileType.wav.rawValue)
            hitAudioPlayer = try AVAudioPlayer(contentsOf: killurl!, fileTypeHint: AVFileType.wav.rawValue)
            baseAudioPlayer = try AVAudioPlayer(contentsOf: explosionurl!, fileTypeHint: AVFileType.wav.rawValue)
            startAudioPlayer = try AVAudioPlayer(contentsOf: starturl!, fileTypeHint: AVFileType.wav.rawValue)
            invaderAudioPlayer = try AVAudioPlayer(contentsOf: invurl!, fileTypeHint: AVFileType.wav.rawValue)
            //NotificationCenter.default.addObserver(self, selector: #selector(self.finishedPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: invaderAudioPlayer)
        } catch let error {
            print(error.localizedDescription)
        }
    }

    @objc func play(audioPlayer:AVAudioPlayer){
        audioPlayer.play()
    }
    
    func shootSound(){
        guard let shootAudioPlayer = shootAudioPlayer else { return }
        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: shootAudioPlayer)
    }
    
    func hitSound() {
        guard let hitAudioPlayer = hitAudioPlayer else { return }
        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: hitAudioPlayer)
    }
    
    func baseHitSound() {
        guard let baseAudioPlayer = baseAudioPlayer else { return }
        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: baseAudioPlayer)
    }
    
    func startSound()
    {
        guard let startAudioPlayer = startAudioPlayer else { return }
        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: startAudioPlayer)
    }
    
    func invaderSound()
    {
        guard let invaderAudioPlayer = invaderAudioPlayer else { return }
        Thread.detachNewThreadSelector(#selector(play), toTarget: self, with: invaderAudioPlayer)
    }
    
    
    @objc func finishedPlaying( _ myNotification:NSNotification) {
        invaderSound()
    }
}
