//
//  MWTabView.swift
//  Tabs
//
//  Created by Mathieu White on 2015-05-29.
//  Copyright (c) 2015 Mathieu White. All rights reserved.
//


import UIKit

/**
*  The MWTabViewDataSource protocol is adopted by an object that mediates the application's
data model for a MWTabView object. The data source provides the tab view with the information
it needs to construct a tab view.

As a representative of the data model, the data source supplies minimal information about the
tab view’s appearance. The tab view object’s MWTabViewDelegate provides that information.

The required methods of the protocol provide the views to be displayed by the tab view as well
as inform the MWTabView object about the number of tabs it will contain. The data source may
implement optional methods to configure various aspects of the tab view
*/
public protocol MWTabViewDataSource: NSObjectProtocol {
    /**
    Tells the data source to return the number of tabs for the tab view. (required)
    
    - parameter tabView: the tab view object requesting the number of tabs
    
    - returns: the number of tabs in tabView. The default value is 1
    */
    func numberOfTabsInTabView(tabView: MWTabView) -> UInt
    
    /**
    Asks the data source for the view to insert at a particular index of the tab view. (required)
    
    - parameter tabView: the tab view object requesting the view
    - parameter index:   the index of the view in the tab view
    
    - returns: an object inheriting from UIView that the tab view can use for the specified index.
              An assertion is raised if you return nil
    */
    func tabView(tabView: MWTabView, viewForTabAtIndex index: UInt) -> UIView
    
    /**
    Asks the data source for the title of the tab for the specified index of the tab view.
    
    - parameter tabView: the tab view object asking for the title
    - parameter index:   the index number identifying a tab in the tab view
    
    - returns: a string to use as the title for the tab.
    */
    func tabView(tabView: MWTabView, titleForTabAtIndex index: UInt) -> String
}


/**
*  The delegate of a MWTabView object must adopt the MWTabViewDelegate protocol.
   Optional methods of the protocol allow the delegate to manage color and size attributes
   and perform other actions.
*/
public protocol MWTabViewDelegate: NSObjectProtocol {
    /**
    Asks the delegate to return the height of the header for the tab view.
    
    - parameter tabView: the tab view object requesting the height for the header
    
    - returns: the height of the header in tabView.
    */
    func heightForHeaderInTabView(tabView: MWTabView) -> CGFloat
    
    /**
    Asks the delegate to return the width of the header titles for the tab view.
    
    - parameter tabView: the tab view object requesting the width for the header
    
    - returns: the width of the header titles in tabView. The default value is 
              half the device's width.
    */
    func widthForTitlesInTabView(tabView: MWTabView) -> CGFloat
    
    /**
    Tells the delegate that the specified tab is now selected.
    
    - parameter tabView: the tab view object informing the delegate about the new tab selection
    - parameter index:   the index of the new tab selected in tabView
    */
    func tabView(tabView: MWTabView, didSelectTabAtIndex index: UInt)
    
    /**
    Tells the delegate the the tab view scrolling animation will begin.
    
    - parameter tabView: the tab view object that is performing the scrolling animation
    - parameter index:   the index of the visible tab before the scrolling animation
    */
    func tabViewWillBeginScrollingAnimation(tabView: MWTabView, fromVisibleTabAtIndex index: UInt)
    
    /**
    Tells the delegate that the tab view scrolling animation has ended.
    
    - parameter tabView: the tab view object that is performing the scrolling animation
    - parameter index:   the index of the visible tab after the scrolling animation
    */
    func tabViewDidEndScrollingAnimation(tabView: MWTabView, onVisibleTabAtIndex index: UInt)
    
    /**
    Tells the delegate when the user finished dragging the content.
    
    - parameter tabView:  the tab view object where the user ended the touch
    - parameter velocity: the velocity of the tab view (in points) at the moment the touch was released
    - parameter index:    the expected centered index when the scrolling action decelerates to a stop
    */
    func tabViewWillEndDragging(tabView: MWTabView, withHorizontalVelocity velocity: CGFloat, targetTabAtIndex index: UInt)
    
    /**
    Tells the delegate that a scroll view in the tab view object is scrolling its content.
    
    - parameter tabView:             the tab view object performing the scrolling animation
    - parameter offsetMultiplier:    the offset multiplier of the tab view's content
    - parameter velocity:            the velocity of the pan gesture on the tab view
    */
    func tabView(tabView: MWTabView, didScrollWithOffsetMultiplier offsetMultiplier: CGFloat, horizontalVelocity velocity: CGFloat)
    
    /**
    Tells the delegate that the tab view did layout its subviews.
    
    - parameter tabView:   the tab view object that is laying out subviews
    */
    func tabViewDidLayoutSubviews(tabView: MWTabView)
    
    /**
    Asks the delegate if the tab view should recycle its views.
    
    - parameter tabView: the tab view object requesting this information
    
    - returns: true if views should be recycled, false if views should always be loaded.
              the value is true by default
    */
    func tabViewShouldRecycleViews(tabView: MWTabView) -> Bool
}


