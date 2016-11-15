//
//  ListMusicControl.swift
//  Hackathon
//
//  Created by Vũ Kiên on 15/11/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import Foundation
import RxSwift

@objc protocol MusicControlDelegate: class {
    func updateSong()
    @objc optional func updateList(lists: NSArray)
}

class ListMusicControl {
    var lists: Variable<[Song]>
    var musicControl: MusicControl! {
        didSet {
            self.index = self.lists.value.index(where: { (song) -> Bool in
                return song.sourceUrl == self.musicControl.song.sourceUrl
            })!
        }
    }
    var index: Int = 0
    var numberOfRepeat: Int = 0
    var numberOfShuffle: Int = 0
    
    fileprivate var lastList: [Song]
    fileprivate var timer: Timer?
    weak var delegate: MusicControlDelegate?
    
    init(lists: [Song], musicControl: MusicControl) {
        self.lists = Variable<[Song]>(lists)
        self.lastList = lists
        self.musicControl = musicControl
    }
    
    internal func next() {
        if self.index < lists.value.count - 1 {
            self.index += 1
            self.musicControl.song = self.lists.value[index]
        } else {
            self.index = 0
            self.musicControl.song = self.lists.value.first!
        }
        self.musicControl.stop()
        delegate?.updateSong()
    }
    
    internal func previous() {
        if self.index > 0 {
            self.index -= 1
            self.musicControl.song = self.lists.value[index]
        } else {
            self.index = self.lists.value.count - 1
            self.musicControl.song = self.lists.value[self.index]
        }
        self.musicControl.stop()
        delegate?.updateSong()
    }
    
    internal func shuffle(isShuffle: Bool) {
        var lists = [Song]()
        if isShuffle {
            lists = self.lists.value.shuffled()
        } else {
            lists = self.lastList
        }
        delegate?.updateList?(lists: lists as NSArray)
    }
    
    internal func repeatList(isRepeat: Bool) {
        if isRepeat {
            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
                guard self.musicControl.currentTime == self.musicControl.duration else {
                    return
                }
                self.next()
            })
        } else {
            self.timer?.invalidate()
            timer = nil
        }
    }
}
