//
//  DetailViewController.m
//  domcom.Goclay
//
//  Created by Apple on 14-3-14.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import "DetailViewController.h"
#import "Macros.h"
#import "RatingView.h"
#import "BinnerTwoViewController.h"
#import "GoodDetailViewController.h"
#import "GoodsEvaluatesViewController.h"
#import "CoustomPageControl.h"
#import "Product.h"
#import "Result.h"
#import "Banner.h"
#import "LoginViewController.h"
#import "Member.h"



@interface DetailViewController ()
{
    UIView* downView;
    UIScrollView* mainScrollView;
    CoustomPageControl*  coustomPageControl;
    BOOL isEnter;
    UILabel* collectLabel;
    UIView* blackView;
    UIImageView* detailImageView;
    UIImageView* evaluateImageView;
    BOOL isCollecting;
    UILabel* onBlackViewlabel;
    UIView* cancelBlackView;
    UILabel* cancelLabel;
    UILabel* titleLabel;
    UILabel* productNameLable;
    RatingView* ratingView;
    UILabel* priceLabel;
    UILabel* evaluaLabel;
    Product* detailProduct;
    BOOL hasCollected;
    
    
    
}
@property(nonatomic,strong) NSMutableArray* detailBannerArray;
@property(nonatomic,strong) NSMutableArray* bannerImageArray;


@end

@implementation DetailViewController
@synthesize pageController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        self.navigationItem.hidesBackButton = YES;
    }
    return self;
}

- (id)initWithProductID:(NSNumber *)productID
{
    self = [super init];
    if (self) {
        self.productID = productID;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"DetailViewController viewDidLoad");
    NSLog(@"%@", self.productID);
    
    isCollecting = NO;
    
    //设置navigationItem的titleView
//    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 0, 40, 30)];
//    titleLabel.textColor = [UIColor whiteColor];
//    titleLabel.backgroundColor = [UIColor clearColor];
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    self.navigationItem.titleView = titleLabel;
    
    
    
    //返回的leftBarButtonItem
    UIImage* image = [UIImage imageNamed:@"arrowback.png"];
    UIButton* bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = CGRectMake(0, 0,image.size.width, image.size.height);
    [bt setImage:image forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(backButtonMethod) forControlEvents:
     UIControlEventTouchUpInside];
    UIBarButtonItem* left = [[UIBarButtonItem alloc]initWithCustomView:bt];
    self.navigationItem.leftBarButtonItem = left;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:
     @selector(changeBannerIndex:) name:@"BinnerTwoViewControllerIndex" object:nil];
    
 
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
     [self getWebServiceData];

    
  //判断是否进入
    if (isEnter) {
        return;
    } else {
        isEnter = YES;
    }
    
    
    self.view.backgroundColor = UIColorFromRGB(235.0, 239.0, 241.0);
