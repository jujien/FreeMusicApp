//
//  SongTableViewCell.swift
//  Hackathon
//
//  Created by Vũ Kiên on 15/11/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import UIKit

class SongTableViewCell: UITableViewCell {
    @IBOutlet weak var songImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    var service: InternetService!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupUI(song: Song) {
        if let data = song.source?.sourceImage {
            self.layoutIfNeeded()
            self.songImageView.image = UIImage(data: data)
            self.songImageView.cornerCircle()
            self.nameLabel.text = song.name
            self.artistLabel.text = song.artist
        } else {
            self.service = InternetService()
            do {
                try service.loadDataImage(urlString: song.imageUrl, completeConnected: { (image) in
                    self.songImageView.image = image
                    self.songImageView.cornerCircle()
                    self.nameLabel.text = song.name
                    self.artistLabel.text = song.artist
                    song.source = Source()
                    song.source?.sourceImage = UIImageJPEGRepresentation(image, 1.0)
                }, errorResult: { 
                    print("not result")
                }, errorConnect: { 
                    print("not connect")
                })
            } catch {
                print("error: " + error.localizedDescription)
            }
        }
    }

    @IBAction func addDidTapped(_ sender: UIButton) {
    }
}
