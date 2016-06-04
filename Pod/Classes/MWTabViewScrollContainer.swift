//
//  MWTabViewScrollContainer.swift
//  Tabs
//
//  Created by Mathieu White on 2015-05-30.
//  Copyright (c) 2015 Mathieu White. All rights reserved.
//

import UIKit

class MWTabViewScrollContainer: UIView {
    
    // MARK: - Variables
    
    weak var scrollView: UIScrollView?
    var tabIndicatorHeight: CGFloat = 10.0
    var dragging: Bool = false
    
    
    // MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initTabViewScrollContainer()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initTabViewScrollContainer()
    }
    
    convenience init() {
        self.init(frame: CGRectZero)
    }
    
    private func initTabViewScrollContainer() {
        self.layer.rasterizationScale = UIScreen.mainScreen().scale
        self.layer.shouldRasterize = true
    }
    
    
    // MARK: - Instance Methods
    
    /**
    This method will draw a triangle cutout in the rect
    for the current tab indicator.
    */
    override func drawRect(rect: CGRect) {
        // Get our view's width
        let width: CGFloat = CGRectGetWidth(rect)
        
        // Get our view's height
        let height: CGFloat = CGRectGetHeight(rect)
        
        // Determine the length of our triangle
        let length: CGFloat = self.tabIndicatorHeight
        
        // Calculate the left point of our triangle
        let leftPoint: CGPoint = CGPointMake((width / 2.0) - (length), height)
        
        // Calculate the right point of our triangle
        let rightPoint: CGPoint = CGPointMake((width / 2.0) + (length), height)
        
        // Calculate the top point of our triangle
        let topPoint: CGPoint = CGPointMake(width / 2.0, height - length)
        
        // Create a path to cutout a triangle from our view
        let trianglePath: UIBezierPath = UIBezierPath()
        trianglePath.moveToPoint(CGPointZero)
        trianglePath.addLineToPoint(CGPointMake(width, 0.0))
        trianglePath.addLineToPoint(CGPointMake(width, height))
        trianglePath.addLineToPoint(rightPoint)
        trianglePath.addLineToPoint(topPoint)
        trianglePath.addLineToPoint(leftPoint)
        trianglePath.addLineToPoint(CGPointMake(0.0, height))
        trianglePath.closePath()
        
        // Create our cut out layer
        let triangleCutOut: CAShapeLayer = CAShapeLayer()
        triangleCutOut.path = trianglePath.CGPath
        
        // Mask our view
        self.layer.mask = triangleCutOut
    }
    
    /**
    This method hands control over to the scroll view for any touches
    that occur within the container view's bounds.
    */
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        if (self.dragging == true || self.scrollView?.decelerating == true) {
            return self
        }
        
        let view = super.hitTest(point, withEvent: event)
        
        if let theView = view {
            if theView == self {
                return self.scrollView
            }
        }
        
        return view
    }
}
