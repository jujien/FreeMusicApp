//
//  Constant.swift
//  MusicApp
//
//  Created by Vũ Kiên on 21/10/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import Foundation
import UIKit

//MARK: - Constant Data
let imageName = "genre-%d"
let urlItunesString = "https://itunes.apple.com/us/rss/topsongs/limit=%d/genre=%d/explicit=true/json"
let urlMusicString = "http://api.mp3.zing.vn/api/mobile/search/song?requestdata={\"q\":\"%@\", \"sort\":\"hot\", \"start\":\"0\", \"length\":\"10\"}"
let genres = [2,3,4,5,6,7,9,10,11,12,14,15,16,17,18,19,20,21,22,24,34,50,51]
let genreImages = [#imageLiteral(resourceName: "genre-2"), #imageLiteral(resourceName: "genre-3"), #imageLiteral(resourceName: "genre-4"), #imageLiteral(resourceName: "genre-5"), #imageLiteral(resourceName: "genre-6"), #imageLiteral(resourceName: "genre-7"), #imageLiteral(resourceName: "genre-9"), #imageLiteral(resourceName: "genre-10"), #imageLiteral(resourceName: "genre-11"), #imageLiteral(resourceName: "genre-12"), #imageLiteral(resourceName: "genre-14"), #imageLiteral(resourceName: "genre-15"), #imageLiteral(resourceName: "genre-16"), #imageLiteral(resourceName: "genre-17"), #imageLiteral(resourceName: "genre-18"), #imageLiteral(resourceName: "genre-19"), #imageLiteral(resourceName: "genre-20"), #imageLiteral(resourceName: "genre-21"), #imageLiteral(resourceName: "genre-22"), #imageLiteral(resourceName: "genre-24"), #imageLiteral(resourceName: "genre-34"), #imageLiteral(resourceName: "genre-50"), #imageLiteral(resourceName: "genre-51")]

//MARK: - Constant Key JSON
let feedKey = "feed"
let titleKey = "title"
let labelKey = "label"
let entryKey = "entry"
let nameKey = "im:name"
let artistKey = "im:artist"
let artistkey = "artist"
let imageKey = "im:image"
let docsKey = "docs"
let sourceKey = "source"
let source_128Key = "128"
let source_320Key = "320"


//MARK: - Constant ID Controller
let topVCID = "TopSongViewController"
let playSongVCID = "PlaySongViewController"
let genreCollectionViewCell = "GenreCollectionViewCell"
let songTableViewCell = "SongTableViewCell"
let playViewID = "PlaySongView"
let playBarViewID = "PlayBarView"

//MARK: - Constant Cell Identifire
let genreIdentifire = "GenreCell"
let songIdentifire = "SongCell"
let showTopSongIdentifire = "showTopSongIdentifire"


