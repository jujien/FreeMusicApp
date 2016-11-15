//
//  AppDelegate.swift
//  Hackathon
//
//  Created by Vũ Kiên on 15/11/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var playBarView: PlayBarView?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func loadPlayBarView(listControl: ListMusicControl, frame: CGRect) {
        self.playBarView = Bundle.main.loadNibNamed(playBarViewID, owner: self, options: nil)?.first as? PlayBarView
        self.playBarView?.listControl = listControl
        self.playBarView?.frame = frame
        self.playBarView?.setupUI()
        self.playBarView?.getData()
        self.window?.rootViewController?.view.addSubview(self.playBarView!)
        self.window?.rootViewController?.view.bringSubview(toFront: self.playBarView!)
    }
    
    func loadPlayVC(listControl: ListMusicControl, disposeBag: DisposeBag) {
        let playVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: playSongVCID) as! PlaySongViewController
        playVC.listControl = listControl
        playVC.disposeBag = disposeBag
        self.window?.rootViewController?.present(playVC, animated: true, completion: nil)
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    //MARK: - RemoteControl
    override func remoteControlReceived(with event: UIEvent?) {
        guard let event = event else {
            return
        }
        
        guard event.type == .remoteControl else {
            return
        }
        
        switch event.subtype {
        case .remoteControlPlay:
            self.playBarView?.listControl?.musicControl.play(completed: { (isSeek) in
            })
            break
        case .remoteControlPause:
            self.playBarView?.listControl?.musicControl.pause(completed: { (isPause) in
            })
            break
        case .remoteControlNextTrack:
            self.playBarView?.listControl?.next()
            break
        case .remoteControlPreviousTrack:
            self.playBarView?.listControl?.previous()
            break
        default:
            break
        }
    }
}

