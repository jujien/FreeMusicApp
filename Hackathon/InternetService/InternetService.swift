//
//  InternetService.swift
//  Hackathon
//
//  Created by Vũ Kiên on 15/11/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import Foundation
import ReachabilitySwift
import Alamofire
import AlamofireImage

class InternetService {
    var reachability: Reachability?
    
    init() {
        reachability = Reachability()
    }
    
    func loadJSON(urlString: String, completeConnected: @escaping (_ value: Any) -> Void, errorResult: @escaping () -> Void, errorConnect: @escaping () -> Void) throws {
        reachability?.whenReachable = { reachability in
            DispatchQueue.main.async {
                Alamofire.request(urlString).responseJSON(completionHandler: { (response) in
                    if let value = response.result.value {
                        completeConnected(value)
                    } else {
                        errorResult()
                    }
                })
            }
        }
        
        reachability?.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                errorConnect()
            }
        }
        
        try reachability?.startNotifier()
    }
    
    func loadDataImage(urlString: String, completeConnected: @escaping (_ image: UIImage) -> Void, errorResult: @escaping () -> Void, errorConnect: @escaping () -> Void) throws {
        reachability?.whenReachable = { reachability in
            DispatchQueue.main.async {
                Alamofire.request(urlString).responseImage(completionHandler: { (response) in
                    if let image = response.result.value {
                        completeConnected(image)
                    } else {
                        errorResult()
                    }
                })
            }
        }
        
        reachability?.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                errorConnect()
            }
        }
        
        try reachability?.startNotifier()
    }
    
    func loadData(urlString: String, completeDownload: @escaping ( _ data: Data) -> Void, errorResult: @escaping () -> Void?, errorConnect: @escaping () -> Void) throws {
        reachability?.whenReachable = {reachability in
            DispatchQueue.main.async {
                Alamofire.request(urlString).responseData(completionHandler: { (response) in
                    if let data = response.data {
                        completeDownload(data)
                    } else {
                        errorResult()
                    }
                })
            }
        }
        
        reachability?.whenUnreachable = {reachability in
            DispatchQueue.main.async {
                errorConnect()
            }
        }
        
        try reachability?.startNotifier()
    }
    
    func downloadData(urlString: String,loading: @escaping () -> Void, update: @escaping ( _ progress: Float) -> Void, result: @escaping (_ data: Data) -> Void, error: @escaping () -> Void) throws {
        self.reachability?.whenReachable = { reachability in
            DispatchQueue.main.async {
                Alamofire.download(urlString).downloadProgress(closure: { (progress) in
                    if progress.isPaused {
                        loading()
                    }
                    update(Float(progress.fractionCompleted))
                }).responseData(completionHandler: { (download) in
                    if let data = download.result.value {
                        result(data)
                    }
                })
            }
        }
        
        self.reachability?.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                error()
            }
        }
        try reachability?.startNotifier()
    }
    
    func stop() {
        reachability?.stopNotifier()
    }
    
    func reset() {
        reachability?.stopNotifier()
        reachability = nil
        reachability = Reachability()
    }
}
