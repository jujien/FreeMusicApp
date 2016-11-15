//
//  Extention.swift
//  Hackathon
//
//  Created by Vũ Kiên on 15/11/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import UIKit

extension UIView {
    func cornerCircle() {
        self.layer.cornerRadius = self.frame.width / 2.0
        self.layer.masksToBounds = true
    }
}
