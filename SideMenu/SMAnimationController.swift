//
//  SMAnimationController.swift
//  SideMenu
//
//  Created by Liliya Sayfutdinova on 17.11.2020.
//

import UIKit

class SMAnimationController: NSObject, UIViewControllerAnimatedTransitioning
{
    static let duration: TimeInterval = 0.35

    private let type: PresentationType
    private let firstViewController: UIViewController
    private let secondViewController: UIViewController

    init?(type: PresentationType, firstViewController: UIViewController, secondViewController: UIViewController) {
        self.type = type
        self.firstViewController = firstViewController
        self.secondViewController = secondViewController
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Self.duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning)
    {
        let containerView = transitionContext.containerView

        let isPresenting = type.isPresenting
        
        guard let toView = secondViewController.view
        else {
            transitionContext.completeTransition(false)
            return
        }

        if (!isPresenting) {
            firstViewController.view.alpha = 1
        }
        
        guard
            let firstViewImageSnapshot = firstViewController.view.snapshotView(afterScreenUpdates: true),
            let secondViewImageSnapshot = secondViewController.view.snapshotView(afterScreenUpdates: true)
            else {
                transitionContext.completeTransition(false)
                return
            }
        
        if (isPresenting) {
            firstViewController.view.alpha = 0
        }
        
        containerView.addSubview(toView)

        [firstViewImageSnapshot, secondViewImageSnapshot].forEach { containerView.addSubview($0) }

        toView.isHidden = true

        var rect = containerView.bounds
        let appScreenRect = UIApplication.shared.keyWindow?.bounds ?? UIWindow().bounds
        firstViewImageSnapshot.frame = appScreenRect
        let minimumSize = min(appScreenRect.width, appScreenRect.height)
        rect.size.width = min(round(minimumSize * 0.75), 300)
        rect.origin.x = isPresenting ? -rect.size.width : 0
        secondViewImageSnapshot.frame = rect
        rect.origin.x = isPresenting ? 0 : -rect.size.width
        secondViewController.view.frame = rect
        
        firstViewImageSnapshot.alpha = isPresenting ? 1 : 0.5
        
        UIView.animateKeyframes(withDuration: Self.duration, delay: 0, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                secondViewImageSnapshot.frame = rect
                firstViewImageSnapshot.alpha = isPresenting ? 0.5 : 1
            }
        }, completion: { _ in
            if (!isPresenting) {
                firstViewImageSnapshot.removeFromSuperview()
            }
            secondViewImageSnapshot.removeFromSuperview()
            toView.isHidden = false
            containerView.bringSubviewToFront(toView)
            transitionContext.completeTransition(true)
        })
    }
}

enum PresentationType
{
    case present
    case dismiss

    var isPresenting: Bool {
        return self == .present
    }
}
