//
//  MusicControlOnline.swift
//  Hackathon
//
//  Created by Vũ Kiên on 15/11/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import Foundation
import AVFoundation

class MusicControlOnline: MusicControl {
    
    var player: AVPlayer?
    
    override var duration: Double {
        guard let player = self.player else {
            return 0.0
        }
        return player.currentItem!.asset.duration.seconds
    }
    
    override var currentTime: Double {
        guard let player = self.player else {
            return 0.0
        }
        return player.currentTime().seconds
    }
    
    override var rate: Bool {
        guard let player = self.player else {
            return false
        }
        if player.rate == 1.0 {
            return true
        } else {
            return false
        }
    }
    
    override init(song: Song) {
        super.init(song: song)
        guard !song.sourceUrl.isEmpty else {
            return
        }
        let playerItem = AVPlayerItem(url: URL(string: song.sourceUrl)!)
        self.player = AVPlayer(playerItem: playerItem)
    }
    
    override func play(duration: Double? = nil, completed: (_ isSeek: Bool) -> Void, error: (() -> Void)? = nil) {
        guard let duration = duration else {
            completed(false)
            player?.play()
            do {
                try self.playBackground()
            } catch {
                print("error: \(error.localizedDescription)")
            }
            return
        }
        player?.seek(to: CMTimeMake(Int64(duration), 1))
        player?.play()
        completed(true)
    }
    
    override func pause(completed: ((_ isPause: Bool) -> Void)? = nil) {
        if player?.timeControlStatus == .playing {
            player?.pause()
            completed?(true)
        } else {
            self.player?.play()
            completed?(false)
        }
        
    }
    
    override func stop(completed: (() -> Void)? = nil) {
        self.player?.pause()
        self.player = nil
        completed?()
        
    }
    
    override func foward(count: Int = 2) {
        self.player?.seek(to: CMTimeMake(Int64(Double(count)*1.0 + self.player!.currentTime().seconds), 1), toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        self.player?.play()
    }
    
    override func rewind(count: Int = -2) {
        self.player?.seek(to: CMTimeMake(Int64(Double(count)*1.0 + self.player!.currentTime().seconds), 1), toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        self.player?.play()
    }
    
    override func repeatSong(isRepeat: Bool) {
        if isRepeat {
            NotificationCenter.default.addObserver(self, selector: #selector(loop), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player!.currentItem)
        } else {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player!.currentItem)
        }
    }
    
    @objc
    fileprivate func loop (notification: Notification) {
        self.player?.seek(to: kCMTimeZero)
        self.player?.play()
    }
    
    override func update(handle: @escaping ( _ currentTime: Double) -> Void, end: @escaping () -> Void) {
        player?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, 1), queue: DispatchQueue.main, using: { (time) in
            guard let _ = self.player else {
                return
            }
            if time.seconds <= self.player!.currentItem!.duration.seconds {
                handle(time.seconds)
            } else {
                self.player?.pause()
                end()
            }
            
        })
    }

    func playBackground() throws {
        try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try AVAudioSession.sharedInstance().setActive(true)
    }
    
}
