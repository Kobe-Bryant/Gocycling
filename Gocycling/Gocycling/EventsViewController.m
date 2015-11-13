//
//  EventsViewController.m
//  doomcom.Goclaying
//
//  Created by Apple on 14-3-20.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

//#define SIGN_UP_BUTTON_TAG 3211

#import "EventsViewController.h"
#import "BinnerThreeViewController.h"
#import "Macros.h"
#import "ActivityDetailViewController.h"
#import "ApplyViewController.h"
#import "CoustomPageControl.h"
#import "Result.h"
#import "Activity.h"
#import "SelectProjectViewController.h"
#import "Member.h"
#import "LoginViewController.h"

@interface EventsViewController ()
{
    
    UIScrollView* mainScrollView;
    NSMutableArray* listArray;
    NSMutableArray* titleArray;
    UITapGestureRecognizer* applyGesture;
    UITapGestureRecognizer* eventDetailGesture;
    BOOL isEnter;
    CoustomPageControl* coustomPageControl;
    UILabel* titleLabel;
    UILabel* applyLabel;
    UILabel* activityDateLabel;
    UILabel* activityOverLabel;
    Activity* eventDetailList;
    
    
    
    
    
}

@property (nonatomic, strong) UIPageViewController* pageController;
@property (nonatomic, retain) UIButton *signUpButton;

@end

@implementation EventsViewController

@synthesize pageController;

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
    
    
    //设置navigationItem的titleView
//    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(160, 0, 40, 30)];
//    label.textColor = [UIColor whiteColor];
//    label.backgroundColor = [UIColor clearColor];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.text = NSLocalizedString(@"赛事", nil);
//    self.navigationItem.titleView = label;
    self.title = @"赛事";
    
    
    
    //返回的leftBarButtonItem
    UIImage* image = [UIImage imageNamed:@"arrowback.png"];
    UIButton* bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = CGRectMake(0, 0,image.size.width, image.size.height);
    [bt setImage:image forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(backButtonMethod) forControlEvents:
     UIControlEventTouchUpInside];
    UIBarButtonItem* left = [[UIBarButtonItem alloc]initWithCustomView:bt];
    self.navigationItem.leftBarButtonItem = left;
    
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:
     @selector(changeBannerIndex:) name:@"BinnerThreeViewControllerIndex" object:nil];
    
    //准备数据源
    [self initAlldata];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
    
    if (isEnter) {
        
        
        return ;
        
    }else {
        
        isEnter = YES;
    }
    
    //创建ScrollView
    mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,
                                                                   self.view.frame.size.width,
                                                                   self.view.frame.size.height)];
    mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 510);
    mainScrollView.showsHorizontalScrollIndicator = YES;
    mainScrollView.userInteractionEnabled = YES;
    mainScrollView.backgroundColor = [UIColor colorWithCGColor:
                                      UIColorFromRGB(235.0, 239.0, 241.0).CGColor];
    [self.view addSubview:mainScrollView];
    
    
    
    //配置pageController
    NSDictionary* dic = [NSDictionary dictionaryWithObject:
                         [NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                                    forKey:UIPageViewControllerOptionSpineLocationKey];
    
    self.pageController = [[UIPageViewController alloc]initWithTransitionStyle:
                           UIPageViewControllerTransitionStyleScroll
                                                         navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                       options:dic];
    pageController.dataSource = self;
    UIImage* pageVCimage = [UIImage imageNamed:@"_enterimage.png"];
    pageController.view.frame = CGRectMake(0,0, 320, pageVCimage.size.height);
    pageController.view.backgroundColor = [UIColor lightGrayColor];
    
    
    
    BinnerThreeViewController* binnerView = [self viewControllerAtIndex:0];
    NSArray* viewcontrollers = [NSArray arrayWithObject:binnerView];
    [pageController setViewControllers:viewcontrollers direction:
     UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [mainScrollView addSubview:pageController.view];
    
    //自定义UIPageControl
    coustomPageControl = [[CoustomPageControl alloc] init] ;
    coustomPageControl.frame = CGRectMake(140, 180, 120, 30);
    [coustomPageControl setNumberOfPages: 5] ;
    [coustomPageControl setCurrentPage: 0] ;
    [coustomPageControl setDefersCurrentPageDisplay: YES] ;
    [coustomPageControl setType: DDPageControlTypeOnFullOffEmpty] ;
    [coustomPageControl setOnColor: [UIColor colorWithWhite: 1.0f alpha: 1.0f]];
    [coustomPageControl setOffColor: [UIColor colorWithWhite: 1.0f alpha: 1.0f]];
    [coustomPageControl setIndicatorDiameter: 6.0f] ;
    [coustomPageControl setIndicatorSpace: 5.0f] ;
    [pageController.view addSubview:coustomPageControl];
    
    
    //pageController.view下面的视图
    UIView* downView = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                               pageVCimage.size.height,
                                                               self.view.frame.size.width,
                                                               260)];
    
    downView.backgroundColor = [UIColor colorWithCGColor:
                                UIColorFromRGB(235.0, 239.0, 241.0).CGColor];
    [mainScrollView addSubview:downView];
    
    
    //downView上的6个子视图titleLable | applyLabel | activityLabel
    //                   | activityOverLabel | imageViewOne | imageViewTwo
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 300, 20)];
    titleLabel.font  = [UIFont systemFontOfSize:18];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                            (27.0, 27.0, 27.0).CGColor];
    [downView addSubview:titleLabel];
    
    
    applyLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 40, 250, 20)];
    applyLabel.font  = [UIFont systemFontOfSize:15];
    applyLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                            (98.0, 98.0, 98.0).CGColor];
    applyLabel.backgroundColor = [UIColor clearColor];
    [downView addSubview:applyLabel];
    
    
    activityDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 70, 290, 20)];
    activityDateLabel.font  = [UIFont systemFontOfSize:15];
    activityDateLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                   (98.0, 98.0, 98.0).CGColor];
    activityDateLabel.backgroundColor = [UIColor clearColor];
    [downView addSubview:activityDateLabel];
    
    
    activityOverLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 100, 250, 20)];
    activityOverLabel.font  = [UIFont systemFontOfSize:15];
    activityOverLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                   (235.0, 97.0, 0).CGColor];
    activityOverLabel.backgroundColor = [UIColor clearColor];
    [downView addSubview:activityOverLabel];
    
    
    //我要报名的Imageview
