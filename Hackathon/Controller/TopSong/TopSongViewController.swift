//
//  TopSongViewController.swift
//  Hackathon
//
//  Created by Vũ Kiên on 15/11/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON

class TopSongViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var wait: UIActivityIndicatorView!
    
    var genre: Genre?
    var disposeBag: DisposeBag!
    var listSong = Variable<[Song]>([])
    let service = InternetService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupUI()
        self.getData()
        self.addEvent()
    }
    
    //MARK: - Data
    fileprivate func getData() {
        do {
            self.showAnimation(true)
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            try service.loadJSON(urlString: self.genre!.urlString, completeConnected: { (value) in
                self.listSong.value = Song.itunesParseJSON(JSON(value), genre: self.genre!)
                self.setupTableView()
                self.showAnimation(false)
            }, errorResult: {
                self.showAnimation(false)
            }, errorConnect: {
                self.showAnimation(false)
            })
        } catch {
            print("error: " + error.localizedDescription)
            self.showAnimation(false)
        }
    }
    
    //MARK: - UI
    fileprivate func setupUI() {
        self.imageView.image = UIImage(named: self.genre!.imageName)
        self.titleLabel.text = genre!.genreTitle
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        let nib = UINib(nibName: songTableViewCell, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: songIdentifire)
        self.tableView.delegate = self
    }
    
    fileprivate func setupTableView() {
        self.listSong.asObservable().bindTo(
            self.tableView.rx.items(cellIdentifier: songIdentifire, cellType: SongTableViewCell.self)
        ) { (row, song, cell) in
            cell.setupUI(song: song)
        }.addDisposableTo(self.disposeBag)
    }
    
    fileprivate func showAnimation(_ show: Bool) {
        if show {
            self.wait.startAnimating()
        } else {
            self.wait.stopAnimating()
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = show
    }
    
    //MARK: Event
    fileprivate func addEvent() {
        let backTap = UITapGestureRecognizer(target: self, action: #selector(tap))
        self.imageView.addGestureRecognizer(backTap)
        
        self.tableView.rx.modelSelected(Song.self).bindNext { (song) in
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let listControl = ListMusicControl(lists: self.listSong.value, musicControl: MusicControl(song: song))
            guard let playBarView = appDelegate.playBarView else {
                let rect = CGRect(x: 0, y: self.view.frame.height - 44.0, width: self.view.frame.width, height: 44.0)
                appDelegate.loadPlayBarView(listControl: listControl, frame: rect)
                return
            }
            
            playBarView.reset(listControl: listControl)
        }.addDisposableTo(self.disposeBag)
    }
    
    @objc
    fileprivate func tap(gesture: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension TopSongViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
}
