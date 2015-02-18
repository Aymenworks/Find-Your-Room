//
//  WalkthroughViewController.swift
//  StudentProjectInfotel
//
//  Created by Rebouh Aymen on 22/08/2014.
//  Copyright (c) 2014 Rebouh Aymen. All rights reserved.
//

/**
*  WalkthroughViewController controller. It take care to swipe the differents views during the walkthrough app.
*/
class WalkthroughViewController: UIViewController {
    
    @IBOutlet private weak var myScrollView: UIScrollView!
    @IBOutlet private weak var pageControl: UIPageControl!
    private var previousPage: Int = 0
    
    private lazy var listPages: [UIViewController] =
        [
            self.storyboard!.instantiateViewControllerWithIdentifier("PagePresentationZero") as UIViewController,
            self.storyboard!.instantiateViewControllerWithIdentifier("PageOne") as UIViewController,
            self.storyboard!.instantiateViewControllerWithIdentifier("PageTwo") as UIViewController,
            self.storyboard!.instantiateViewControllerWithIdentifier("PageThree") as UIViewController
        ]
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        /* I set it there because the frame bounds is setted there. In the viewDidLoad, that's possible to have it but
           we can have some surprise..
        */
        self.prepareWalkthroughViews()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    } 
    
    // MARK: - User Interface -
    
    /**
    Prepare dynamicly the walkthrough views ( app presentation ), like the final content size of `myScrollView, the origin of the views, etc..
    So if we want to add another view on our walkthrough, we just add it to `listPages` and on the storyboard.
    
    Copied from an old personal project (
    */
    func prepareWalkthroughViews() {
        
        // I use a contentView with the scroll view because of the auto layout.
        let contentView = UIView()
        var i = CGFloat(self.listPages.count-1)
        
        // We iterate each view controller. We add the views on the inverse order, like a stack
        for currentController in reverse(self.listPages) {
            contentView.addSubview(currentController.view)
            var currentFrame       = currentController.view.frame
            currentFrame.origin.x  = i-- * currentFrame.width // ex : 6 * 320
            currentController.view.frame = currentFrame
        }
        
        self.myScrollView.addSubview(contentView)
        self.pageControl.numberOfPages = self.listPages.count        
        let scrollWidth  = CGFloat(self.listPages.count) * self.view.frame.width
        let scrollHeight = self.myScrollView.frame.height
        self.myScrollView.contentSize = CGSizeMake(scrollWidth, contentView.frame.height)
    }
}

// MARK: - UIScrollView Delegate -

extension WalkthroughViewController: UIScrollViewDelegate {
    
    /**
    Change the current page on the page control object
    
    :param: scrollView The walkthrough scroll view. See `myScrollView`
    */
    func scrollViewDidEndDecelerating(scrollView: UIScrollView!) {

        let pageWidth      = self.myScrollView.frame.size.width
        let fractionalPage = Float(self.myScrollView.contentOffset.x / pageWidth)
        let page           = lroundf(fractionalPage) // the closest int

        if previousPage != page && previousPage != NSNotFound {
            previousPage = page;
            self.pageControl.currentPage = previousPage
        }
    }
}