//   self.tabBarController.tabBar.hidden = YES;
    

    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0,
                                                                    0.0,
                                                                    self.view.frame.size.width,
                                                                    self.view.frame.size.height)];
    mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 540);
    mainScrollView.showsHorizontalScrollIndicator = YES;
    mainScrollView.userInteractionEnabled=YES;
    [self.view addSubview:mainScrollView];
        
    //pageController.view下面的view
    downView = [[UIView alloc] initWithFrame:CGRectMake(0.0,
                                                        320.0,
                                                        self.view.frame.size.width,
                                                        self.view.frame.size.height)];
    [downView setBackgroundColor:UIColorFromRGB(235.0, 239.0, 241.0)];
    downView.userInteractionEnabled = YES;
    [mainScrollView addSubview:downView];
    
    productNameLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 300, 30)];
    productNameLable.textColor = UIColorFromRGB(67.0, 67.0, 67.0);
    productNameLable.font = [UIFont systemFontOfSize:18];
    productNameLable.backgroundColor = [UIColor clearColor];
    [downView addSubview:productNameLable];
    
    UILabel* evaluateLable = [[UILabel alloc]initWithFrame:CGRectMake
                                                             (15, 50, 75, 30)];
    evaluateLable.font = [UIFont systemFontOfSize:15];
    evaluateLable.backgroundColor = [UIColor clearColor];
    evaluateLable.text = @"评    价 :";
    evaluateLable.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                 (149.0, 149.0, 149.0).CGColor];
    [downView addSubview:evaluateLable];
    
  
    
    UILabel* marketLabel = [[UILabel alloc]initWithFrame:CGRectMake
                                               (15, 85, 60, 30)];
    marketLabel.text = @"市场价 :";
    marketLabel.backgroundColor = [UIColor clearColor];
    marketLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                               (149.0, 149.0, 149.0).CGColor];
    marketLabel.font = [UIFont systemFontOfSize:15];
    [downView addSubview:marketLabel];
    
    priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 85, 200, 30)];
    
    priceLabel.font = [UIFont systemFontOfSize:18];
    priceLabel.backgroundColor = [UIColor clearColor];
    priceLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                    (230.0, 0.0, 18.0).CGColor];
    
    [downView addSubview:priceLabel];
    
    
    //收藏view
    UIImage* collectImage = [UIImage imageNamed:@"collectImage.png"];
    UIImageView* collectImageView = [[UIImageView alloc]initWithFrame:CGRectMake
                  (230, 70,collectImage.size.width , collectImage.size.height)];
    collectImageView.image = collectImage;
    
    collectImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer* saveTapGesture = [[UITapGestureRecognizer alloc]
                             initWithTarget:self action:@selector(saveMethod:)];
    [collectImageView addGestureRecognizer:saveTapGesture];
    
    [downView addSubview:collectImageView];
    
    collectLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 5, 50, 30)];
    collectLabel.font = [UIFont systemFontOfSize:15.0];
    collectLabel.textColor = [UIColor colorWithCGColor:
                                       UIColorFromRGB(67.0, 67.0, 67.0).CGColor];
    collectLabel.text = @"收藏";

    [collectImageView addSubview:collectLabel];
    
    
    
    //产品详情view
    UIImage* detailImage = [UIImage imageNamed:@"detailgoods.png"];
    detailImageView = [[UIImageView alloc]initWithFrame:CGRectMake
                    (13, 120,detailImage.size.width , detailImage.size.height)];
    detailImageView.image = detailImage;
    detailImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                        action:@selector(clickTap:)];
    [detailImageView addGestureRecognizer:tapGesture];
    
    [downView addSubview:detailImageView];
    
    //产品评论view
    UIImage* commentImage = [UIImage imageNamed:@"comment.png"];
    evaluateImageView = [[UIImageView alloc]initWithFrame:CGRectMake
                                                  (13+detailImage.size.width+13,
                     120,commentImage.size.width , commentImage.size.height)];
    evaluateImageView.image = commentImage;
    
    UITapGestureRecognizer* evaluateTapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(clickEvaluateTap:)];
    [evaluateImageView addGestureRecognizer:evaluateTapGesture];
     evaluateImageView.userInteractionEnabled = YES;
    
    [downView addSubview:evaluateImageView];
    
    
    evaluaLabel = [[UILabel alloc]initWithFrame:CGRectMake
                                                 (25, 6,100 , 30)];
    [evaluateImageView addSubview:evaluaLabel];

}


-(void)viewWillDisappear:(BOOL)animated
{

    [super viewWillDisappear:animated];
    self.view.backgroundColor = [UIColor clearColor];
    
}

