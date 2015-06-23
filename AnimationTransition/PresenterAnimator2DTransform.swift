//
//  PresenterAnimator2DTransform.swift
//  AnimationTransition
//
//  Created by Jorge D. Ortiz Fuentes on 23/6/15.
//  Copyright (c) 2015 PoWWaU. All rights reserved.
//


import UIKit


public class PresenterAnimator2DTransform: NSObject {
    let forward: Bool
    let scaleFactor2DBackground = 0.8
    let scaleFactor2DForeground = 0.9
    
    public init(forward: Bool) {
        self.forward = forward
    }
}


extension PresenterAnimator2DTransform: UIViewControllerAnimatedTransitioning {
    
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
        toView.frame = endFrame
        
        if transitionContext.isAnimated() {
            let relativeDurationFirstPart = 0.4
            let relativeDurationSecondPart = 1.0 - relativeDurationFirstPart
            let containerView = transitionContext.containerView()
            
            UIView.animateWithDuration(relativeDurationFirstPart * transitionDuration(transitionContext),
                delay: 0.0,
                /*            usingSpringWithDamping: 0.70,
                initialSpringVelocity: 4.0,*/
                options: UIViewAnimationOptions(0),
                animations:{ [unowned self] in
                    fromView.tintAdjustmentMode = .Dimmed
                    fromView.transform = CGAffineTransformScale(CGAffineTransformIdentity,
                        CGFloat(self.scaleFactor2DBackground), CGFloat(self.scaleFactor2DBackground))
                }, completion: {[unowned self] (finished: Bool) in
                    let screenFrame = UIScreen.mainScreen().bounds
                    toView.transform = CGAffineTransformTranslate(
                        CGAffineTransformScale(CGAffineTransformIdentity,
                            CGFloat(self.scaleFactor2DForeground), CGFloat(self.scaleFactor2DForeground)),
                        0.0, screenFrame.size.height)
                    containerView.addSubview(toView)
                    UIView.animateWithDuration(relativeDurationSecondPart * self.transitionDuration(transitionContext),
                        delay: 0.0,
                        /*                    usingSpringWithDamping: 0.70,
                        initialSpringVelocity: 4.0,*/
                        options: UIViewAnimationOptions(0),
                        animations:{
                            toView.transform = CGAffineTransformIdentity
                        }, completion: { (finished: Bool) in
                            transitionContext.completeTransition(true)
                    })
                })
        } else {
            containerView.addSubview(toView)
        }
    }
    
        
    func animateTransitionBackward(transitionContext: UIViewControllerContextTransitioning, fromViewController: UIViewController, toViewController: UIViewController, fromView: UIView, toView: UIView) {
        let containerView = transitionContext.containerView()
        
        if transitionContext.isAnimated() {
            let containerView = transitionContext.containerView()
            let endFrame: CGRect, startFrame: CGRect
            let screenFrame = UIScreen.mainScreen().bounds
            startFrame = transitionContext.initialFrameForViewController(fromViewController)
            endFrame = CGRect(x: startFrame.origin.x, y: screenFrame.size.height, width: startFrame.size.width, height: startFrame.size.height)
            toViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9)
            fromViewController.view.frame = startFrame
            containerView.insertSubview(toViewController.view!, belowSubview:fromViewController.view!)
            UIView.animateWithDuration(transitionDuration(transitionContext), animations:{
                toViewController.view.tintAdjustmentMode = .Automatic
                toViewController.view.transform = CGAffineTransformIdentity
                fromViewController.view.frame = endFrame
                }, completion: { (finished: Bool) in
                    transitionContext.completeTransition(finished)
            })
        } else {
            toView.frame = transitionContext.finalFrameForViewController(fromViewController)
            containerView.insertSubview(toView, belowSubview:fromView)
        }
    }
    
    //    public func animationEnded(transitionCompleted: Bool) {
    //
    //    }
    
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.6
    }
}
