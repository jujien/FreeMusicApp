//
//  MusicControl.swift
//  Hackathon
//
//  Created by Vũ Kiên on 5/11/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import Foundation
import MediaPlayer

class MusicControl {
    var song: Song
    var duration: Double {
        get {
            return 0.0
        }
    }
    var isOnline: Bool {
        get {
            return true
        }
    }
    
    var currentTime: Double {
        get {
            return 0.0
        }
    }
    
    var rate: Bool {
        get {
            return false
        }
    }
    
    init(song: Song) {
        self.song = song
    }
    
    internal func play(duration: Double? = nil, completed: (_ isSeek: Bool) -> Void, error: (() -> Void)? = nil) {
        
    }
    
    internal func repeatSong(isRepeat: Bool) {
        
    }

    internal func rewind(count: Int = -2) {
        
    }

    internal func foward(count: Int = 2) {
        
    }

    internal func pause(completed: ((_ isPause: Bool) -> Void)? = nil) {
        
    }
    
    internal func stop(completed: (() -> Void)? = nil) {
        
    }
    
    func remoteControl( image: UIImage) {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyTitle: self.song.name,
            MPMediaItemPropertyArtist: self.song.artist,
            MPMediaItemPropertyArtwork: MPMediaItemArtwork.init(boundsSize: image.size, requestHandler: { (size) -> UIImage in
                return image
            }),
            MPMediaItemPropertyPlaybackDuration: self.duration,
            MPMediaItemPropertyPlayCount: self.currentTime
        ]
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }

    
    
    func update(handle: @escaping ( _ currentTime: Double) -> Void, end: @escaping () -> Void) {
        
    }

    
}