-(void)getWebServiceData
{
  
    NSLog(@"%@",self.productID);
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_t group  = dispatch_group_create();
    
    dispatch_group_async(group, queue,^{
    
        
        
        Result* result = [Product requestByProductID:self.productID];

        if (result.isSuccess) {
            
            detailProduct = (Product*)result.data;
            
            self.detailBannerArray = [NSMutableArray arrayWithArray:detailProduct.productImageArray];
            
            self.bannerImageArray = [NSMutableArray array];
            
              for (Banner* banner in self.detailBannerArray) {
                
                
                [self.bannerImageArray addObject:banner.imageURLString];
                
              }
            
            }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.title = detailProduct.title;
            titleLabel.text = NSLocalizedString(detailProduct.title, nil);
            productNameLable.text = detailProduct.title ;
            
            //评级视图
            ratingView = [[RatingView alloc]initWithFrame:CGRectMake
                          (75, 58, 120, 30) andFloat:detailProduct.ratingFloat starStyle:0];
            ratingView.backgroundColor = [UIColor clearColor];
            [downView addSubview:ratingView];
            
            priceLabel.text = [NSString stringWithFormat:@"￥%0.f",detailProduct.productPrice];
            evaluaLabel.text = [NSString stringWithFormat:@"产品评论(%d)",detailProduct.commentCount];
            
            
            
            NSDictionary* dic = [NSDictionary dictionaryWithObject:
                                 [NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                                            forKey:UIPageViewControllerOptionSpineLocationKey];
            
            self.pageController = [[UIPageViewController alloc]initWithTransitionStyle:
                                   UIPageViewControllerTransitionStyleScroll navigationOrientation:
                                   UIPageViewControllerNavigationOrientationHorizontal options:dic];
            
            pageController.dataSource = self;
            pageController.view.frame = CGRectMake(0,0, 320, 320);
            pageController.view.backgroundColor = [UIColor colorWithCGColor:
                                                   UIColorFromRGB(255.0, 255.0, 255.0).CGColor];
            
            
            BinnerTwoViewController* binnerView = [self viewControllerAtIndex:0];
            NSArray* viewcontrollers = [NSArray arrayWithObject:binnerView];
            [pageController setViewControllers:viewcontrollers direction:
             UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            [self addChildViewController:pageController];
            [mainScrollView addSubview:pageController.view];
            
            
            
            //自定义PageControl
            coustomPageControl = [[CoustomPageControl alloc] init] ;
            coustomPageControl.frame = CGRectMake(140, 285, 120, 30);
            [coustomPageControl setNumberOfPages: self.bannerImageArray.count] ;
            [coustomPageControl setCurrentPage: 0] ;
            [coustomPageControl setDefersCurrentPageDisplay: YES] ;
            [coustomPageControl setType: DDPageControlTypeOnFullOffEmpty] ;
            [coustomPageControl setOnColor: [UIColor colorWithCGColor:
                                             UIColorFromRGB(127.0, 127.0, 127.0).CGColor]];
            [coustomPageControl setOffColor:  [UIColor colorWithCGColor:
                                               UIColorFromRGB(127.0, 127.0, 127.0).CGColor]] ;
            [coustomPageControl setIndicatorDiameter: 6.0f] ;
            [coustomPageControl setIndicatorSpace: 5.0f] ;
            [pageController.view addSubview:coustomPageControl];
            
            
            });
        
    });
    
    
    dispatch_group_async(group, queue, ^{
        if ([[Member sharedMember] hasLogined]) {
            Result* result = [[Member sharedMember] collectProduct:self.productID.integerValue];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (result.isSuccess) {
                    BOOL isProductExsited = [result.data boolValue];
                    if (!isProductExsited) {
                        collectLabel.text = @"收藏";
                        hasCollected = NO;
                    } else {
                        collectLabel.frame = CGRectMake(7, 5, 60, 30);
                        collectLabel.text = @"取消收藏";
                        hasCollected = YES;
                    }
                }
                
            });
            
        }
        
        
  });
    
    
}
#pragma mark UIPageViewControllerDataSource Method

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)
                                                     pageViewController
{
    return 1;
    
}
- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)
                                                    pageViewController
{
    if (self.bannerImageArray.count!=0) {
        
        NSInteger index = [self.bannerImageArray indexOfObject:pageController];
        
        return index;
        
    }else {
    
        return 0;
    }
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    BinnerTwoViewController* binnerVC =(BinnerTwoViewController*) viewController;
    NSUInteger index = [self indexOfViewController:binnerVC];
    
    if (index == NSNotFound) {
        
        return nil;
    }
    
    index--;
    
    if (index == -1) {
       
        if (self.bannerImageArray.count!=0) {
            
            index = [self.bannerImageArray count] - 1;
   
            
        }
    }
    
    return [self viewControllerAtIndex:index];
    
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    BinnerTwoViewController *moreVC = (BinnerTwoViewController *)viewController;
    NSInteger index;
    
    if (self.bannerImageArray.count!=0) {
        
     index = [self.bannerImageArray indexOfObject:moreVC.dataObject];
     
    }
    
    if (index == NSNotFound) {
        
        return nil;
    }
    
    index++;
    
    if (index == [self.bannerImageArray count] && self.bannerImageArray.count!=0) {
        
        index = 0;
    }
    
    return [self viewControllerAtIndex:index];
    
}
- (BinnerTwoViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    if (([self.bannerImageArray count] == 0) || (index >= [self.bannerImageArray count])) {
        return nil;
    }
    // 创建一个新的控制器类，并且分配给相应的数据
    BinnerTwoViewController *binnerVC = [[BinnerTwoViewController alloc] init];
    binnerVC.dataObject = [self.bannerImageArray objectAtIndex:index];
    return binnerVC;
    
}
- (NSUInteger)indexOfViewController:(BinnerTwoViewController *)viewController {
    
    if (!(self.bannerImageArray.count == 0)) {
        
        return [self.bannerImageArray indexOfObject:viewController.dataObject];
  
    }
    return 0;
    
}

