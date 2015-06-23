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
        case editData = "EditData"
    }


    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let segueIdentifier =  MainSegueIdentifier(rawValue: segue.identifier!) {
            switch (segueIdentifier) {
            case .editData:
                var navigationController = segue.destinationViewController as! UINavigationController
                navigationController.transitioningDelegate = self
                
                // TODO: see what happens if the transition delegate belongs to the MainViewController
            }
        }
    }


    @IBAction func unwindSegueAction(sender: UIStoryboardSegue) {
    }
}


// MARK: - Delegate to provide the transision

extension MainViewController: UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresenterAnimator(forward: true)
    }
    
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresenterAnimator(forward: false)
    }
}
