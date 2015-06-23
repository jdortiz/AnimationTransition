//
//  PresenterAnimator2DFrame.swift
//  AnimationTransition
//
//  Created by Jorge D. Ortiz Fuentes on 23/6/15.
//  Copyright (c) 2015 PoWWaU. All rights reserved.
//


import UIKit
import Darwin


public class PresenterAnimator2DFrame: NSObject {
    let forward: Bool
    
    public init(forward: Bool) {
        self.forward = forward
    }
}


extension PresenterAnimator2DFrame: UIViewControllerAnimatedTransitioning {

    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey),
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey) {
                if forward {
                    animateTransitionForward(transitionContext, fromViewController: fromViewController, toViewController: toViewController, fromView: fromView, toView: toView)
                } else {
                    animateTransitionBackward(transitionContext, fromViewController: fromViewController, toViewController: toViewController, fromView: fromView, toView: toView)
                }
        }
    }


    func animateTransitionForward(transitionContext: UIViewControllerContextTransitioning, fromViewController: UIViewController, toViewController: UIViewController, fromView: UIView, toView: UIView) {
        let containerView = transitionContext.containerView()
        let endFrame = transitionContext.finalFrameForViewController(toViewController)

        if transitionContext.isAnimated() {
            let screenFrame = UIScreen.mainScreen().bounds
//            let startFrame = CGRect(x: endFrame.origin.x, y: screenFrame.size.height, width: endFrame.size.width, height: endFrame.size.height)
            let startFrame = CGRect(x: -screenFrame.size.width, y: screenFrame.size.height, width: endFrame.size.width, height: endFrame.size.height)
            toView.frame = startFrame
            containerView.addSubview(toView)
            UIView.animateWithDuration(self.transitionDuration(transitionContext),
                delay: 0.0,
                usingSpringWithDamping: 0.80,
                initialSpringVelocity: 0.0,
                options: UIViewAnimationOptions(0),
                animations:{
                    toView.frame = endFrame
                    fromView.tintAdjustmentMode = .Dimmed
                }, completion: { (finished: Bool) in
                    transitionContext.completeTransition(true)
            })
        } else {
            toView.frame = endFrame
            containerView.addSubview(toView)
        }
    }


    func animateTransitionBackward(transitionContext: UIViewControllerContextTransitioning, fromViewController: UIViewController, toViewController: UIViewController, fromView: UIView, toView: UIView) {
        let containerView = transitionContext.containerView()
        
        if transitionContext.isAnimated() {
            let endFrame: CGRect, startFrame: CGRect
            let screenFrame = UIScreen.mainScreen().bounds
            startFrame = transitionContext.initialFrameForViewController(fromViewController)
//            endFrame = CGRect(x: startFrame.origin.x, y: screenFrame.size.height, width: startFrame.size.width, height: startFrame.size.height)
            endFrame = CGRect(x: screenFrame.size.width, y: screenFrame.size.height, width: startFrame.size.width, height: startFrame.size.height)
            fromViewController.view.frame = startFrame
            containerView.insertSubview(toView, belowSubview:fromView)
            UIView.animateWithDuration(transitionDuration(transitionContext),
                delay: 0.0,
                usingSpringWithDamping: 0.80,
                initialSpringVelocity: 0.0,
                options: UIViewAnimationOptions(0),
                animations:{
                    toView.tintAdjustmentMode = .Automatic
                    fromView.frame = endFrame
                }, completion: { (finished: Bool) in
                    transitionContext.completeTransition(finished)
            })
        } else {
            toView.frame = transitionContext.finalFrameForViewController(fromViewController)
            containerView.insertSubview(toView, belowSubview:fromView)
        }
    }
    
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 1.0
    }
}
