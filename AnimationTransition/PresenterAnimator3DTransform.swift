//
//  PresenterAnimator3DTransform.swift
//  AnimationTransition
//
//  Created by Jorge D. Ortiz Fuentes on 23/6/15.
//  Copyright (c) 2015 PoWWaU. All rights reserved.
//



import UIKit


public class PresenterAnimator3DTransform: NSObject {
    let forward: Bool
    let π = M_PI
    
    public init(forward: Bool) {
        self.forward = forward
    }
}


extension PresenterAnimator3DTransform: UIViewControllerAnimatedTransitioning {
    
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
            let relativeDurationFirstAnimation = 1.0
            let relativeDurationSecondAnimation = 0.8

            var perspectiveTransform = CATransform3DIdentity
            perspectiveTransform.m34 = -1.0 / 1000.0
            fromView.layer.transform = perspectiveTransform
            toView.frame = transitionContext.finalFrameForViewController(toViewController)
            toView.layer.transform = CATransform3DTranslate(
                CATransform3DTranslate(
                    CATransform3DRotate(
                        perspectiveTransform,
                        CGFloat(self.π / 4.0), 1.0, 0.0, 0.0),
                    0.0, 667.0, 0.0),
                0.0, 0.0, -100.0)
            containerView.addSubview(toView)
            
            UIView.animateKeyframesWithDuration(relativeDurationFirstAnimation * transitionDuration(transitionContext),
                delay: 0.0,
                options: .CalculationModeCubic,
                animations: { [unowned self] in
                    UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: relativeDurationFirstAnimation, animations: {
                        fromView.tintAdjustmentMode = .Dimmed
                        fromView.layer.transform = CATransform3DTranslate(perspectiveTransform, 0.0, 0.0, -200.0)
                    })
                    UIView.addKeyframeWithRelativeStartTime(0.1, relativeDuration: relativeDurationSecondAnimation,
                        animations: {
                            toView.layer.transform = perspectiveTransform
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
        toView.layer.transform = CATransform3DIdentity
        toView.frame = transitionContext.finalFrameForViewController(toViewController)

        if transitionContext.isAnimated() {
            let relativeDurationFirstAnimation = 1.0
            let relativeDurationSecondAnimation = 0.8
            
            containerView.insertSubview(toView, belowSubview:fromView)

            var perspectiveTransform = CATransform3DIdentity
            perspectiveTransform.m34 = -1.0 / 1000.0
            fromView.layer.transform = perspectiveTransform
            toView.layer.transform = CATransform3DTranslate(perspectiveTransform, 0.0, 0.0, -200.0)
            UIView.animateKeyframesWithDuration(self.transitionDuration(transitionContext),
                delay: 0.0,
                options: .CalculationModeCubic,
                animations: {
                    UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: relativeDurationFirstAnimation,
                        animations: {
                            fromView.layer.transform = CATransform3DTranslate(
                                CATransform3DTranslate(
                                    CATransform3DRotate(
                                        perspectiveTransform,
                                        CGFloat(self.π / 4.0), 1.0, 0.0, 0.0),
                                    0.0, containerView.bounds.size.height, 0.0),
                                0.0, 0.0, -100.0)
                    })
                    UIView.addKeyframeWithRelativeStartTime(0.2, relativeDuration: relativeDurationSecondAnimation,
                        animations: {
                        toView.tintAdjustmentMode = .Automatic
                        toView.layer.transform = CATransform3DIdentity
                    })
                }, completion: { (finished: Bool) in
                    transitionContext.completeTransition(finished)
            })
        } else {
            containerView.insertSubview(toView, belowSubview:fromView)
        }
    }


    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.6
    }
}