-(void)backButtonMethod
{

    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)clickTap:(UITapGestureRecognizer*)gettap
{
    
    //跳转到产品详情视图控制器

    GoodDetailViewController* activityDetail = [[GoodDetailViewController alloc]init];
    
    UINavigationController* navigationVC = [[UINavigationController alloc]
                                    initWithRootViewController:activityDetail];
    activityDetail.detailString = detailProduct.description;
    activityDetail.syBaseString = detailProduct.sybase;
    
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        activityDetail.edgesForExtendedLayout = NO;
    }
    [self presentViewController:navigationVC animated:YES completion:nil];

}
-(void)clickEvaluateTap:(UITapGestureRecognizer*)tap
{
  
    //跳转到产品评论视图控制器

    GoodsEvaluatesViewController* goodEvaluate = [[GoodsEvaluatesViewController alloc]init];
    UINavigationController* na = [[UINavigationController alloc]
                                      initWithRootViewController:goodEvaluate];
   //保存当前厂品的ID
    [[NSUserDefaults standardUserDefaults] setObject:
                          [NSNumber numberWithInt:detailProduct.productID]
                                                    forKey:@"currentProductID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        goodEvaluate.edgesForExtendedLayout = NO;
    }
    [self presentViewController:na animated:YES completion:^{
       
        NSLog(@"finshed");
        
        
    }];
}

- (void)saveMethod:(UITapGestureRecognizer*)tap
{
    dispatch_queue_t queue = dispatch_queue_create("com.MysaveQueue.queue", NULL);
    dispatch_async(queue, ^{
        if ([[Member sharedMember] hasLogined]) {
            if (hasCollected) {
                Result* result = [[Member sharedMember] removeCollectProduct:self.productID];
                if (result.isSuccess) {
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        
                        if (cancelBlackView ==nil) {
                            
                            cancelBlackView = [[UIView alloc]initWithFrame:CGRectMake(60.0, 200.0, 200, 50)];
                            cancelBlackView.backgroundColor = [UIColor blackColor];
                            cancelBlackView.layer.cornerRadius = 8;
                            cancelBlackView.alpha = 0.7;
                            cancelBlackView.layer.masksToBounds = YES;
                            cancelLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, 150, 30)];
                            cancelLabel.text = @"取消成功";
                            cancelLabel.textColor = [UIColor whiteColor];
                            [cancelBlackView addSubview:cancelLabel];
                        }
                        
                        [self.view addSubview:cancelBlackView];
                        
                        collectLabel.frame = CGRectMake(22, 5, 50, 30);
                        
                        collectLabel.text = @"收藏";
                        
                        hasCollected = NO;
                        
                        [self performSelector:@selector(removeBlackViewMethod) withObject:nil afterDelay:3];
                        
                    });
                }
                
            } else {
                
                Result* result = [[Member sharedMember] collectProduct:self.productID.integerValue];
                if (result.isSuccess) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (blackView == nil) {
                            blackView = [[UIView alloc]initWithFrame:CGRectMake(60.0, 200.0, 200, 50)];
                            blackView.backgroundColor = [UIColor blackColor];
                            blackView.layer.cornerRadius = 8;
                            blackView.layer.masksToBounds = YES;
                            blackView.alpha = 0.7;
                            onBlackViewlabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, 150, 30)];
                            onBlackViewlabel.text = @"收藏成功";
                            onBlackViewlabel.textColor = [UIColor whiteColor];
                            [blackView addSubview:onBlackViewlabel];
                        }
                        
                        [self.view addSubview:blackView];
                        
                        collectLabel.frame = CGRectMake(7, 5, 60, 30);
                        
                        collectLabel.text = @"取消收藏";
                        hasCollected = YES;
                        
                        [self performSelector:@selector(removeBlackViewMethod) withObject:nil afterDelay:3];
                        
                    });
                    
                }
                
                
            }
            
        }  else  {
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                LoginViewController* loginVC = [[LoginViewController alloc]init];
                
                UINavigationController* na = [[UINavigationController alloc]
                                              initWithRootViewController:loginVC];
                if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                    loginVC.edgesForExtendedLayout = NO;
                }
                [self presentViewController:na animated:YES completion:nil];
                
            });
            
        }
        
});
   

}

-(void)removeBlackViewMethod
{
    [blackView removeFromSuperview];
    [cancelBlackView removeFromSuperview];
    
}

- (void)changeBannerIndex:(NSNotification *)notification
{
    NSString *imageURL = [notification.object objectForKey:@"dataObject"];
    coustomPageControl.currentPage = [self.bannerImageArray indexOfObject:imageURL];
 	[coustomPageControl setOnColor: [UIColor colorWithCGColor:
                                UIColorFromRGB(127.0, 127.0, 127.0).CGColor]];
	[coustomPageControl setOffColor:  [UIColor colorWithCGColor:
                                 UIColorFromRGB(127.0, 127.0, 127.0).CGColor]] ;
}
@end
