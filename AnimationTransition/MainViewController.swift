//
//  ViewController.swift
//  AnimationTransition
//
//  Created by Jorge D. Ortiz Fuentes on 23/6/15.
//  Copyright (c) 2015 PoWWaU. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Parameters & constants
    
    enum MainSegueIdentifier: String {
        case frame2D = "2DFrame"
        case transform2D = "2DTransform"
        case transform3D = "3DTransform"
        case altTransform3D = "3DAltTransform"
    }

    enum TransitionType: Int {
        case Frame2D = 0
        case Transform2D
        case Transform3D
        case AltTransform3D
    }

    var transitionType = TransitionType.Frame2D

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let segueIdentifier =  MainSegueIdentifier(rawValue: segue.identifier!) {
            switch (segueIdentifier) {
            case .frame2D:
                transitionType = .Frame2D
            case .transform2D:
                transitionType = .Transform2D
            case .transform3D:
                transitionType = .Transform3D
            case .altTransform3D:
                transitionType = .AltTransform3D
            }
            var navigationController = segue.destinationViewController as! UINavigationController
            navigationController.transitioningDelegate = self
//            navigationController.modalPresentationStyle = .Custom
            navigationController.modalPresentationCapturesStatusBarAppearance = true
        }
    }


    @IBAction func unwindSegueAction(sender: UIStoryboardSegue) {
    }
}


// MARK: - Delegate to provide the transision

extension MainViewController: UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        var transition: UIViewControllerAnimatedTransitioning
        switch (transitionType) {
        case .Frame2D:
            transition = PresenterAnimator2DFrame(forward: true)
        case .Transform2D:
            transition = PresenterAnimator2DTransform(forward: true)
        case .Transform3D:
            transition = PresenterAnimator3DTransform(forward: true)
        case .AltTransform3D:
            transition = PresenterAnimator3DAltTransform(forward: true)
        }
        return transition
    }
    
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        var transition: UIViewControllerAnimatedTransitioning
        switch (transitionType) {
        case .Frame2D:
            transition = PresenterAnimator2DFrame(forward: false)
        case .Transform2D:
            transition = PresenterAnimator2DTransform(forward: false)
        case .Transform3D:
            transition = PresenterAnimator3DTransform(forward: false)
        case .AltTransform3D:
            transition = PresenterAnimator3DAltTransform(forward: false)
        }
        return transition
    }
}
