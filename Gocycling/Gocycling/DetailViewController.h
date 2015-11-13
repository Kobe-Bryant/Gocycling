//
//  DetailViewController.h
//  domcom.Goclay
//
//  Created by Apple on 14-3-14.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController<UIPageViewControllerDataSource>


@property(nonatomic, strong) UIPageViewController* pageController;
@property(nonatomic, retain) NSNumber* productID;

- (id)initWithProductID:(NSNumber *)productID;

@end
