//
//  ViewController.swift
//  SwipeView
//
//  Created by Rebouh Aymen on 22/08/2014.
//  Copyright (c) 2014 Rebouh Aymen. All rights reserved.
//

import UIKit

/**
*  It take care to swipe the differents views during the walkthrough app.
*/
class WalkthroughViewController: UIViewController {
    
    
    @IBOutlet private weak var myScrollView: UIScrollView!
    @IBOutlet private weak var pageControl: UIPageControl!
    private var previousPage: Int = 0
    
    private lazy var listPages: [UIViewController] =
        [self.storyboard!.instantiateViewControllerWithIdentifier("PagePresentationZero") as UIViewController,
         self.storyboard!.instantiateViewControllerWithIdentifier("PageOne") as UIViewController,
         self.storyboard!.instantiateViewControllerWithIdentifier("PageTwo") as UIViewController]
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        self.prepareWalkthroughViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - 
    
    func prepareWalkthroughViews() {
        
        var i: CGFloat = CGFloat(self.listPages.count-1)
        
        for currentView in reverse(self.listPages) {
            
            /**
                We add the views on the inverse order, like a stack, so the cycles views controller
                will be called ( viewDidLoad, etc .. )
            */
            self.addChildViewController(currentView)
            self.myScrollView.addSubview(currentView.view)
            currentView.didMoveToParentViewController(self)
            
            /**
                We positionnate them on the inverse order too..
            */
            var currentFrame       = currentView.view.frame
            currentFrame.origin.x  = i-- * currentFrame.width// ex : 6 * 320
            currentView.view.frame = currentFrame
        }
        
        self.pageControl.numberOfPages = self.listPages.count
        
        let scrollWidth  = CGFloat(self.listPages.count) * self.view.frame.width
        let scrollHeight = self.myScrollView.frame.height
        self.myScrollView.contentSize = CGSizeMake(scrollWidth, scrollHeight)
        
    }
}

// MARK: - UIScrollView Delegate

extension WalkthroughViewController: UIScrollViewDelegate {
    
    // Changing the current page on the page control object
    func scrollViewDidEndDecelerating(scrollView: UIScrollView!) {

        let pageWidth      = self.myScrollView.frame.size.width
        let fractionalPage = Float(self.myScrollView.contentOffset.x / pageWidth)
        let page           = lroundf(fractionalPage)

        if previousPage != page && previousPage != NSNotFound {
            previousPage = page;
            self.pageControl.currentPage = previousPage
        }
    }
}
