//
//  Genre.swift
//  Hackathon
//
//  Created by Vũ Kiên on 15/11/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import Foundation
import SwiftyJSON

class Genre {
    var id = 0
    var genreTitle = ""
    var urlString = ""
    var imageName = ""
    
    init(id: Int, urlString: String, genreTitle: String, imageName: String) {
        self.id = id
        self.genreTitle = genreTitle
        self.urlString = urlString
        self.imageName = imageName
    }
    
    static func create() -> [Genre] {
        var listGenre = [Genre]()
        for genre in genres {
            let index = genres.index(of: genre)!
            let imageName = "genre-\(genre)"
            let urlString = String(format: urlItunesString, 50, genre)
            listGenre.append(Genre(id: index, urlString: urlString, genreTitle: "", imageName: imageName))
        }
        return listGenre
    }
    
    static func parseJSON(_ json: JSON) -> String {
        let feed = json[feedKey]
        return feed[titleKey][labelKey].string!
    }
}
