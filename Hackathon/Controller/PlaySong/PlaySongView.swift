//
//  PlaySongView.swift
//  Hackathon
//
//  Created by Vũ Kiên on 15/11/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PlaySongView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var remainTimeLabel: UILabel!
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var previousButton: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nextButton: UIImageView!
    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var wait: UIActivityIndicatorView!
    
    var listControl: ListMusicControl?
    var disposeBag: DisposeBag!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.slider.setThumbImage(#imageLiteral(resourceName: "img-slider-thumb"), for: .normal)
    }
    
    static func loadNib() -> PlaySongView {
        return UINib(nibName: playViewID, bundle: nil).instantiate(withOwner: self, options: nil).first as! PlaySongView
    }
    
    //MARK: - UI
    func setupButton(interaction: Bool) {
        self.slider.isUserInteractionEnabled = interaction
        self.repeatButton.isUserInteractionEnabled = interaction
        self.previousButton.isUserInteractionEnabled = interaction
        self.playButton.isUserInteractionEnabled = interaction
        self.playButton.isUserInteractionEnabled = interaction
        self.nextButton.isUserInteractionEnabled = interaction
        self.shuffleButton.isUserInteractionEnabled = interaction
    }
    
    func setupUI() {
        self.imageView.image = UIImage(data: self.listControl!.musicControl.song.source!.sourceImage!)
        self.setBackgroundRepeat(count: self.listControl!.numberOfRepeat)
        self.setBackgroundShuffle(count: self.listControl!.numberOfShuffle)
        self.slider.maximumValue = Float(self.listControl!.musicControl.duration)
        if self.listControl!.musicControl.rate {
            self.playButton.setBackgroundImage(#imageLiteral(resourceName: "img-player-pause"), for: .normal)
        } else {
            self.listControl?.musicControl.play(completed: { (isSeek) in
                self.playButton.setBackgroundImage(#imageLiteral(resourceName: "img-player-pause"), for: .normal)
            })
        }
        self.becomeFirstResponder()
        self.listControl?.musicControl.remoteControl(image: self.imageView.image!)
        self.updateLabel()
        self.setupButton(interaction: true)
        self.wait.stopAnimating()
    }
    
    fileprivate func updateLabel() {
        self.listControl?.musicControl.update(handle: { (time) in
            self.currentTimeLabel.text = convertTimeIntervalToString(duration: time)
            self.remainTimeLabel.text = "-" + convertTimeIntervalToString(duration: self.listControl!.musicControl.duration - time)
            self.slider.value = Float(time)
        }, end: {
            self.playButton.setBackgroundImage(#imageLiteral(resourceName: "img-player-play"), for: .normal)
        })
    }
    
    fileprivate func setBackgroundRepeat(count: Int) {
        if count == 1 {
            self.repeatButton.setBackgroundImage(#imageLiteral(resourceName: "img-player-repeat"), for: .normal)
        } else if count == 2 {
            self.repeatButton.setBackgroundImage(#imageLiteral(resourceName: "img-player-repeat-1"), for: .normal)
        } else {
            self.repeatButton.setBackgroundImage(#imageLiteral(resourceName: "img-player-repeat-none"), for: .normal)
        }
    }
    
    fileprivate func setBackgroundShuffle(count: Int) {
        if count == 0 {
            self.shuffleButton.setBackgroundImage(#imageLiteral(resourceName: "img-player-shuffle-off"), for: .normal)
        } else {
            self.shuffleButton.setBackgroundImage(#imageLiteral(resourceName: "img-player-shuffle"), for: .normal)
        }
    }
    
    //MARK: Event
    @IBAction func sliderChanged(_ sender: UISlider) {
        self.listControl?.musicControl.play(duration: Double(sender.value), completed: { (_) in
        }, error: nil)
    }
    
    func addEvent() {
        self.playEvent()
        self.repeatEvent()
        self.shuffleEvent()
        self.forwardEvent()
        self.rewindEvent()
    }
    
    fileprivate func playEvent() {
        self.playButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
            self.listControl?.musicControl.pause(completed: { (isPause) in
                if isPause {
                    self.playButton.setBackgroundImage(#imageLiteral(resourceName: "img-player-play"), for: .normal)
                } else {
                    self.playButton.setBackgroundImage(#imageLiteral(resourceName: "img-player-pause"), for: .normal)
                }
                
            })
        }).addDisposableTo(disposeBag)
    }
    
    fileprivate func repeatEvent() {
        self.repeatButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
            self.listControl!.numberOfRepeat += 1
            if self.listControl!.numberOfRepeat == 1 {
                self.listControl?.repeatList(isRepeat: true)
            } else if self.listControl!.numberOfRepeat == 2 {
                self.listControl?.musicControl.repeatSong(isRepeat: true)
                self.listControl?.repeatList(isRepeat: false)
            } else {
                self.listControl?.musicControl.repeatSong(isRepeat: false)
                self.listControl!.numberOfRepeat = 0
            }
            print(self.listControl!.numberOfRepeat)
            self.setBackgroundRepeat(count: self.listControl!.numberOfRepeat)
        }).addDisposableTo(disposeBag)
    }
    
    fileprivate func forwardEvent() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapNext))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        self.nextButton.addGestureRecognizer(tapGesture)
        let forwardGesture = UILongPressGestureRecognizer(target: self, action: #selector(PlaySongView.forward(gesture:)))
        self.nextButton.addGestureRecognizer(forwardGesture)
    }
    
    fileprivate func rewindEvent() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapBack))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        self.previousButton.addGestureRecognizer(tapGesture)
        let rewindGesture = UILongPressGestureRecognizer(target: self, action: #selector(rewind))
        self.previousButton.addGestureRecognizer(rewindGesture)
    }
    
    fileprivate func shuffleEvent() {
        self.shuffleButton.rx.controlEvent(.touchUpInside).bindNext {
            self.listControl!.numberOfShuffle += 1
            if self.listControl!.numberOfShuffle == 1 {
                self.listControl?.shuffle(isShuffle: true)
            } else  {
                self.listControl?.shuffle(isShuffle: false)
                self.listControl!.numberOfShuffle = 0
            }
            self.setBackgroundShuffle(count: self.listControl!.numberOfShuffle)
            }.addDisposableTo(self.disposeBag)
    }
    
    @objc
    func tapNext(gesture: UITapGestureRecognizer) {
        self.listControl?.next()
    }
    
    @objc
    func tapBack(gesture: UITapGestureRecognizer) {
        self.listControl?.previous()
    }
    
    @objc
    func forward(gesture: UILongPressGestureRecognizer) {
        self.listControl?.musicControl.foward()
    }
    
    @objc
    func rewind(gesture: UILongPressGestureRecognizer) {
        self.listControl?.musicControl.rewind()
    }
}
