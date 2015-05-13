//
//  WalkthroughViewController.swift
//  AymenRebouh
//
//  Created by Rebouh Aymen on 06/02/2015.
//  Copyright (c) 2014 Rebouh Aymen. All rights reserved.
//

import UIKit

/**
WalkthroughViewController controller. It take care to swipe the differents views during the walkthrough app.
*/
final class WalkthroughViewController: UIViewController {
  
  @IBOutlet private weak var myScrollView: UIScrollView!
  @IBOutlet private weak var pageControl: UIPageControl!
  private let contentView = UIView()
  
  private var oldPage: Int = 0 {
    didSet {
      self.pageControl.currentPage = self.oldPage
    }
  }
  
  private lazy var listPages: [UIViewController] =
  [
    self.storyboard!.instantiateViewControllerWithIdentifier("PageOne") as! UIViewController,
    self.storyboard!.instantiateViewControllerWithIdentifier("PageTwo") as! UIViewController,
    self.storyboard!.instantiateViewControllerWithIdentifier("PageThree") as! UIViewController,
  ]
  
  // MARK: - Lifecycle -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController!.navigationBarHidden = true
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.prepareWalkthroughViews()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - User Interface -
  
  /**
  Prepare dynamicly the walkthrough views ( app presentation ), like the final content size
  of `myScrollView, the origin of the views, etc..
  So if we want to add another view on our walkthrough, we just add it to `listPages` and on the storyboard.
  
  Copied from an old personal project
  */
  private func prepareWalkthroughViews() {
    
    // I use a contentView with the scroll view because of the auto layout.
    var i = CGFloat(self.listPages.count-1)
    
    // We add the views on the inverse order, like a stack
    for currentController in self.listPages.reverse() {
      self.contentView.addSubview(currentController.view)
      var currentFrame = currentController.view.frame
      currentFrame.origin.x = i-- * CGRectGetWidth(currentFrame) // ex : 6 * 320
      currentController.view.frame = currentFrame
    }
    
    self.myScrollView.addSubview(self.contentView)
    let scrollWidth  = CGFloat(self.listPages.count) * CGRectGetWidth(self.view.bounds)
    let scrollHeight = CGRectGetHeight(self.myScrollView.bounds)
    self.myScrollView.contentSize = CGSize(width: scrollWidth, height: CGRectGetHeight(self.contentView.bounds))
  }
}

// MARK: - UIScrollView Delegate -

extension WalkthroughViewController: UIScrollViewDelegate {
  
  /**
  Change the current page on the page control object
  
  :param: scrollView The walkthrough scroll view. See `myScrollView`
  */
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    let pageWidth      = CGRectGetWidth(self.myScrollView.bounds)
    let currentPage = lroundf(Float(self.myScrollView.contentOffset.x / pageWidth))
    if self.oldPage != currentPage {
      self.oldPage = currentPage;
    }
  }
}
