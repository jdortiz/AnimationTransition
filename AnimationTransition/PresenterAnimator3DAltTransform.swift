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
        toView.frame = transitionContext.finalFrameForViewController(toViewController)
        containerView.insertSubview(toView, belowSubview:fromView)
        
        if transitionContext.isAnimated() {
            let relativeDurationFirstAnimation = 1.0
            let relativeDurationSecondAnimation = 0.8
            
//            var destSnapshotView = toView.snapshotViewAfterScreenUpdates(true)
//            containerView.insertSubview(destSnapshotView, belowSubview:toView)

            var perspectiveTransform = CATransform3DIdentity
            perspectiveTransform.m34 = -1.0 / 1000.0

            fromView.layer.transform = perspectiveTransform
            toView.layer.transform = CATransform3DTranslate(perspectiveTransform, 0.0, 0.0, -100.0)
            
            UIView.animateKeyframesWithDuration(self.transitionDuration(transitionContext),
                delay: 0.0,
                options: .CalculationModeCubic,
                animations: {
                    UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: relativeDurationFirstAnimation,
                        animations: {
                            fromView.tintAdjustmentMode = .Dimmed
                            fromView.layer.transform = CATransform3DTranslate(perspectiveTransform, 0.0, containerView.bounds.size.height, 0.0)
                    })
                    UIView.addKeyframeWithRelativeStartTime(0.2, relativeDuration: relativeDurationSecondAnimation,
                        animations: {
                            toView.layer.transform = CATransform3DIdentity
                    })
                }, completion: { (finished: Bool) in
                    transitionContext.completeTransition(finished)
                })
        }
    }
    
    
    func animateTransitionBackward(transitionContext: UIViewControllerContextTransitioning, fromViewController: UIViewController, toViewController: UIViewController, fromView: UIView, toView: UIView) {

        let containerView = transitionContext.containerView()
        toView.frame = transitionContext.finalFrameForViewController(toViewController)
        containerView.addSubview(toView)

        if transitionContext.isAnimated() {
            let relativeDurationFirstAnimation = 1.0
            let relativeDurationSecondAnimation = 0.8

            var perspectiveTransform = CATransform3DIdentity
            perspectiveTransform.m34 = -1.0 / 1000.0
            
            toView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0.0, containerView.bounds.size.height, 0.0)

            UIView.animateKeyframesWithDuration(self.transitionDuration(transitionContext),
                delay: 0.0,
                options: .CalculationModeCubic,
                animations: {
                    UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: relativeDurationFirstAnimation,
                        animations: {
                            toView.tintAdjustmentMode = .Automatic
                            toView.layer.transform = CATransform3DIdentity
                    })
                    UIView.addKeyframeWithRelativeStartTime(0.2, relativeDuration:relativeDurationSecondAnimation,
                        animations: {
                            fromView.layer.transform = CATransform3DTranslate(perspectiveTransform, 0.0, 0.0, -100.0)

                    })
                }, completion: { (finished: Bool) in
                    transitionContext.completeTransition(finished)
            })
        } else {
            toView.frame = transitionContext.finalFrameForViewController(toViewController)
            containerView.addSubview(toView)
        }
    }
    
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.6
    }
}
