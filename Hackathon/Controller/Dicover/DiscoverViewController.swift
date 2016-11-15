//
//  DiscoverViewController.swift
//  Hackathon
//
//  Created by Vũ Kiên on 15/11/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DiscoverViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var listGenre = Variable<[Genre]>([])
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupUI()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - UI
    fileprivate func setupUI() {
        self.collectionView.delegate = self
        self.listGenre.value = Genre.create()
        self.listGenre.asObservable().bindTo(
            self.collectionView.rx.items(cellIdentifier: genreIdentifire, cellType: GenreCollectionViewCell.self)
        ) { (row, genre, cell) in
            cell.setupUI(genre: genre)
        }.addDisposableTo(disposeBag)
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showTopSongIdentifire {
            let topVC = segue.destination as! TopSongViewController
            let index = self.collectionView.indexPath(for: sender as! GenreCollectionViewCell)!
            topVC.genre = self.listGenre.value[index.row]
            topVC.disposeBag = self.disposeBag
        }
    }

}

extension DiscoverViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.collectionView.frame.width - 30.0) / 2.0, height: self.collectionView.frame.height / 3.0)
    }
}
