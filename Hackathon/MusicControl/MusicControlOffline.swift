//
//  MusicControlOffline.swift
//  Hackathon
//
//  Created by Vũ Kiên on 15/11/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import Foundation
import AVFoundation

class MusicControlOffline: MusicControl {
    var playAudio: AVAudioPlayer?
    override var duration: Double {
        guard let playAudio = self.playAudio else {
            return 0.0
        }
        
        return playAudio.duration
    }
    
    override var currentTime: Double {
        guard let playAudio = self.playAudio else {
            return 0.0
        }
        
        return playAudio.currentTime
    }
    
    override var isOnline: Bool {
        get {
            return false
        }
    }
    
    override var rate: Bool {
        guard let playAudio = self.playAudio else {
            return false
        }
        return playAudio.isPlaying
    }
    
    override init(song: Song) {
        super.init(song: song)
        guard let data = song.source?.sourceSong else {
            return
        }
        do {
            self.playAudio = try AVAudioPlayer(data: data)
        } catch {
            print("error: \(error.localizedDescription)")
        }
        
        
    }
    
    override func play(duration: Double? = nil, completed: (_ isSeek: Bool) -> Void, error: (() -> Void)? = nil) {
        guard let playAudio = playAudio else {
            error?()
            return
        }
        guard let duration = duration else {
            playAudio.play()
            completed(false)
            return
        }
        
        playAudio.pause()
        playAudio.currentTime = duration
        playAudio.play()
        completed(true)
    }
    
    override func pause(completed: ((_ isPause: Bool) -> Void)? = nil) {
        if self.playAudio!.isPlaying {
            playAudio?.pause()
            completed?(true)
        } else {
            self.playAudio!.play()
            completed?(false)
        }
        
    }
    
    override func stop(completed: (() -> Void)? = nil) {
        self.playAudio?.stop()
        completed?()
    }
    
    override func foward(count: Int = 2) {
        
    }
    
    override func rewind(count: Int = 2) {
        
    }
    
    override func repeatSong(isRepeat: Bool) {
        if isRepeat {
            playAudio?.numberOfLoops = -1
        } else {
            playAudio?.numberOfLoops = 0
        }
    }
}
