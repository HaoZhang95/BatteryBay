//
//  MZFRootContainerViewController.swift
//  BatteryBay
//
//  Created by Nguyen Ba Long on 19/04/2018.
//  Copyright © 2018 iosdev. All rights reserved.
//

import UIKit

open class MZFRootContainerViewController: UIViewController {
    
    open var activatedViewController: UIViewController?
    
    open var deactivatedViewController: UIViewController?
    
    open var transitionAnimator: MZFRootContainerAnimatedTransitioning = TransitionAnimator()
    
    private var transitionContext: MZFRootContainerTransitioningContext!
    
    fileprivate var newViewController: UIViewController?
    
    fileprivate var shouldRetain: Bool = false
    
    public init(rootViewController viewController: UIViewController) {
        super.init(nibName: nil, bundle: nil)
        activatedViewController = viewController
        
        addChildViewController(viewController)
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public final func transition(to newViewController: UIViewController, shouldRetainCurrentViewController retain: Bool) {
        guard let currentViewController = activatedViewController else { return }
        
        self.newViewController = newViewController
        self.shouldRetain = retain
        
        currentViewController.willMove(toParentViewController: nil)
        addChildViewController(newViewController)
        
        if transitionContext == nil {
            transitionContext = MZFRootContainerTransitionContext(currentViewController, toVC: newViewController, containerView: view)
            transitionContext.delegate = self
        }
        
        transitionAnimator.animateTransition(with: transitionContext)
    }
}

extension MZFRootContainerViewController: MZFRootContainerTransitioningContextDelegate {
    public func transitionContextDidFinishTransition() {
        
        activatedViewController?.view.removeFromSuperview()
        activatedViewController?.removeFromParentViewController()
        
        if shouldRetain {
            deactivatedViewController = activatedViewController
        } else {
            activatedViewController = nil
            deactivatedViewController = nil
            
        }
        
        newViewController?.didMove(toParentViewController: self)
        activatedViewController = newViewController
        newViewController = nil
    }
    
    public func transitionContextDidCancelTransition() {
        newViewController?.willMove(toParentViewController: nil)
        newViewController?.view.removeFromSuperview()
        newViewController?.removeFromParentViewController()
        
        deactivatedViewController = nil
        newViewController = nil
        activatedViewController?.didMove(toParentViewController: self)
    }
}

private class TransitionAnimator: NSObject, MZFRootContainerAnimatedTransitioning {
    func transitionDuration() -> TimeInterval {
        return 1.0
    }
    
    func animateTransition(with transitionContext: MZFRootContainerTransitioningContext) {
        guard let fromVC = transitionContext.fromViewController, let toVC = transitionContext.toViewController else {
            transitionContext.cancelTransition()
            return
        }
        
        let duration = transitionDuration()
        let scaleRatio: CGFloat = 1.5
        
        let fromView: UIView! = fromVC.view
        let toView: UIView! = toVC.view
        let containerView = transitionContext.containerView
        
        toView.frame = fromView!.bounds
        toView.alpha = 0
        toView.transform = CGAffineTransform(scaleX: scaleRatio, y: scaleRatio)
        
        containerView.addSubview(toView)
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: .calculationModeLinear, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.4, animations: {
                fromView.alpha = 0
                fromView.transform = CGAffineTransform(scaleX: scaleRatio, y: scaleRatio)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.6, animations: {
                toView.alpha = 1
                toView.transform = CGAffineTransform.identity
            })
            
        }) { completed in
            if completed {
                transitionContext.finishTransition()
            } else {
                transitionContext.cancelTransition()
            }
        }
    }
}