//    UIImage* applyImage = [UIImage imageNamed:@"join.png"];
//    UIImageView* applyImageView = [[UIImageView alloc]initWithFrame:CGRectMake
//                                   ((self.view.frame.size.width-applyImage.size.width)/2.0,
//                                    135,
//                                    applyImage.size.width,
//                                    applyImage.size.height)];
//    applyImageView.userInteractionEnabled = YES;
//    applyImageView.image = applyImage;
//    [downView addSubview:applyImageView];
//    applyGesture = [[UITapGestureRecognizer alloc]
//                    initWithTarget:self action:@selector(joinplaygames:)];
//    [applyImageView addGestureRecognizer:applyGesture];
    UIImage *signUpButtonImage = [UIImage imageNamed:@"join"];
    self.signUpButton = [[UIButton alloc] init];
    self.signUpButton.frame = CGRectMake((self.view.frame.size.width - signUpButtonImage.size.width) / 2.0,
                                         135,
                                         signUpButtonImage.size.width,
                                         signUpButtonImage.size.height);
    [self.signUpButton setImage:signUpButtonImage forState:UIControlStateNormal];
    [self.signUpButton addTarget:self
                          action:@selector(signUp:)
                forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:self.signUpButton];

    
    
//    //赛事详情的Imageview
    UIImage* viewDetailButtonImage = [UIImage imageNamed:@"playdetail"];
    UIButton *viewDetailButton = [[UIButton alloc] init];
    viewDetailButton.frame = CGRectMake((self.view.frame.size.width - viewDetailButtonImage.size.width) / 2.0,
                                        CGRectGetMaxY(self.signUpButton.frame) + 10.0,
                                        viewDetailButtonImage.size.width,
                                        viewDetailButtonImage.size.height);
    [viewDetailButton setImage:viewDetailButtonImage forState:UIControlStateNormal];
    [viewDetailButton addTarget:self
                         action:@selector(joinplaygames:)
               forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:viewDetailButton];
//    UIImageView* eventImageView = [[UIImageView alloc] initinitWithFrame:CGRectMake
//                                   ((self.view.frame.size.width-eventImage.size.width)/2.0,
//                                    135+applyImage.size.height+10,
//                                    eventImage.size.width,
//                                    eventImage.size.height)];
//    eventImageView.userInteractionEnabled = YES;
//    eventImageView.image = eventImage;
//    [downView addSubview:eventImageView];
//    
//    eventDetailGesture = [[UITapGestureRecognizer alloc]
//                          initWithTarget:self action:@selector(joinplaygames:)];
//    [eventImageView addGestureRecognizer:eventDetailGesture];
    
    
    //获取网络数据
    [self getWebServiceData];
    
    
}

