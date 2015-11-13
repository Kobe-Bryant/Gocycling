//
//  MainViewController.m
//  doomcom.Goclaying
//
//  Created by 马峰 on 14-3-20.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import "MainViewController.h"
#import "SearchViewController.h"
#import "NewGoodsViewController.h"
#import "BrandViewController.h"
#import "ActivityViewController.h"
#import "MeViewController.h"
#import "Macros.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"RootViewController viewDidLoad");;

    
    //初始化所有视图控制器
    [self initWithAllControllers];
}


//初始化所有视图控制器
- (void)initWithAllControllers
{    
    //查找视图控制器
    SearchViewController* searchViewController = [[SearchViewController alloc] init];
    UINavigationController* searchNavigationController = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        searchViewController.edgesForExtendedLayout = NO;
    }
    UITabBarItem* searchBarItem = [[UITabBarItem alloc] init];
    searchBarItem.image = [UIImage imageNamed:@"HomeIcon"];
    searchBarItem.title = @"首页";
    searchNavigationController.tabBarItem = searchBarItem;
    
    
    //新品上市视图控制器
//    NewGoodsViewController* newGoodViewController = [[NewGoodsViewController alloc]init];
//    UINavigationController* newGoodNavigation = [[UINavigationController alloc] initWithRootViewController:newGoodViewController];
//    UITabBarItem* newGoodBarItem = [[UITabBarItem alloc]init];
//    newGoodBarItem.image = [UIImage imageNamed:@"xingping.png"];
//    
//    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
//        newGoodViewController.edgesForExtendedLayout = NO;
//    }
//    newGoodBarItem.title = @"新品上市";
//    newGoodNavigation.tabBarItem = newGoodBarItem;
    
    
    //品牌视图控制器
    BrandViewController* brandViewcontroller = [[BrandViewController alloc]init];
    UINavigationController* brandNavigationController = [[UINavigationController alloc]
                                initWithRootViewController:brandViewcontroller];
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        brandViewcontroller.edgesForExtendedLayout = NO;
    }
    UITabBarItem* brandBarItem = [[UITabBarItem alloc]init];
    brandBarItem.image = [UIImage imageNamed:@"brand.png"];
    brandBarItem.title = @"品牌";
    brandNavigationController.tabBarItem = brandBarItem;
    
    
    
    //活动报名视图控制器
    ActivityViewController* activityController = [[ActivityViewController alloc]init];
    UINavigationController* activityNavigationController = [[UINavigationController alloc]
                                 initWithRootViewController:activityController];
    UITabBarItem* actiVityBarItem = [[UITabBarItem alloc]init];
    actiVityBarItem.image = [UIImage imageNamed:@"activity_.png"];
    actiVityBarItem.title = @"活动报名";
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        activityController.edgesForExtendedLayout = NO;
    }
    activityNavigationController.tabBarItem = actiVityBarItem;
    
    
    
    //我的视图控制器
    MeViewController* meViewController = [[MeViewController alloc] init];
    UINavigationController* meNavigationController = [[UINavigationController alloc]
                                    initWithRootViewController:meViewController];
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        meViewController.edgesForExtendedLayout = NO;
    }
    UITabBarItem* meBarItem = [[UITabBarItem alloc] init];
    meBarItem.image = [UIImage imageNamed:@"wo.png"];
    meBarItem.title = @"我的";
    meNavigationController.tabBarItem = meBarItem;
    

    
    // UITabbarController
//    NSArray* tabBarChildColltrolers = [[NSArray alloc] initWithObjects:searchNavigationController, newGoodNavigation, brandNavigationController, activityNavigationController, meNavigationController, nil];
    NSArray* tabBarChildColltrolers = [[NSArray alloc] initWithObjects:searchNavigationController, brandNavigationController, activityNavigationController, meNavigationController, nil];
    self.viewControllers = tabBarChildColltrolers;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
