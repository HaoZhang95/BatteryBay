//
//  MZFRootContainerTransitionContext.swift
//  BatteryBay
//
//  Created by Nguyen Ba Long on 19/04/2018.
//  Copyright © 2018 iosdev. All rights reserved.
//

import UIKit

public protocol MZFRootContainerTransitioningContext: NSObjectProtocol {
    var fromViewController: UIViewController? { get }
    var toViewController: UIViewController? { get }
    
    var containerView: UIView { get }
    
    weak var delegate: MZFRootContainerTransitioningContextDelegate? {get set}
    
    init(_ fromVC: UIViewController?, toVC: UIViewController?, containerView: UIView)
    
    func finishTransition()
    func cancelTransition()
}

public protocol MZFRootContainerTransitioningContextDelegate: NSObjectProtocol {
    func transitionContextDidFinishTransition()
    func transitionContextDidCancelTransition()
}

internal final class MZFRootContainerTransitionContext: NSObject, MZFRootContainerTransitioningContext {
    
    private weak var _fromVC: UIViewController?
    private weak var _toVC: UIViewController?
    private weak var _containerVC: UIView!
    
    var fromViewController: UIViewController? {
        get {
            return _fromVC
        }
    }
    
    var toViewController: UIViewController? {
        get {
            return _toVC
        }
    }
    
    var containerView: UIView {
        get {
            return _containerVC
        }
    }
    
    weak var delegate: MZFRootContainerTransitioningContextDelegate?
    
    init(_ fromVC: UIViewController?, toVC: UIViewController?, containerView: UIView) {
        _fromVC = fromVC
        _toVC = toVC
        _containerVC = containerView
        
        super.init()
    }
    
    func finishTransition() {
        delegate?.transitionContextDidFinishTransition()
    }
    
    func cancelTransition() {
        delegate?.transitionContextDidCancelTransition()
    }
    
}
