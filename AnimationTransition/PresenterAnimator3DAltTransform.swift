//
//  PresenterAnimator3DSnapshot.swift
//  AnimationTransition
//
//  Created by Jorge D. Ortiz Fuentes on 29/6/15.
//  Copyright (c) 2015 PoWWaU. All rights reserved.
//


import UIKit


public class PresenterAnimator3DAltTransform: NSObject {
    let forward: Bool
    
    public init(forward: Bool) {
        self.forward = forward
    }
}


extension PresenterAnimator3DAltTransform: UIViewControllerAnimatedTransitioning {
    
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
        let startFromFrame = transitionContext.initialFrameForViewController(fromViewController)
        let endFromFrame = CGRect(x: startFromFrame.origin.x, y: containerView.bounds.size.height,
            width: startFromFrame.size.width, height: startFromFrame.size.height)
        let endToFrame = transitionContext.finalFrameForViewController(toViewController)
        toView.frame = endToFrame
        
        if transitionContext.isAnimated() {
            let relativeDurationFirstAnimation = 1.0
            let relativeDurationSecondAnimation = 0.8
            
//            var destSnapshotView = toView.snapshotViewAfterScreenUpdates(true)
//            containerView.insertSubview(destSnapshotView, belowSubview:toView)
            containerView.insertSubview(toView, belowSubview:fromView)
            var originalTransform = toView.layer.transform
            

            var perspectiveTransform = CATransform3DIdentity
            perspectiveTransform.m34 = -1.0 / 1000.0
            toView.layer.transform = CATransform3DTranslate(perspectiveTransform, 0.0, 0.0, -100.0)
            
            UIView.animateKeyframesWithDuration(self.transitionDuration(transitionContext),
                delay: 0.0,
                options: .CalculationModeCubic,
                animations: { [unowned self] in
                    UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: relativeDurationFirstAnimation,
                        animations: {
                            fromView.frame = endFromFrame
                    })
                    UIView.addKeyframeWithRelativeStartTime(0.2, relativeDuration: relativeDurationSecondAnimation,
                        animations: {
                            toView.layer.transform = CATransform3DIdentity
                    })
                }, completion: {[unowned self] (finished: Bool) in
                    transitionContext.completeTransition(true)
                })
        } else {
            containerView.addSubview(toView)
        }
    }
    
    
    func animateTransitionBackward(transitionContext: UIViewControllerContextTransitioning, fromViewController: UIViewController, toViewController: UIViewController, fromView: UIView, toView: UIView) {
        let containerView = transitionContext.containerView()
        let endToFrame = transitionContext.finalFrameForViewController(toViewController)

        if transitionContext.isAnimated() {
            let relativeDurationFirstPart = 0.6
            let relativeDurationSecondPart = 1.0 - relativeDurationFirstPart
            let startToFrame = CGRect(x: endToFrame.origin.x, y: containerView.bounds.size.height,
                width: endToFrame.size.width, height: endToFrame.size.height)
            
            var perspectiveTransform = CATransform3DIdentity
            perspectiveTransform.m34 = -1.0 / 1000.0
            toView.frame = transitionContext.finalFrameForViewController(toViewController)
            containerView.addSubview(toView)
            toView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0.0, containerView.bounds.size.height, 0.0)
            UIView.animateKeyframesWithDuration(self.transitionDuration(transitionContext),
                delay: 0.0,
                options: .CalculationModeCubic,
                animations: {
                    UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 1.0, animations: {
                        toView.layer.transform = CATransform3DIdentity
//                        toView.frame = endToFrame
                    })
                    UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration:1.0, animations: {
                        fromView.layer.transform = CATransform3DTranslate(perspectiveTransform, 0.0, 0.0, -100.0)

                    })
                }, completion: { (finished: Bool) in
                    transitionContext.completeTransition(finished)
            })
        } else {
            toView.frame = endToFrame
            containerView.addSubview(toView)
        }
    }
    
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.6
    }
}
