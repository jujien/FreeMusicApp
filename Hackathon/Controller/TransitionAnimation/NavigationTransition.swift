//
//  NavigationTransition.swift
//  Hackathon
//
//  Created by Vũ Kiên on 15/11/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import UIKit

class NavigationTransition: NSObject, UIViewControllerAnimatedTransitioning {
    var duration: TimeInterval!
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //push 
        if let fromViewController = transitionContext.viewController(forKey: .from) as? DiscoverViewController, let toViewController = transitionContext.viewController(forKey: .to) as? TopSongViewController {
            self.animation(fromViewController, toViewController, transitionContext: transitionContext)
        }
        //pop
        else if let fromViewController = transitionContext.viewController(forKey: .from) as? TopSongViewController, let toViewController = transitionContext.viewController(forKey: .to) as? DiscoverViewController {
            self.animation(fromViewController, toViewController, transitionContext: transitionContext)
        }
    }
    
    fileprivate func animation(_ from: DiscoverViewController, _ to: TopSongViewController, transitionContext: UIViewControllerContextTransitioning) {
        guard let indexPath = from.collectionView.indexPathsForSelectedItems?.first else {
            return
        }
        let cellframeInSuperView = cellFrameInSuperView(collectionView: from.collectionView, indexPath: indexPath)
        let cell = from.collectionView.cellForItem(at: indexPath) as! GenreCollectionViewCell
        let imageView = createImageView(image: cell.genreImageView.image!,
                                        frame: CGRect(x: cellframeInSuperView.origin.x,
                                                      y: cellframeInSuperView.origin.y,
                                                      width: cell.genreImageView.frame.width,
                                                      height: cell.genreImageView.frame.height))
        to.view.alpha = 0.0
        transitionContext.containerView.addSubview(to.view)
        let fromView = from.view
        transitionContext.containerView.addSubview(fromView!)
        transitionContext.containerView.addSubview(imageView)
        UIView.animate(withDuration: duration / 2.0, delay: 0.0, options: [], animations: {
            fromView?.alpha = 0.0
        }, completion: { _ in
            fromView?.removeFromSuperview()
            UIView.animate(withDuration: self.duration / 2, delay: 0.0, options: [], animations: {
                imageView.transform = CGAffineTransform(scaleX: to.imageView.frame.width / imageView.frame.width,
                                                        y: to.imageView.frame.height / imageView.frame.height)
                imageView.frame.origin = CGPoint(x: to.imageView.frame.origin.x, y:to.imageView.frame.origin.x + to.navigationController!.navigationBar.frame.height + 20.0)
            }, completion: { (_) in
                UIView.animate(withDuration: 1.0, delay: 0.0, options: [], animations: {
                    to.view.alpha = 1.0
                }, completion: { (_) in
                    imageView.removeFromSuperview()
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                })
            })
        })
        
        
    }
    
    fileprivate func animation(_ from: TopSongViewController, _ to: DiscoverViewController, transitionContext: UIViewControllerContextTransitioning) {
        guard let indexPath = to.collectionView.indexPathsForSelectedItems?.first else {
            return
        }
        let cellframeInSuperView = cellFrameInSuperView(collectionView: to.collectionView, indexPath: indexPath)
        let cell = to.collectionView.cellForItem(at: indexPath) as! GenreCollectionViewCell
        let imageView = createImageView(image: from.imageView.image!,
                                        frame: CGRect(x: from.imageView.frame.origin.x,
                                                      y: from.imageView.frame.origin.x + to.navigationController!.navigationBar.frame.height + 20.0,
                                                      width: from.imageView.frame.width,
                                                      height: from.imageView.frame.height))
        to.view.alpha = 0.0
        transitionContext.containerView.addSubview(to.view)
        let fromView = from.view!
        from.imageView.removeFromSuperview()
        transitionContext.containerView.addSubview(fromView)
        transitionContext.containerView.addSubview(imageView)
        UIView.animate(withDuration: self.duration / 2.0, delay: 0.0, options: [], animations: {
            imageView.transform = CGAffineTransform(scaleX: cell.genreImageView.frame.width / imageView.frame.width, y: cell.genreImageView.frame.height / imageView.frame.height)
            imageView.frame.origin = cellframeInSuperView.origin
            fromView.alpha = 0.0
        }, completion: { _ in
            fromView.removeFromSuperview()
            UIView.animate(withDuration: self.duration / 2.0, delay: 0, options: [], animations: {
                to.view.alpha = 1.0
            }, completion: { _ in
                imageView.removeFromSuperview()
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        })
        
    }
    
    fileprivate func cellFrameInSuperView(collectionView: UICollectionView, indexPath: IndexPath) -> CGRect {
        return collectionView.convert(collectionView.layoutAttributesForItem(at: indexPath)!.frame, to: collectionView.superview)
    }
    
    fileprivate func createImageView(image: UIImage, frame: CGRect) -> UIImageView {
        let imageView = UIImageView(image: image)
        imageView.frame = frame
        imageView.contentMode = .scaleToFill
        return imageView
    }
}
