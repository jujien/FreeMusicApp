//
//  GenreCollectionViewCell.swift
//  Hackathon
//
//  Created by Vũ Kiên on 15/11/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import UIKit
import SwiftyJSON

class GenreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var genreImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var wait: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.text = ""
        self.isUserInteractionEnabled = false
    }
    
    func setupUI(genre: Genre) {
        if genre.genreTitle.isEmpty {
            let service = InternetService()
            do{
                self.wait.startAnimating()
                try service.loadJSON(urlString: genre.urlString, completeConnected: { (value) in
                    let title = Genre.parseJSON(JSON(value))
                    self.titleLabel.text = (title as NSString).substring(with: NSRange(location:26, length: title.characters.count - 26))
                    self.genreImageView.image = UIImage(named: genre.imageName)
                    genre.genreTitle = (title as NSString).substring(with: NSRange(location:26, length: title.characters.count - 26))
                    self.isUserInteractionEnabled = true
                    self.wait.stopAnimating()
                }, errorResult: {
                    print("not result")
                    self.wait.stopAnimating()
                }, errorConnect: {
                    print("not connect")
                    self.wait.stopAnimating()
                })
            } catch {
                print("error: " + error.localizedDescription)
                self.wait.stopAnimating()
            }
        } else {
            self.genreImageView.image = UIImage(named: genre.imageName)
            self.titleLabel.text = genre.genreTitle
        }
    }
}
