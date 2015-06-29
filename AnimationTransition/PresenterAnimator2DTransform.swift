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
            let relativeDurationFirstAnimation = 0.4
            let relativeDurationSecondAnimation = 1.0
            let containerView = transitionContext.containerView()
            let screenFrame = UIScreen.mainScreen().bounds
            toView.transform = CGAffineTransformTranslate(
                CGAffineTransformScale(CGAffineTransformIdentity,
                    CGFloat(scaleFactor2DForeground), CGFloat(scaleFactor2DForeground)),
                0.0, screenFrame.size.height)
            containerView.addSubview(toView)
            
            UIView.animateKeyframesWithDuration(transitionDuration(transitionContext),
                delay: 0.0,
                options: .CalculationModeCubic,
                animations: {
                    UIView.addKeyframeWithRelativeStartTime(0.0,
                        relativeDuration: relativeDurationFirstAnimation,
                        animations: {
                            fromView.tintAdjustmentMode = .Dimmed
                            fromView.transform = CGAffineTransformScale(CGAffineTransformIdentity,
                                CGFloat(self.scaleFactor2DBackground), CGFloat(self.scaleFactor2DBackground))
                    })
                    UIView.addKeyframeWithRelativeStartTime(0.0,
                        relativeDuration: relativeDurationSecondAnimation,
                        animations: {
                            toView.transform = CGAffineTransformIdentity
                    })
                }, completion: { (finished: Bool) in
                    transitionContext.completeTransition(true)
            })
        } else {
            containerView.addSubview(toView)
        }
    }


    func animateTransitionBackward(transitionContext: UIViewControllerContextTransitioning, fromViewController: UIViewController, toViewController: UIViewController, fromView: UIView, toView: UIView) {
        let containerView = transitionContext.containerView()
        
        if transitionContext.isAnimated() {
            toView.tintAdjustmentMode = .Dimmed
            toView.transform = CGAffineTransformScale(CGAffineTransformIdentity,
                CGFloat(scaleFactor2DBackground), CGFloat(scaleFactor2DBackground))
            containerView.insertSubview(toView, belowSubview:fromView)
            UIView.animateKeyframesWithDuration(transitionDuration(transitionContext),
                delay: 0.0,
                options: .CalculationModeCubic,
                animations: {
                    UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 1.0,
                        animations: {
                            fromView.transform = CGAffineTransformTranslate(
                                CGAffineTransformScale(CGAffineTransformIdentity,
                                    CGFloat(self.scaleFactor2DForeground), CGFloat(self.scaleFactor2DForeground)),
                                0.0, containerView.bounds.size.height)
                    })
                    UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 1.0,
                        animations: {
                            toView.tintAdjustmentMode = .Automatic
                            toView.transform = CGAffineTransformIdentity
                    })
                }, completion: { (finished: Bool) in
                    transitionContext.completeTransition(finished)
            })
        } else {
            toView.frame = transitionContext.finalFrameForViewController(toViewController)
            containerView.insertSubview(toView, belowSubview:fromView)
        }
    }
    
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.6
    }
}
