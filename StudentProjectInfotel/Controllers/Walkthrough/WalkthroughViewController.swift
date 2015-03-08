//
//  WalkthroughViewController.swift
//  StudentProjectInfotel
//
//  Created by Rebouh Aymen on 06/02/2015.
//  Copyright (c) 2014 Rebouh Aymen. All rights reserved.
//

/**
  WalkthroughViewController controller. It take care to swipe the differents views during the walkthrough app.
*/
class WalkthroughViewController: UIViewController {
    
    @IBOutlet private weak var myScrollView: UIScrollView!
    @IBOutlet private weak var pageControl: UIPageControl!
    private var previousPage: Int = 0 {
        didSet {
            self.pageControl.currentPage = previousPage
        }
    }
    private let contentView = UIView()

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
        self.navigationController!.navigationBarHidden = true
        self.pageControl.numberOfPages = self.listPages.count
        self.prepareWalkthroughViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    } 
    
    // MARK: - User Interface -
    
    /**
    Prepare dynamicly the walkthrough views ( app presentation ), like the final content size of `myScrollView, the origin of the views, etc..
    So if we want to add another view on our walkthrough, we just add it to `listPages` and on the storyboard.
    
    Copied from an old personal project
    */
    func prepareWalkthroughViews() {
        
        // I use a contentView with the scroll view because of the auto layout.
        var i = CGFloat(self.listPages.count-1)

        // We add the views on the inverse order, like a stack
        self.listPages.reverse().map { currentController -> Void in
            self.contentView.addSubview(currentController.view)
            var currentFrame       = currentController.view.frame
            currentFrame.origin.x  = i-- * currentFrame.width // ex : 6 * 320
            currentController.view.frame = currentFrame
        }
        
        self.myScrollView.addSubview(self.contentView)
        let scrollWidth  = CGFloat(self.listPages.count) * self.view.frame.width
        let scrollHeight = self.myScrollView.frame.height
        self.myScrollView.contentSize = CGSizeMake(scrollWidth, self.contentView.frame.height)
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

        if self.previousPage != page && self.previousPage != NSNotFound {
            self.previousPage = page;
        }
    }
}
