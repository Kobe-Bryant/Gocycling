//
//  SearchViewController.h
//  domcom.Goclay
//
//  Created by 马峰 on 14-3-12.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TitleView.h"

@interface SearchViewController : UIViewController<TitleViewDelegate, UISearchBarDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *middleView;

@property(nonatomic,strong) UIPageViewController *pageController;

- (IBAction)moreButton:(UIButton *)sender;

@end
