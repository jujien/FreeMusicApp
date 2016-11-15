//
//  DiscoverNavigationController.swift
//  Hackathon
//
//  Created by Vũ Kiên on 15/11/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import UIKit

class DiscoverNavigationController: UINavigationController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.delegate = self
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = NavigationTransition()
        transition.duration = 1.0
        return transition
    }

}
