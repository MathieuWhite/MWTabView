//
//  ViewController.swift
//  MWTabViewExample
//
//  Created by Mathieu White on 2016-06-04.
//  Copyright © 2016 Mathieu White. All rights reserved.
//

import UIKit

import MWTabView

class ViewController: UIViewController, MWTabViewDataSource, MWTabViewDelegate {
    
    
    // MARK: - Variables
    
    /// The tab view for the example.
    weak var tabView: MWTabView?
    
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the tab view
        let tabView = MWTabView()
        tabView.backgroundColor = UIColor.lightGrayColor()
        tabView.setGradientForTabViewHeader(colors: [UIColor.whiteColor(), UIColor(white: 0.9, alpha: 1.0)])
        tabView.translatesAutoresizingMaskIntoConstraints = false
        tabView.dataSource = self
        tabView.delegate = self
        
        // Add the tab view to the main view
        self.view.addSubview(tabView)
        
        // Set the tab view to its variable
        self.tabView = tabView
        
        // Auto Layout
        self.setupConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Auto Layout

    private func setupConstraints() {
        // Views Dictionary
        var viewsDict: [String : AnyObject] = [String : AnyObject]()
        viewsDict["_tabView"] = self.tabView
        
        // Tab View Vertical Constraints
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[_tabView]|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: viewsDict))
        
        // Tab View Horizontal Constraints
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[_tabView]|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: viewsDict))
    }
    
    
    // MARK: - MWTabViewDataSource Methods
    
    func numberOfTabsInTabView(tabView: MWTabView) -> UInt {
        return 3
    }
    
    func tabView(tabView: MWTabView, viewForTabAtIndex index: UInt) -> UIView {
        let view = UIView()
        
        switch (index) {
        case 0: view.backgroundColor = UIColor.redColor()
        case 1: view.backgroundColor = UIColor.greenColor()
        case 2: view.backgroundColor = UIColor.blueColor()
        default: view.backgroundColor = UIColor.whiteColor()
        }
        
        return view
    }

    func tabView(tabView: MWTabView, titleForTabAtIndex index: UInt) -> String {
        return String(format: "My Tab %lu", index + 1)
    }
    
    
    // MARK: - MWTabViewDelegate Methods
    
    func heightForHeaderInTabView(tabView: MWTabView) -> CGFloat {
        return 64.0
    }
    
    func widthForTitlesInTabView(tabView: MWTabView) -> CGFloat {
        return ceil(CGRectGetWidth(self.view.bounds) / 3.0)
    }
    
    func tabViewShouldRecycleViews(tabView: MWTabView) -> Bool {
        return true
    }

}

