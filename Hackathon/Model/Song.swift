//
//  Song.swift
//  Hackathon
//
//  Created by Vũ Kiên on 15/11/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import Foundation
import SwiftyJSON

class Song {
    var id = 0
    var genreID = 0
    var name = ""
    var artist = ""
    var imageUrl = ""
    var sourceUrl = ""
    var source: Source?
    
    init(id: Int, genreID: Int, name: String, artist: String, imageUrl: String) {
        self.id = id
        self.genreID = genreID
        self.name = name
        self.artist = artist
        self.imageUrl = imageUrl
    }

    
    static func itunesParseJSON(_ json: JSON, genre: Genre) -> [Song] {
        var songs = [Song]()
        let feed = json[feedKey]
        let entries = feed[entryKey].array!
        for entry in entries {
            let name = entry[nameKey][labelKey].string!
            let artist = entry[artistKey][labelKey].string!
            let imageUrl = entry[imageKey].array![2][labelKey].string!
            let index = entries.index(of: entry)!
            songs.append(Song(id: index, genreID: genre.id, name: name, artist: artist, imageUrl: imageUrl))
        }
        return songs
    }
    
    static func zingParseJSON(_ json: JSON, song: Song) -> String? {
        guard let docs = json[docsKey].array else {
            print("not result")
            return nil
        }
        
        guard docs.count > 0 else {
            print("not docs")
            return nil
        }
        let doc = scoreResult(docs: docs, song: song)
        return doc[sourceKey][source_128Key].string!
        
    }
    
    fileprivate static func scoreResult(docs: [JSON], song: Song) -> JSON {
        var array = [(String, Double, JSON)]()
        
        for doc in docs {
            let title = doc[titleKey].string!
            let artist = doc[artistkey].string!
            let source = doc[sourceKey][source_128Key].string!
            guard !source.isEmpty else {
                break
            }
            let score = (song.name + " " + song.artist).score(title + " " + artist)
            array.append((song.name + " " + song.artist, score, doc))
        }
        
        let doc = array.sorted(by: { (a, b) -> Bool in
            return a.1 > b.1
        }).first!
        return doc.2
    }
}
