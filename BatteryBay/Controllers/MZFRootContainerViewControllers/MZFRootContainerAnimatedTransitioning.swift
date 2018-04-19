//
//  MZFRootContainerAnimatedTransitioning.swift
//  BatteryBay
//
//  Created by Nguyen Ba Long on 19/04/2018.
//  Copyright © 2018 iosdev. All rights reserved.
//

import Foundation
import UIKit

public protocol MZFRootContainerAnimatedTransitioning {
    func transitionDuration() -> TimeInterval
    func animateTransition(with transitionContext: MZFRootContainerTransitioningContext)
}