// Optional MWTabViewDelegate Methods
public extension MWTabViewDelegate {
    func tabView(tabView: MWTabView, didSelectTabAtIndex index: UInt) { }
    func tabViewWillBeginScrollingAnimation(tabView: MWTabView, fromVisibleTabAtIndex index: UInt) { }
    func tabViewDidEndScrollingAnimation(tabView: MWTabView, onVisibleTabAtIndex index: UInt) { }
    func tabViewWillEndDragging(tabView: MWTabView, withHorizontalVelocity velocity: CGFloat, targetTabAtIndex index: UInt) { }
    func tabView(tabView: MWTabView, didScrollWithOffsetMultiplier offsetMultiplier: CGFloat, horizontalVelocity velocity: CGFloat) { }
    func tabViewDidLayoutSubviews(tabView: MWTabView) { }
}



/**
*  The attributes of the tab view object.
*/
struct Attributes {
    // Attributes from the data source
    var numberOfTabs: UInt = 1
    var views: [UIView?] = []
    var titles: [String] = []
    var titleLabels: [UILabel?] = []
    
    // Attributes from the delegate
    var headerHeight: CGFloat = 44.0
    var titleWidth: CGFloat = CGRectGetWidth(UIScreen.mainScreen().bounds) / 2.0
    var shouldRecycleViews: Bool = true
    
    // Other Attributes
    var pageWidth: CGFloat = 0.0
    var tabIndicatorHeight: CGFloat = 8.0
}


public class MWTabView: UIView, UIScrollViewDelegate {
    
    // MARK: - Constants
    
    // MARK: - Read Only
    
    /// Read only variable that that returns the tab view's header indicator height.
    internal var tabIndicatorHeight: CGFloat {
        return self.attributes.tabIndicatorHeight
    }

    /// Read only variable that returns the gestures of the tab view object in an array.
    internal var gestures: [UIGestureRecognizer?] {
        return [self.headerScrollView?.panGestureRecognizer, self.pageScrollView?.panGestureRecognizer]
    }
    
    
    // MARK: - Variables
    
    /// The Tab View's attributes.
    private var attributes: Attributes = Attributes()

    /// The scroll view container for the header of the Tab View.
    private weak var headerScrollViewContainer: MWTabViewScrollContainer?
    
    /// The header's scroll view.
    private weak var headerScrollView: UIScrollView?
    
    /// The header's content view.
    private weak var headerContentView: UIView?
    
    /// The main scroll view that holds the pages.
    private weak var pageScrollView: UIScrollView?
    
    /// The main scroll view's content view.
    private weak var pageContentView: UIView?
    
    /// The Tab View's background view.
    private weak var backgroundView: UIView?
    
    /// Indicates when the scrolling animation has completed.
    private var didEndScrollingAnimation: Bool = false
    
    /// Indicates if the touch is on the header.
    private var isScrollingHeader: Bool = false
    
    /// Indicates if the touch is on the main scroll view.
    private var isScrollingPage: Bool = false
    
    /// Indicates if the auto layout constraints have been setup.
    private var hasSetupConstraints: Bool = false
    
    /// The gradient layer of the tab view's header.
    private var headerGradient: CAGradientLayer?
    
    /// The text color of the tab titles.
    var titleColor: UIColor = UIColor.blackColor() {
        didSet {
            for title in self.attributes.titleLabels {
                title?.textColor = titleColor
            }
        }
    }
    
    /// The font for the tab titles.
    var titleFont: UIFont = UIFont.systemFontOfSize(18.0) {
        didSet {
            for title in self.attributes.titleLabels {
                title?.font = titleFont
            }
        }
    }
    
    /// The minimum alpha value for the tab titles.
    var titleAlphaMin: CGFloat = 0.4 {
        didSet {
            if (titleAlphaMin < 0.0) {
                titleAlphaMin = 0.4
            }
                
            for title in self.attributes.titleLabels {
                title?.alpha = titleAlphaMin
            }
        }
    }
    
    /// The maximum alpha value for the tab titles.
    var titleAlphaMax: CGFloat = 1.0 {
        didSet {
            if (titleAlphaMax > 1.0) {
                titleAlphaMax = 1.0
            }
            
            for title in self.attributes.titleLabels {
                title?.alpha = titleAlphaMax
            }
        }
    }
    
    /// The background color of the tab view's header. If a gradient is set, this will be ignored.
    var headerColor: UIColor = UIColor.clearColor() {
        didSet {
            self.headerScrollViewContainer?.backgroundColor = headerColor
        }
    }
    
    /// The delegate of the tab view.
    public weak var delegate: MWTabViewDelegate?
    
