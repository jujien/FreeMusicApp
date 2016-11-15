//
//  PlayBarView.swift
//  Hackathon
//
//  Created by Vũ Kiên on 15/11/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PlayBarView: UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    
    var listControl: ListMusicControl?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addEvent()
    }
    
    
    //MARK: - UI
    func setupUI() {
        self.layoutIfNeeded()
        self.imageView.image = UIImage(data: self.listControl!.musicControl.song.source!.sourceImage!)
        self.imageView.cornerCircle()
        self.nameLabel.text = self.listControl!.musicControl.song.name
        self.artistLabel.text = self.listControl!.musicControl.song.artist
        self.progressView.progress = 0.0
        self.setupProgress()
        
    }
    
    func setupProgress() {
        self.listControl!.musicControl.update(handle: { (time) in
            self.progressView.progress = Float(time / self.listControl!.musicControl.duration)
        }, end: {
        })
    }
    
    //MARK: Data
    func getData() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        DataControl.default.getData(song: self.listControl!.musicControl.song, complete: { (isOnline) in
            if isOnline {
                print(self.listControl!.musicControl.song.sourceUrl)
                self.listControl?.musicControl = MusicControlOnline(song: self.listControl!.musicControl.song)
            }
            self.play()
        }, errorData: {
            print("error")
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        })
    }
    
    //MARK: event
    fileprivate func play() {
        self.listControl?.delegate = self
        self.listControl?.musicControl.play(completed: { (isSeek) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.setupProgress()
        })
        self.becomeFirstResponder()
        self.listControl?.musicControl.remoteControl(image: self.imageView.image!)
    }
    
    fileprivate func addEvent() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(present(gesture:)))
        self.addGestureRecognizer(tap)
    }
    
    func reset(listControl: ListMusicControl) {
        self.listControl?.musicControl.stop()
        self.listControl = nil
        self.listControl = listControl
        DataControl.default.service.reset()
        self.setupUI()
        self.getData()
    }
    
    @objc
    fileprivate func present(gesture: UITapGestureRecognizer) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.loadPlayVC(listControl: self.listControl!, disposeBag: DisposeBag())
    }
}

extension PlayBarView: MusicControlDelegate {
    func updateSong() {
        self.listControl?.musicControl.stop()
        DataControl.default.service.reset()
        self.setupUI()
        self.getData()
    }
}
