//
//  PlaySongViewController.swift
//  Hackathon
//
//  Created by Vũ Kiên on 15/11/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PlaySongViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var optionButton: UIButton!
    
    var listControl: ListMusicControl?
    var disposeBag: DisposeBag!
    fileprivate var playSongView: PlaySongView!
    fileprivate var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupUI()
        self.addEvent()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: - UI
    fileprivate func setupUI() {
        self.setupPlayView()
        self.setupTableView()
    }
    
    fileprivate func setupPlayView() {
        self.playSongView = PlaySongView.loadNib()
        self.playSongView.frame = self.containerView.bounds
        self.playSongView.listControl = self.listControl
        self.playSongView.disposeBag = self.disposeBag
        self.playSongView.setupUI()
        self.containerView.addSubview(self.playSongView)
    }
    
    fileprivate func setupTableView() {
        let nib = UINib(nibName: songTableViewCell, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: songIdentifire)
        self.listControl?.lists.asObservable().bindTo(
            self.tableView.rx.items(cellIdentifier: songIdentifire, cellType: SongTableViewCell.self)
        ) { (row, song, cell) in
            cell.setupUI(song: song)
            if row == self.listControl!.musicControl.song.id {
                cell.chooseView.isHidden = false
                self.index = row
            } else {
                cell.chooseView.isHidden = true
            }
        }.addDisposableTo(self.disposeBag)
        self.scrollToRow()
        
    }
    
    //MARK: - Event
    fileprivate func addEvent() {
        self.tableView.delegate = self
        self.listControl?.delegate = self
        self.playSongView.addEvent()
        self.backButton.rx.controlEvent(.touchUpInside).bindNext {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.playBarView?.setupUI()
            self.dismiss(animated: true, completion: {
                
            })
        }.addDisposableTo(disposeBag)
        
        self.tableView.rx.modelSelected(Song.self).bindNext { (song) in
            self.chooseSong(song: song)
            }.addDisposableTo(disposeBag)
    }
    
    fileprivate func scrollToRow() {
        var cell = self.tableView.cellForRow(at: IndexPath(row: self.index, section: 0)) as! SongTableViewCell
        cell.chooseView.isHidden = true
        self.index = self.listControl!.lists.value.index { (song) -> Bool in
            return self.listControl!.musicControl.song.imageUrl == song.imageUrl
        }!
        self.tableView.scrollToRow(at:IndexPath(item: self.index, section: 0), at: .top, animated: true)
        cell = self.tableView.cellForRow(at: IndexPath(row: self.index, section: 0)) as! SongTableViewCell
        cell.chooseView.isHidden = false
    }
    
    fileprivate func chooseSong(song: Song) {
        self.playSongView.setupButton(interaction: false)
        self.listControl?.musicControl.stop()
        self.listControl?.musicControl.song = song
        scrollToRow()
        self.playSongView.wait.startAnimating()
        DataControl.default.service.reset()
        DataControl.default.getData(song: song, complete: { (isOnline) in
            if isOnline {
                self.listControl?.musicControl = MusicControlOnline(song: song)
            } else {
                self.listControl?.musicControl = MusicControlOffline(song: song)
            }
            self.playSongView.setupUI()
            self.playSongView.wait.stopAnimating()
        }, errorData: {
            self.playSongView.wait.stopAnimating()
        })
    }
}

extension PlaySongViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
}

extension PlaySongViewController: MusicControlDelegate {
    func updateSong() {
        if self.listControl!.numberOfRepeat == 2 {
            self.playSongView.listControl?.musicControl.repeatSong(isRepeat: false)
            self.playSongView.repeatButton.setBackgroundImage(#imageLiteral(resourceName: "img-player-repeat-none"), for: .normal)
        }
        self.chooseSong(song: self.listControl!.musicControl.song)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.playBarView?.setupUI()
    }
    
    func updateList(lists: NSArray) {
        self.listControl?.lists.value = lists as! [Song]
        self.tableView.reloadData()
    }
}