    /// The data source of the tab view.
    public weak var dataSource: MWTabViewDataSource?
    
    
    // MARK: - Initialization
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initTabView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initTabView()
    }
    
    convenience init() {
        self.init(frame: CGRectZero)
    }
    
    /**
    This method handles the main initialization of the tab view object.
    */
    private func initTabView() {
        // Require auto layout
        self.translatesAutoresizingMaskIntoConstraints = false
        
        // Initialize the scroll views
        self.setupScrollViews()
    }
    
    /**
    This method initializes the scroll views for the tab section and
    the content pages used by the tab view object.
    */
    private func setupScrollViews() {
        
        // Initialize our scroll view for the header
        let headerScrollView: UIScrollView = UIScrollView()
        //headerScrollView.bounces = false
        headerScrollView.pagingEnabled = true
        headerScrollView.clipsToBounds = false
        headerScrollView.directionalLockEnabled = true
        headerScrollView.minimumZoomScale = 1.0
        headerScrollView.maximumZoomScale = 1.0
        headerScrollView.scrollsToTop = false
        headerScrollView.showsHorizontalScrollIndicator = false
        headerScrollView.showsVerticalScrollIndicator = false
        headerScrollView.translatesAutoresizingMaskIntoConstraints = false
        headerScrollView.delegate = self
        
        // Inintialize the container for the header scroll view
        let headerScrollViewContainer: MWTabViewScrollContainer = MWTabViewScrollContainer()
        headerScrollViewContainer.scrollView = headerScrollView
        headerScrollViewContainer.tabIndicatorHeight = CGFloat(self.tabIndicatorHeight)
        headerScrollViewContainer.translatesAutoresizingMaskIntoConstraints = false
        
        // Initialize a tap gesture recognizer for the header scroll view container
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MWTabView.tappedInTabViewHeader(_:)))
        tapGesture.numberOfTapsRequired = 1
        headerScrollViewContainer.addGestureRecognizer(tapGesture)
        
        // Initialize our content view for the header scroll view
        let headerContentView: UIView = UIView()
        headerContentView.translatesAutoresizingMaskIntoConstraints = false
        
        // Initialize our scroll view for the pages
        let pageScrollView: UIScrollView = UIScrollView()
        //pageScrollView.bounces = false
        pageScrollView.pagingEnabled = true
        pageScrollView.directionalLockEnabled = true
        pageScrollView.minimumZoomScale = 1.0
        pageScrollView.maximumZoomScale = 1.0
        pageScrollView.scrollsToTop = false
        pageScrollView.showsHorizontalScrollIndicator = false
        pageScrollView.showsVerticalScrollIndicator = false
        pageScrollView.translatesAutoresizingMaskIntoConstraints = false
        pageScrollView.delegate = self
        
        // Initialize our content view for the pages scroll view
        let pageContentView: UIView = UIView()
        pageContentView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add each content view to its scroll view
        headerScrollView.addSubview(headerContentView)
        pageScrollView.addSubview(pageContentView)
        
        // Add the header scroll view to its container
        headerScrollViewContainer.addSubview(headerScrollView)
        
        // Add each component to the view
        self.addSubview(pageScrollView)
        self.addSubview(headerScrollViewContainer)
        
        // Set each component to its variable
        self.headerScrollViewContainer = headerScrollViewContainer
        self.headerScrollView = headerScrollView
        self.pageScrollView = pageScrollView
        self.headerContentView = headerContentView
        self.pageContentView = pageContentView
    }
    
    /**
    This method is called when the tab view object is added or removed from a superview.
    */
    override public func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        // The tab view is about to be added to a superview
        if (superview == nil) {
            // Load the tab view's data
            self.reloadData()
        }
    }
    
    
    // MARK: - Instance Methods: Reloading Data
    
    /**
        Reloads the tabs and views of the tab view.
        Call this method to reload all the data that is used to construct the tab view,
        including number of tabs, the views for each tab, and so on.
    */
    func reloadData() {
        // Ask the delegate for new view attributes
        self.reloadTitleWidth()
        self.reloadHeaderHeight()
        
        // Ask the delegate if we should recycle the views
        if let shouldRecycle = self.delegate?.tabViewShouldRecycleViews(self) {
            self.attributes.shouldRecycleViews = shouldRecycle
        }
        
        // Ask the data source for new data
        self.reloadNumberOfTabs()
        
        self.clearTabLabels()
        for _ in 0 ..< self.attributes.numberOfTabs {
            self.attributes.titleLabels.append(nil)
        }
        
        self.clearTabPages()
        for _ in 0 ..< self.attributes.numberOfTabs {
            self.attributes.views.append(nil)
        }
        
        // If the tab view's constraints have been setup, we can load our pages
        if (self.hasSetupConstraints == true) {
            self.loadVisiblePages()
            self.applyTabTitleEffects()
        }
    }
    
    private func clearTabLabels() {
        // Remove our labels
        for label in self.attributes.titleLabels {
            label?.removeFromSuperview()
        }
        
        // Set our title labels array to nil
        self.attributes.titleLabels.removeAll(keepCapacity: false)
    }
    
    private func clearTabPages() {
        // Remove our views
        for view in self.attributes.views {
            view?.removeFromSuperview()
        }
        
        // Set our views array to nil
        self.attributes.views.removeAll(keepCapacity: false)
    }
    
    /**
    This method asks the data source for the number of tabs in the tab view object.
    */
    private func reloadNumberOfTabs() {
        // Get the number of tabs
        if let numberOfTabs = self.dataSource?.numberOfTabsInTabView(self) {
            self.attributes.numberOfTabs = numberOfTabs
        }
    }
    
    /**
    This method asks the delegate for the width of the header titles.
    */
    private func reloadTitleWidth() {
        // Get the tab section height
        if let width = self.delegate?.widthForTitlesInTabView(self) {
            self.attributes.titleWidth = width
        }
    }
    
    /**
    This method asks the delegate for the height of the header in which the tab titles are displayed.
    */
    private func reloadHeaderHeight() {
        // Get the tab section height
        if let height = self.delegate?.heightForHeaderInTabView(self) {
            self.attributes.headerHeight = height
        }
    }
    
    
    // MARK: - Instance Methods: Displaying Views
    
    /**
    This method loads the visible pages in our tab view based on the content offset
    of the page's scroll view.
    */
    private func loadVisiblePages() {
        // Our page width is 0, so we shouldn't load anything
        if (self.attributes.pageWidth == 0.0) {
            return
        }
        
        // The tab view should recycle its views
        if (self.attributes.shouldRecycleViews == true) {
            // Determine which page is currently visible
            let pageWidth: CGFloat = self.attributes.pageWidth
            let pageIndex: Int = Int(floor(((self.pageScrollView?.contentOffset.x ?? 0.0) * 2.0 + pageWidth) / (pageWidth * 2.0)))
            
            // Configure the pages to load
            let firstPage: Int = (pageIndex - 1 < 0) ? 0 : pageIndex - 1
            let lastPage: Int = (pageIndex + 1 == Int(self.attributes.numberOfTabs)) ? Int(self.attributes.numberOfTabs) - 1 : pageIndex + 1
            
            // Recycle anything before the first tab
            for index in 0 ..< firstPage {
                self.unloadPage(atIndex: UInt(index))
            }
            
            // Load the tabs in our range
            for index in firstPage ... lastPage {
                self.loadPage(atIndex: UInt(index))
            }
            
            // Recycle anything after the last tab
            for index in lastPage + 1 ..< Int(self.attributes.numberOfTabs) {
                self.unloadPage(atIndex: UInt(index))
            }
        }
        else {
            // The tab view should load all its views
            // loop through and load them all
            for i in 0 ..< self.attributes.numberOfTabs {
                self.loadPage(atIndex: i)
            }
        }
    }
    
    /**
    This method will load a page in the tab view when it is needed for display.
    
    - parameter index: the index of the tab view's page to load
    */
    private func loadPage(atIndex index: UInt) {
        // If our index is outside of the range to display, do nothing
        if (index < 0 || index > self.attributes.numberOfTabs) {
            return
        }
        
        // If the tab title is already loaded, do nothing
        if let _ = self.attributes.titleLabels[Int(index)] {
            // Nothing to do since the tab is already loaded
        }
        else {
            // If the data source does not exist, do nothing
            if (self.dataSource == nil) {
                return
            }
            
            // Ask the data source for the tab title at the specified index
            let tabTitle: String = self.dataSource!.tabView(self, titleForTabAtIndex: index)
            
            // Create our label to display
            let label: UILabel = self.generateTabTitle(tabTitle: tabTitle, atIndex: index)
            
            // Add the label to our content view
            self.headerContentView?.addSubview(label)
            
            // Layout the label in the scroll view
            self.setupConstraints(forTitleLabel: label, atIndex: index)
            
            // Add the label to our array
            self.attributes.titleLabels[Int(index)] = label
        }
        
        // If the page for the tab is already loaded, do nothing
        if let _ = self.attributes.views[Int(index)] {
            // Nothing to do since the view is already loaded
        }
        else {
            // If the data source does not exist, do nothing
            if (self.dataSource == nil) {
                return
            }
            
            // Ask the data source for the view at the specified index
            let view: UIView = self.dataSource!.tabView(self, viewForTabAtIndex: index)
            view.translatesAutoresizingMaskIntoConstraints = false
            
            // Add the view to our content view
            self.pageContentView?.addSubview(view)
            
            // Layout the view in the scroll view
            self.setupConstraints(forPageView: view, atIndex: index)
            
            // Add the view to our array
            self.attributes.views[Int(index)] = view
        }
    }
    
    /**
    This method will unloads a page from the tab view when it is no longer in use.
    
    - parameter index: the index of the tab view's page to unload
    */
    private func unloadPage(atIndex index: UInt) {
        // If our index is outside of the range to display, do nothing
        if (index < 0 || index > self.attributes.numberOfTabs) {
            return
        }
        
        // Unload the title label from the scroll view and remove it from the title labels array
        if let titleLabel = self.attributes.titleLabels[Int(index)] {
            titleLabel.removeFromSuperview()
            self.attributes.titleLabels[Int(index)] = nil
        }
        
        // Unload the page from the scroll view and remove it from the views array
        if let pageView = self.attributes.views[Int(index)] {
            pageView.removeFromSuperview()
            self.attributes.views[Int(index)] = nil
        }
    }
    
    /**
    This method creates a UILabel that will be used to display in the header view
    as the titles for each page of the tab view.
    
    - parameter title: the title of the label
    
    - returns: a formatted UILabel ready to display with the title passed in
    */
    private func generateTabTitle(tabTitle title: String, atIndex index: UInt) -> UILabel {
        // Initialize the label
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // Format the label
        label.textColor = self.titleColor
        label.textAlignment = NSTextAlignment.Center
        label.font = self.titleFont
        label.alpha = self.titleAlphaMin
        
        // Set our title as the label's text
        label.text = title
        
        return label
    }
    
    /**
    This method applies effects on the tab titles as they are scrolling
    giving the center tab a higher alpha value than the outside tabs.
    */
    private func applyTabTitleEffects() {
        // If the constraints haven't been setup yet, ask the header 
        // scroller view to layout its constraints.
        if (self.hasSetupConstraints == false) {
            self.headerScrollView?.setNeedsLayout()
            self.headerScrollView?.layoutIfNeeded()
        }
        
        // Calculate the visible center of the scroll view
        let xOffset: CGFloat = self.headerScrollView?.contentOffset.x ?? 0.0
        let width: CGFloat = CGRectGetWidth(self.headerScrollView?.bounds ?? CGRectZero)
        let center: CGFloat = xOffset + (width / 2.0)
        
        // Loop through the title labels
        for title in self.attributes.titleLabels {
            // Only apply the transformation to the visible title labels
            if let title = title {
                // Ask the title to layout its constraints to get its center
                title.setNeedsLayout()
                title.layoutIfNeeded()
                
                // Calculate our normalized value between 0 and 1
                let normalization: CGFloat = abs(center - title.center.x) / width
                
                // Get the alpha value for the title
                let titleAlpha: CGFloat = abs(normalization - 1.0)
                
                // Set the title's alpha value
                title.alpha = min(max(titleAlpha, self.titleAlphaMin), self.titleAlphaMax)
            }
        }
    }
    
    /**
    This method renders the gradient on the tab view's header.
    */
    private func renderTabViewHeaderGradient() {
        if let gradient = self.headerGradient {
            gradient.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.bounds), CGFloat(self.attributes.headerHeight))
            self.headerScrollViewContainer?.layer.insertSublayer(gradient, atIndex: 0)
        }
    }
    
    
    // MARK: - Instance Methods: Private
    
    /**
    This method resets the states of the scroll views.
    */
    private func scrollViewAnimationEnded() {
        self.didEndScrollingAnimation = false
        self.isScrollingHeader = false
        self.isScrollingPage = false
        self.headerScrollViewContainer?.dragging = false
        self.headerScrollViewContainer?.userInteractionEnabled = true
        self.pageScrollView?.userInteractionEnabled = true

        // Notify the delegate that the tab view did end scrolling
        self.delegate?.tabViewDidEndScrollingAnimation(self, onVisibleTabAtIndex: self.indexForCurrentTab())
    }
    
    
    // MARK: Instance Methods: Public
    
    /**
    This method scrolls the tab view to the index passed in.
    
    - parameter index: the index to scroll to
    - parameter animated: true to animate the scroll, false otherwise
    */
    func scrollToTab(atIndex index: UInt, animated: Bool) {
        // If our index is outside of the range to display, do nothing
        if (index < 0 || index >= self.attributes.numberOfTabs) {
            return
        }
        
        // Disable the interaction until scrolling has ended
        self.headerScrollViewContainer?.userInteractionEnabled = false
        
        // Calculate our xOffset
        let xOffset: CGFloat = CGFloat(index) * CGFloat(self.attributes.titleWidth)
        
        // Initialize our content offset
        let contentOffset: CGPoint = CGPointMake(xOffset, self.headerScrollView?.contentOffset.y ?? 0.0)
        
        // Mark that we will be scrolling the header
        self.isScrollingHeader = true
        
        // Set the proper content offset of the header scroll view animated
        self.headerScrollView?.setContentOffset(contentOffset, animated: animated)
        
        // If there's no animation, we have to set the content offset of the page scroll view as well
        if (animated == false) {
            // Reset properties
            self.isScrollingHeader = false
            self.headerScrollViewContainer?.userInteractionEnabled = true
        }
    }
    
    
    // MARK: - Setters
    
    /**
    This method sets the gradient from top to bottom on the tab view's header.
    
    - parameter colors:    the array of colors for our gradient
    - parameter locations: the array of locations for our gradient
    */
    @nonobjc public func setGradientForTabViewHeader(colors colors: [CGColor]) {
        self.headerGradient?.removeFromSuperlayer()
            
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        
        self.headerGradient = gradientLayer
        
        self.renderTabViewHeaderGradient()
    }
    
    /**
    This method sets the background view for the tab view's page scroller.
    If the view passed in is nil, the background view will be removed.
    
    - parameter view: the view to set as the background
    */
    public func setTabViewBackground(view view: UIView?) {
        if (self.backgroundView != nil) {
            if (view != nil) {
                // The background view already exists, let's replace it
                self.backgroundView = view
            }
            else {
                // Remove the background, because the view passed in was nil
                self.backgroundView?.removeFromSuperview()
                self.backgroundView = nil
            }
        }
        else {
            // Create the background view and set it as the page view background
            view?.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view!)
            self.sendSubviewToBack(view!)
            
            // Layout the view horizontally
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[_bg]|",
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: nil,
                views: ["_bg" : view!]))
            
            // Layout the view vertically
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[_bg]|",
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: nil,
                views: ["_bg" : view!]))
            
            // Set the background view variable
            self.backgroundView = view
        }
    }
    
    
    // MARK: - Getters
    
    /**
    This method returns the index of the current tab being displayed in the tab view.
    
    - returns: the index of the current tab being displayed
    */
    func indexForCurrentTab() -> UInt {
        if let xOffset = self.pageScrollView?.contentOffset.x {
            let currentIndex = xOffset / self.attributes.pageWidth
            if (currentIndex >= 0) {
                return UInt(currentIndex)
            }
        }
    
        return 0
    }
    
    /**
    This method returns the view for the tab index passed in.
    
    - parameter index: the index of the view to get
    
    - returns: the view of the specified index. Returns nil if the index doesn't exist
    */
    func viewForTabAtIndex(index: UInt) -> UIView? {
        if (index < self.attributes.numberOfTabs) {
            return self.attributes.views[Int(index)]
        }
        
        return nil
    }
    
    
    // MARK: - Auto Layout

    override public class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if (self.hasSetupConstraints == false) {
            self.setupConstraints()
            self.loadVisiblePages()
            self.applyTabTitleEffects()
        
            self.renderTabViewHeaderGradient()
            
            self.pageScrollView?.setNeedsLayout()
            self.pageScrollView?.layoutIfNeeded()
            
            self.hasSetupConstraints = true
            
            // Notify the delegate that the tab view did layout its subviews
            self.delegate?.tabViewDidLayoutSubviews(self)
        }
    }
    
    /**
    This method sets up the main constraints for the tab view.
    */
    private func setupConstraints() {
        // Views Dictionary
        var viewsDict: [String : AnyObject] = [String : AnyObject]()
        viewsDict["_headScroll"] = self.headerScrollView
        viewsDict["_headContent"] = self.headerContentView
        viewsDict["_headContainer"] = self.headerScrollViewContainer
        viewsDict["_pageScroll"] = self.pageScrollView
        viewsDict["_pageContent"] = self.pageContentView
        
        // Metrics Dictionary
        var metricsDict: [String : AnyObject] = [String : AnyObject]()
        metricsDict["_headMargin"] = (CGRectGetWidth(self.bounds) - CGFloat(self.attributes.titleWidth)) / 2.0
        metricsDict["_headHeight"] = self.attributes.headerHeight
        metricsDict["_headWidth"] = CGFloat(self.attributes.numberOfTabs) * self.attributes.titleWidth
        metricsDict["_pageWidth"] = CGFloat(self.attributes.numberOfTabs) * CGRectGetWidth(self.bounds)
        metricsDict["_spacing"] = -(self.tabIndicatorHeight)
        
        // Add the constraints to the header container view
        self.setupHeaderScrollViewContainerConstraints(viewsDict, metricsDict: metricsDict)
        
        // Add the constraints to the header scroll view
        self.setupHeaderScrollViewConstraints(viewsDict, metricsDict: metricsDict)
        
        // Add the constraints to the page scroll view
        self.setupPageScrollViewConstraints(viewsDict, metricsDict: metricsDict)
        
        // Add the constraints to the tab view
        self.setupTabViewConstraints(viewsDict, metricsDict: metricsDict)
        
        // Force layout of our page content view so we can get the width
        self.pageContentView?.setNeedsLayout()
        self.pageContentView?.layoutIfNeeded()
        
        // Calculate the width for each page
        let pageWidth: CGFloat = CGRectGetWidth(self.pageContentView!.bounds) / CGFloat(self.attributes.numberOfTabs)
        
        // Store our page width
        self.attributes.pageWidth = pageWidth
    }
    
    /**
    This method will set up the constraint based layout for the header scroll view inside the
    header scroll view container.
    
    - parameter viewsDict:   the views dictionary for the constraints
    - parameter metricsDict: the metrics dictionary for the constraints
    */
    private func setupHeaderScrollViewContainerConstraints(viewsDict: [String : AnyObject], metricsDict: [String : AnyObject]) {
        // Horizontal constraints for the scroll view inside the container view
        let horizontalConstraints: [NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(_headMargin)-[_headScroll]-(_headMargin)-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: metricsDict,
            views: viewsDict)
        
        // Vertical constraints for the scroll view inside the container view
        let verticalConstraints: [NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("V:|[_headScroll]|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: viewsDict)
        
        // Add the constraints to the header container view
        self.headerScrollViewContainer?.addConstraints(horizontalConstraints)
        self.headerScrollViewContainer?.addConstraints(verticalConstraints)
    }
    
    /**
    This method will set up the constraint based layout for the content view inside the
    header scroll view.
    
    - parameter viewsDict:   the views dictionary for the constraints
    - parameter metricsDict: the metrics dictionary for the constraints
    */
    private func setupHeaderScrollViewConstraints(viewsDict: [String : AnyObject], metricsDict: [String : AnyObject]) {
        // Horizontal constraints for the content view inside the scroll view
        let horizontalConstraints: [NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("H:|[_headContent(_headWidth)]|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: metricsDict,
            views: viewsDict)
        
        // Vertical constraints for the content view inside the scroll view
        let verticalConstraints: [NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("V:|[_headContent(==_headScroll)]|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: viewsDict)
        
        // Add the constraints to the header scroll view
        self.headerScrollView?.addConstraints(horizontalConstraints)
        self.headerScrollView?.addConstraints(verticalConstraints)
    }
    
    /**
    This method will set up the constraint based layout for the content view inside the
    page scroll view.
    
    - parameter viewsDict:   the views dictionary for the constraints
    - parameter metricsDict: the metrics dictionary for the constraints
    */
    private func setupPageScrollViewConstraints(viewsDict: [String : AnyObject], metricsDict: [String : AnyObject]) {
        // Horizontal constraints for the content view inside the scroll view
        let horizontalConstraints: [NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("H:|[_pageContent(_pageWidth)]|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: metricsDict,
            views: viewsDict)
        
        // Vertical constraints for the content view inside the scroll view
        let verticalConstraints: [NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("V:|[_pageContent(==_pageScroll)]|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: viewsDict)
        
        // Add the constraints to the page scroll view
        self.pageScrollView?.addConstraints(horizontalConstraints)
        self.pageScrollView?.addConstraints(verticalConstraints)
    }
    
    /**
    This method will set up the constraint based layout for the header and page view inside the 
    main tab view.
    
    - parameter viewsDict:   the views dictionary for the constraints
    - parameter metricsDict: the metrics dictionary for the constraints
    */
    private func setupTabViewConstraints(viewsDict: [String : AnyObject], metricsDict: [String : AnyObject]) {
        // Header Scroll View Container Horizontal Constraints
        let headerHorizontalConstraints: [NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("H:|[_headContainer]|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: viewsDict)
        
        // Page Scroll View Horizontal Constraints
        let pageHorizontalConstraints: [NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("H:|[_pageScroll]|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: viewsDict)
        
        // Vertical Constraints
        let verticalConstraints: [NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("V:|[_headContainer(_headHeight)]-(_spacing)-[_pageScroll]|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: metricsDict,
            views: viewsDict)
        
        // Add the constraints to the main view
        self.addConstraints(verticalConstraints)
        self.addConstraints(headerHorizontalConstraints)
        self.addConstraints(pageHorizontalConstraints)
    }
    
    /**
    This method sets up the constraints for the page view for the tab at the index passed in.
    
    - parameter view:  the page view to apply constraints on
    - parameter index: the index of the page in the tab view
    */
    private func setupConstraints(forPageView view: UIView, atIndex index: UInt) {
        // Views Dictionary
        var viewsDict: [String : AnyObject] = [String : AnyObject]()
        viewsDict["_view"] = view
        
        // Metrics Dictionary
        var metricsDict: [String : AnyObject] = [String : AnyObject]()
        metricsDict["_width"] = self.attributes.pageWidth
        metricsDict["_margin"] = self.attributes.pageWidth * CGFloat(index)
        
        // Horizontal Constraints
        let horizontalConstraints: [NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(_margin)-[_view(_width)]",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: metricsDict,
            views: viewsDict)
        
        // Vertical Constraints
        let verticalConstraints: [NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("V:|[_view]|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: viewsDict)
        
        // Add the constraints to the content view
        self.pageContentView?.addConstraints(horizontalConstraints)
        self.pageContentView?.addConstraints(verticalConstraints)
    }
    
    /**
    This method sets up the constraints for the title label for the tab at the index passed in.
    
    - parameter view:  the page view to apply constraints on
    - parameter index: the index of the page in the tab view
    */
    private func setupConstraints(forTitleLabel label: UIView, atIndex index: UInt) {
        // Views Dictionary
        var viewsDict: [String : AnyObject] = [String : AnyObject]()
        viewsDict["_label"] = label
        
        // Metrics Dictionary
        var metricsDict: [String : AnyObject] = [String : AnyObject]()
        metricsDict["_width"] = self.attributes.titleWidth
        metricsDict["_margin"] = self.attributes.titleWidth * CGFloat(index)
        
        // Horizontal Constraints
        let horizontalConstraints: [NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(_margin)-[_label(_width)]",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: metricsDict,
            views: viewsDict)
        
        // Vertical Constraints
        let verticalConstraints: [NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("V:|[_label]|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: viewsDict)
        
        // Add the constraints to the header content view
        self.headerContentView?.addConstraints(horizontalConstraints)
        self.headerContentView?.addConstraints(verticalConstraints)
    }
    
    
    // MARK: - UIScrollViewDelegate Methods
    
    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        // The header scroll view will be initiating the scroll
        if (scrollView == self.headerScrollView && self.isScrollingPage == false) {
            self.isScrollingHeader = true
            self.pageScrollView?.userInteractionEnabled = false
        }
        
        // The page scroll view will be initiating the scroll
        if (scrollView == self.pageScrollView && self.isScrollingHeader == false) {
            self.isScrollingPage = true
            self.headerScrollViewContainer?.userInteractionEnabled = false
        }
        
        self.headerScrollViewContainer?.dragging = true

        // Notify the delegate that the tab view will begin scrolling
        self.delegate?.tabViewWillBeginScrollingAnimation(self, fromVisibleTabAtIndex: self.indexForCurrentTab())
    }
    
    public func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        // Get the nearest tab (the tab which the scroll view will scroll to)
        var nearestTab: UInt = 0
        
        if (scrollView == self.headerScrollView && self.isScrollingHeader == true) {
            nearestTab = UInt(targetContentOffset.memory.x / CGFloat(self.attributes.titleWidth))
        }
        
        if (scrollView == self.pageScrollView && self.isScrollingPage == true) {
            nearestTab = UInt(targetContentOffset.memory.x / CGFloat(self.attributes.pageWidth))
        }
        
        // Notify the delegate that the tab view that the drag gesture has ended
        self.delegate?.tabViewWillEndDragging(self, withHorizontalVelocity: velocity.x, targetTabAtIndex: nearestTab)
    }
    
    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (decelerate == false) {
            if (scrollView == self.headerScrollView && self.isScrollingPage == false) {
                // The header scroll view is no longer being dragged
                self.scrollViewAnimationEnded()
            }
            
            if (scrollView == self.pageScrollView && self.isScrollingHeader == false) {
                // The page scroll view is no longer being dragged
                self.scrollViewAnimationEnded()
            }
        }
    }
    
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if (scrollView == self.headerScrollView && self.isScrollingPage == false) {
            // The header scroll view is no longer being dragged
            self.scrollViewAnimationEnded()
        }
        
        if (scrollView == self.pageScrollView && self.isScrollingHeader == false) {
            // The page scroll view is no longer being dragged
            self.scrollViewAnimationEnded()
        }
    }
    
    public func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        // The scroll views are done it's animation after being tapped
        self.scrollViewAnimationEnded()
    }
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        // Load the pages that are now on the screen
        self.loadVisiblePages()
        
        // Apply the effects on our tab titles as they scroll
        self.applyTabTitleEffects()
        
        // Get the content offset of the scroll view that was scrolled
        let contentOffset: CGPoint = scrollView.contentOffset
        
        if (scrollView == self.headerScrollView && self.isScrollingHeader == true) {
            // Calculate the multiplier for the scroll view offsets to match
            let offsetMultiplier: CGFloat = contentOffset.x / CGFloat(self.attributes.titleWidth)
            
            // Calculate the xOffset of the page scroll view
            let xOffset: CGFloat = offsetMultiplier * CGFloat(self.attributes.pageWidth)
            
            // Create the new content offset for the page scroll view
            let newContentOffset: CGPoint = CGPointMake(xOffset, self.pageScrollView!.contentOffset.y)
            
            // Change the content offset of the page scroll view
            UIView.animateWithDuration(0.01,
                animations: { () -> Void in
                    self.pageScrollView?.setContentOffset(newContentOffset, animated: false)
            })
            
            // Notify the delegate that the tab view is scrolling
            let velocity: CGPoint = scrollView.panGestureRecognizer.velocityInView(scrollView)
            self.delegate?.tabView(self, didScrollWithOffsetMultiplier: offsetMultiplier, horizontalVelocity: velocity.x)
        }
        
        if (scrollView == self.pageScrollView && self.isScrollingPage == true) {
            // Calculate the multiplier for the scroll view offsets to match
            let offsetMultiplier: CGFloat = contentOffset.x / CGFloat(self.attributes.pageWidth)
            
            // Calculate the xOffset of the header scroll view
            let xOffset: CGFloat = offsetMultiplier * CGFloat(self.attributes.titleWidth)
            
            // Create the new content offset for the header scroll view
            let newContentOffset: CGPoint = CGPointMake(xOffset, self.headerScrollView!.contentOffset.y)
            
            // Change the content offset of the header scroll view
            UIView.animateWithDuration(0.01,
                animations: { () -> Void in
                    self.headerScrollView?.setContentOffset(newContentOffset, animated: false)
            })
            
            // Notify the delegate that the tab view is scrolling
            let velocity: CGPoint = scrollView.panGestureRecognizer.velocityInView(scrollView)
            self.delegate?.tabView(self, didScrollWithOffsetMultiplier: offsetMultiplier, horizontalVelocity: velocity.x)
        }
    }
    
    
    // MARK: - Gesture Recognizer Methods
    
    /**
    This method handles the tap on the tabView header's title labels
    
    - parameter gesture: the gesture recognizer of the label
    */
    func tappedInTabViewHeader(gesture: UIGestureRecognizer) {
        
        // If we are scrolling one of the views, don't do anything
        if (self.isScrollingHeader == true || self.isScrollingPage == true) {
            return
        }
        
        // Initialize our tab index to scroll to
        var tabIndex: UInt?
        
        // Get the X position of the tap
        let tapPosition: CGFloat = gesture.locationInView(gesture.view).x
        
        // Get the tap margin we want to handle
        let delta: CGFloat = (self.attributes.pageWidth - self.attributes.titleWidth) / 2.0
        
        // Get the current tab
        if let currentTab: UInt = self.indexForCurrentTab() {
            // Get the width of our tab view
            let width: CGFloat = CGRectGetWidth(self.bounds)
            
            // Check if we tapped on the left side
            if (tapPosition <= delta) {
                // Make sure we aren't on our first tab
                if (currentTab > 0) {
                    // Set our selected tab index
                    tabIndex = currentTab - 1
                }
            }
            
            // Check if we tapped on the right side
            if (tapPosition >= width - delta) {
                // Make sure we aren't on our last tab
                if (currentTab + 1 < self.attributes.numberOfTabs) {
                    // Set our selected tab index
                    tabIndex = currentTab + 1
                }
            }
        }
    
        // Check if we have a tab to scroll to
        if let tabIndex = tabIndex {
            // Scroll to the selected tab
            self.scrollToTab(atIndex: tabIndex, animated: true)
            
            // Notifify the delegate of a selected tab
            self.delegate?.tabView(self, didSelectTabAtIndex: tabIndex)
            
            if let currentTab: UInt = self.indexForCurrentTab() {
                // Notify the delegate that the tab view will begin scrolling
                self.delegate?.tabViewWillBeginScrollingAnimation(self, fromVisibleTabAtIndex: currentTab)
            }
        }
    }
}
