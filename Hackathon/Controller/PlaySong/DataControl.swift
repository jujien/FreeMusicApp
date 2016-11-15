//
//  DataControl.swift
//  Hackathon
//
//  Created by Vũ Kiên on 15/11/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import Foundation
import SwiftyJSON

class DataControl {
    static var `default` = DataControl()
    let service = InternetService()
    
    func getData(song: Song, complete: @escaping (_ isOnline: Bool) -> Void, errorData: @escaping () -> Void) {
        guard let _ = song.source?.sourceSong else {
            self.getDataInternet(song: song, complete: complete, errorData: errorData)
            return
        }
        complete(false)
    }
    
    func getDataInternet(song: Song, complete: @escaping (_ isOnline: Bool) -> Void, errorData: @escaping () -> Void) {
        do {
            try service.loadJSON(urlString: String(format: urlMusicString, song.name + " " + song.artist).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!, completeConnected: { (value) in
                guard let urlSource = Song.zingParseJSON(JSON(value), song: song) else {
                    errorData()
                    return
                }
                song.sourceUrl = urlSource
                print("urlSource: " + song.sourceUrl)
                complete(true)
            }, errorResult: {
                errorData()
            }, errorConnect: {
                errorData()
            })
        } catch {
            print("error: " + error.localizedDescription)
            errorData()
        }
    }
    
    func update(_ update: () -> Void) {
        service.reset()
        update()
    }
}