-(void)getWebServiceData
{
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
        
        Result* result = [Activity requestByActivityID:self.eventID];
        
        
        
        
        if (result.isSuccess) {
            
            
            eventDetailList = (Activity*)result.data;
            
            NSLog(@"%@",eventDetailList.title);
            NSLog(@"%@",eventDetailList.description);
            NSLog(@"%@",eventDetailList.dateString);
            NSLog(@"%d",eventDetailList.isEnded);
            NSLog(@"%d",eventDetailList.signUpCount);
            NSLog(@"%d",eventDetailList.activityID);
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            titleLabel.text = eventDetailList.title;
            
            applyLabel.text = [NSString stringWithFormat:@"已报名 :%d人",eventDetailList.signUpCount];
            
            activityDateLabel.text = [NSString stringWithFormat:@"活动时间 :%@",eventDetailList.dateString];
            
            if (eventDetailList.isEnded) {
                
                
                activityOverLabel.text = @"活动已经结束报名啦";
                self.signUpButton.enabled = NO;
                
                
            }else {
                
                
                activityOverLabel.text = @"活动正在进行中";
                
            }
            
            
            
        });
    });
}

//
- (void)signUp:(UIButton *)button
{
//    ApplyViewController* applyVC = [[ApplyViewController alloc]init];
//    applyVC.currentEventID = self.eventID;
//    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
//        applyVC.edgesForExtendedLayout = NO;
//    }
//    [self.navigationController pushViewController:applyVC animated:YES];
    if ([[Member sharedMember] hasLogined]) {
        SelectProjectViewController *selectedProjectVC = [[SelectProjectViewController alloc] init];
        selectedProjectVC.eventID = self.eventID;
        UINavigationController* navigationVC = [[UINavigationController alloc] initWithRootViewController:selectedProjectVC];
        if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            selectedProjectVC.edgesForExtendedLayout = NO;
        }
        [self presentViewController:navigationVC animated:YES completion:nil];
    } else {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UINavigationController* navigationVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            loginVC.edgesForExtendedLayout = NO;
        }
        [self presentViewController:navigationVC animated:YES completion:nil];
    }
    
    
    

}

//我要报名和赛事详情的手势方法
- (void)joinplaygames:(UITapGestureRecognizer*)tap
{
    ActivityDetailViewController* eventVC = [[ActivityDetailViewController alloc]init];
    eventVC.detailDescrption = eventDetailList.description;
    UINavigationController* navigationVC = [[UINavigationController alloc] initWithRootViewController:eventVC];
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        eventVC.edgesForExtendedLayout = NO;
    }
    [self presentViewController:navigationVC animated:YES completion:nil];

    
}

#pragma mark UIPageViewControllerDataSource Method
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(BinnerThreeViewController *)viewController];
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index--;
    
    if (index == -1) {
        index = [listArray count] - 1;
    }
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    BinnerThreeViewController *moreVC = (BinnerThreeViewController *)viewController;
    
    NSInteger index = [listArray indexOfObject:moreVC.dataObject];
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    
    if (index == [listArray count]) {
        
        index = 0;
    }
    
    return [self viewControllerAtIndex:index];
}

- (BinnerThreeViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([listArray count] == 0) || (index >= [listArray count])) {
        return nil;
    }
    
    // 创建一个新的控制器类，并且分配给相应的数据
    BinnerThreeViewController *dataViewController = [[BinnerThreeViewController alloc] init];
    dataViewController.dataObject = [listArray objectAtIndex:index];
    
    return dataViewController;
}

- (NSUInteger)indexOfViewController:(BinnerThreeViewController *)viewController
{
    
    return [listArray indexOfObject:viewController.dataObject];
}

//准备数据源
-(void)initAlldata
{
    NSArray* titleImageArray = @[@"_enterimage.png",
                                 @"_enterimage2.png",
                                 @"_enterimage3.png",
                                 @"_enterimage4.png",
                                 @"_enterimage5.png"];
    
    listArray = [NSMutableArray arrayWithArray:titleImageArray];
}

//监听通知调用的方法
- (void)changeBannerIndex:(NSNotification *)notification
{
    NSString *imageURL = [notification.object objectForKey:@"dateobject"];
    coustomPageControl.currentPage = [listArray indexOfObject:imageURL];
    [coustomPageControl setOnColor: [UIColor whiteColor]];
	[coustomPageControl setOffColor: [UIColor whiteColor]];
}

#pragma mark BackBarButton Method
-(void)backButtonMethod
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
