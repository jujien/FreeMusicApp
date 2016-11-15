//
//  Utils.swift
//  FreeMusicApp
//
//  Created by Vũ Kiên on 05/11/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import Foundation
import UIKit

func showAlert(title: String, message: String) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alert.addAction(okAction)
    return alert
}

func convertTimeIntervalToString(duration: TimeInterval) -> String {
    let minutes = duration/60.0
    let seconds = Int(duration - Double(Int(minutes)) * 60.0)
    var secondString = ""
    if seconds < 10 {
        secondString = "0\(seconds)"
    } else {
        secondString = "\(seconds)"
    }
    return "\(Int(minutes)):" + secondString
}

func createImageView(image: UIImage, frame: CGRect) -> UIImageView {
    let imageView = UIImageView(image: image)
    imageView.frame = frame
    imageView.contentMode = .scaleToFill
    return imageView
}
