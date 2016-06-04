//
//  ViewController.m
//  MWTabViewExampleObjC
//
//  Created by Clément Padovani on 6/4/16.
//  Copyright © 2016 Mathieu White. All rights reserved.
//

#import "ViewController.h"

@import MWTabView;

@interface ViewController () <MWTabViewDelegate, MWTabViewDataSource>

@property (nonatomic, copy) NSArray <UIView *> *tabViewViews;

@property (nonatomic, weak) MWTabView *tabView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSMutableArray <UIView *> *tabViewViews = [NSMutableArray arrayWithCapacity: 3];

    NSArray <UIColor *> *colors = @[[UIColor redColor],
                                    [UIColor greenColor],
                                    [UIColor blueColor]];

    for (UIColor *aColor in colors)
    {
        UIView *aView = [[UIView alloc] init];

        [aView setBackgroundColor: aColor];

        [tabViewViews addObject: aView];
    }

    [self setTabViewViews: tabViewViews];

    MWTabView *tabView = [[MWTabView alloc] init];

    [tabView setBackgroundColor: [UIColor lightGrayColor]];

    NSArray <UIColor *> *gradientColors = @[[UIColor whiteColor],
                                            [UIColor colorWithWhite: .9f alpha: 1]];

    [tabView setGradientForTabViewHeaderWithColors: gradientColors];

    [tabView setDelegate: self];

    [tabView setDataSource: self];

    [tabView setTranslatesAutoresizingMaskIntoConstraints: NO];

    [[self view] addSubview: tabView];

    [self setTabView: tabView];

    [self setupConstraints];
}

- (void) setupConstraints
{
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_tabView);

    NSDictionary *metricsDictionary = nil;

    [[self view] addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[_tabView]|"
                                                                         options: 0
                                                                         metrics: metricsDictionary
                                                                           views: viewsDictionary]];

    [[self view] addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"V:|[_tabView]|"
                                                                         options: 0
                                                                         metrics: metricsDictionary
                                                                           views: viewsDictionary]];
}

- (NSUInteger) numberOfTabsInTabView: (MWTabView *) tabView
{
    return 3;
}

- (UIView *) tabView: (MWTabView *) tabView viewForTabAtIndex: (NSUInteger) index
{
    return [self tabViewViews][index];
}

- (NSString *) tabView: (MWTabView *) tabView titleForTabAtIndex: (NSUInteger) index
{
    return [NSString stringWithFormat: @"My Tab %lu", index + 1];
}

// MARK: - MWTabViewDelegate Methods

- (CGFloat) heightForHeaderInTabView: (MWTabView *) tabView
{
    return 64;
}

- (CGFloat) widthForTitlesInTabView: (MWTabView *) tabView
{
    return ceilf(CGRectGetWidth([[self view] bounds]) / 3.f);
}

- (BOOL) tabViewShouldRecycleViews: (MWTabView *) tabView
{
    return YES;
}

@end
