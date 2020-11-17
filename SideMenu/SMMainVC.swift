//
//  SMMainVC.swift
//  SideMenu
//
//  Created by Liliya Sayfutdinova on 16.11.2020.
//

import UIKit

class SMMainVC: UIViewController {

    var animationController: SMAnimationController?
    @IBOutlet weak var lblNumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblNumber.text = "0"
        addScreenEdgePanGestureRecognizer()
        addPanGestureRecognizer()
        addObservers()
    }
    
    @IBAction func presentMenuViewController(_ sender: Any) {
        let menuViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SMNavigationVC")

        menuViewController.transitioningDelegate = self
        menuViewController.modalPresentationStyle = .fullScreen
        present(menuViewController, animated: true)
    }

    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(onSelectNotification), name: Notification.Name(SMTableVC.selectedNotification), object: nil)
    }
    
    @objc func onSelectNotification(notification: NSNotification) {
        guard let number = notification.userInfo?[SMTableVC.selectedNumberKey]
        else {
            return
        }
        self.lblNumber.text = "\(number)"
    }
}

// GestureRecognizers
extension SMMainVC
{
    func addScreenEdgePanGestureRecognizer() {
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
            edgePan.edges = .left
        self.view.addGestureRecognizer(edgePan)
    }
    
    @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            presentMenuViewController(self)
        }
    }
    
    func addPanGestureRecognizer() {
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(handlePan(recognizer:)))
        self.view.addGestureRecognizer(pan)
    }
    
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .ended {
            if recognizer.xVelocity > 0 && abs(recognizer.yVelocity) < 30 {
                presentMenuViewController(self)
            }
        }
    }
}

extension SMMainVC: UIViewControllerTransitioningDelegate
{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animationController = SMAnimationController(type: .present, firstViewController: presenting, secondViewController: presented)
        return animationController
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let firstViewController = self.navigationController
        else { return nil }
        animationController = SMAnimationController(type: .dismiss, firstViewController: firstViewController, secondViewController: dismissed)
        return animationController
    }
}

