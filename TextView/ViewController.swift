//
//  ViewController.swift
//  TextView
//
//  Created by Plunien, Johannes(AWF) on 11/04/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    dynamic private func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo as? [String : AnyObject] else { return }
        guard let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber else { return }

        UIView.animateWithDuration(duration.doubleValue) {
            self.scrollView.contentInset = UIEdgeInsetsZero
            self.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero
        }
    }

    dynamic private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo as? [String : AnyObject] else { return }
        guard let keyboardFrameValue = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return }
        guard let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber else { return }

        let keyboardFrame = scrollView.convertRect(keyboardFrameValue.CGRectValue(), fromView: nil)
        let intersection = CGRectIntersection(keyboardFrame, scrollView.bounds)
        if CGRectIsNull(intersection) {
            return
        }

        UIView.animateWithDuration(duration.doubleValue) {
            self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, intersection.size.height, 0)
            self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset
        }
    }

}

