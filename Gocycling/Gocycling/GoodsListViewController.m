//
//  GoodsListViewController.m
//  domcom.Goclay
//
//  Created by Apple on 14-3-14.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import "GoodsListViewController.h"
#import "FilterViewController.h"
#import "DetailViewController.h"
#import "Macros.h"
#import "Product.h"
#import "Result.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "DACircularProgressView.h"
#import "CustomMarcos.h"
#define LIMIT 12

#define kProductImageWidth 151.0
#define kProductImageHeight 189.0

@interface GoodsListViewController ()
{
    BOOL isEnter;
    UIScrollView* mainScrollView;
    NSArray* productArray;
    UIImageView* goodsImageView;
}

@property (nonatomic, strong) NSNumber* isRecommend;
@property (nonatomic, strong) NSNumber* productCategoryID;
@property (nonatomic, strong) NSNumber* productBrandID;
@property (nonatomic, strong) NSString* searchKeyword;
@property (nonatomic, strong) NSMutableArray* productListImageArray;
@property (nonatomic, strong) NSMutableArray* productTitleArray;
@property (nonatomic, strong) NSMutableArray* productPriceArray;
@property (nonatomic, strong) NSMutableArray* productIDArray;

//创建产品列表下的view
//-(void)createGoodsListView;
@end

@implementation GoodsListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id)initWithIsRecommend:(NSNumber *)isRecommend productCategoryID:(NSNumber *)productCategoryID productBrandID:(NSNumber *)productBrandID searchKeyword:(NSString *)searchKeyword
{
    self = [super init];
    if (self) {
        self.isRecommend = isRecommend;
        self.productCategoryID = productCategoryID;
        self.productBrandID = productBrandID;
        self.searchKeyword = searchKeyword;
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(235.0, 239.0, 241.0);

    //navigationItem的titleView
//    UILabel* lable = [[UILabel alloc]initWithFrame:CGRectMake(160, 0, 40, 30)];
//    lable.textColor = [UIColor whiteColor];
//    lable.backgroundColor = [UIColor clearColor];
//    lable.textAlignment = NSTextAlignmentCenter;
//    lable.text = NSLocalizedString(@"产品列表", nil);
//    self.navigationItem.titleView = lable;
    self.title = @"产品列表";
    
    
    
    
    
    //返回的leftBarButtonItem
    UIImage* leftButtonImage = [UIImage imageNamed:@"arrowback.png"];
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0.0,
                                  0.0,
                                  leftButtonImage.size.width,
                                  leftButtonImage.size.height);
    [leftButton setImage:leftButtonImage forState:UIControlStateNormal];
    [leftButton addTarget:self
                   action:@selector(backButtonMethod)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;


    
    //rightBarButtonItem
    UIImage* rightButtonImage = [UIImage imageNamed:@"rightbarItem.png"];
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0.0,
                                   0.0,
                                   rightButtonImage.size.width,
                                   rightButtonImage.size.height);
    [rightButton setImage:rightButtonImage forState:UIControlStateNormal];
    [rightButton addTarget:self
                    action:@selector(rightButtonMethod)
          forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ENABLED_VIEW_DECK_NOTIFICATION
                                                        object:self
                                                      userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:FILTER_SIDEBAR_PUSH_SETTING_CHANGED_NOTIFICATION
                                                        object:self
                                                      userInfo:@{FILTER_SIDEBAR_PUSH_SETTING_IS_PUSH: @0}];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(filterSidebarOptionUpdated:)
                                                 name:FILTER_SIDEBAR_OPTION_UPDATED_NOTIFICATION
                                               object:nil];

    
    if (isEnter) {
        return;
    } else {
        isEnter = YES;
    }
    
    
    //获取网络数据
    [self getWebServiceData];
    
    //创建产品列表下的view
//    [self createGoodsListView];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DISABLED_VIEW_DECK_NOTIFICATION
                                                        object:self
                                                      userInfo:nil];
}

-(void)getWebServiceData
{
    NSLog(@"getWebServiceData");

    NSLog(@"isRecommend %@", self.isRecommend);
    NSLog(@"productCategoryID %@", self.productCategoryID);
    NSLog(@"productBrandID %@", self.productBrandID);
    NSLog(@"searchKeyword %@", self.searchKeyword);

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        Result* productResult = [Product requestListWithIsRecommend:self.isRecommend
                                                  productCategoryID:self.productCategoryID
                                                     productBrandID:self.productBrandID
                                                      searchKeyword:self.searchKeyword
                                                             offset:0
                                                              limit:LIMIT];
        if (productResult.isSuccess) {
            productArray = (NSArray*)productResult.data;
            NSLog(@"productArray %i", [productArray count]);

            self.productListImageArray = [NSMutableArray arrayWithCapacity:1];
            self.productPriceArray = [ NSMutableArray arrayWithCapacity:1];
            self.productTitleArray = [NSMutableArray arrayWithCapacity:1];
            self.productIDArray = [NSMutableArray arrayWithCapacity:1];
            
            for (Product* model in productArray) {
                [self.productTitleArray addObject:model.title];
                [self.productPriceArray addObject:[NSNumber numberWithInt:model.productID]];
                [self.productListImageArray addObject:model.imageURLString];
                [self.productIDArray addObject:[NSNumber numberWithInt:model.productID]];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createGoodsListView];
        });
    });
}


//创建产品列表下的view
-(void)createGoodsListView
{
    CGFloat dividingDistance = (self.view.frame.size.width - kProductImageWidth * 2.0) / 3.0;
    
    //行的个数。
    NSInteger rowCount = ceilf((productArray.count)/2.0);
    
    if (rowCount < 2) {
        rowCount = 2;
    }
    
//    CGFloat height = 64 + dividingDistance * (rowCount + 1) + kProductImageHeight * rowCount;
    CGFloat height = dividingDistance * (rowCount + 1) + kProductImageHeight * rowCount;

    
    
    NSLog(@"%f",height);
    
    
    if (!mainScrollView) {
        mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0,
                                                                       0.0,
                                                                       self.view.frame.size.width,
                                                                       self.view.frame.size.height)];
    }
//    mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width,
//                                            self.view.frame.size.height + 30);
    mainScrollView.showsHorizontalScrollIndicator = YES;
    mainScrollView.userInteractionEnabled = YES;
//    mainScrollView.backgroundColor = [UIColor redColor];
    [self.view addSubview:mainScrollView];
    
//    return;
    
    
    
    //重新设置mainScrollView的高度
    [self resetProductScrollViewFrame:self height:height];
    
    
    for (int i = 0; i < productArray.count;  i++) {
        
        
        Product* productList = [productArray objectAtIndex:i];
        
        UIImage* image = [UIImage imageNamed:@"backimage.png"];
        
        goodsImageView = [[UIImageView alloc] init];
        
        NSUInteger row = floor(i / 2.0);
        
        CGFloat x = 0.0;
        
        if (i% 2 == 0) {
            x = dividingDistance;
        } else {
            x = dividingDistance * 2.0 + kProductImageWidth;
        }
        
        CGFloat y = dividingDistance * (row +1 ) + kProductImageHeight * row;
        

        goodsImageView.frame = CGRectMake(x, y, kProductImageWidth, kProductImageHeight);
        goodsImageView.image = image;
        if (IOS_VERSION_LESS_THAN(@"7.0")) {
            UIImage* image = [UIImage imageNamed:@"collectbackImage.png"];
            goodsImageView.image = image;
        }
        
        goodsImageView.layer.cornerRadius = 3.0;
        goodsImageView.tag = i;
        goodsImageView.layer.masksToBounds = YES;
        goodsImageView.userInteractionEnabled = YES;
        
        [mainScrollView addSubview:goodsImageView];
        
        UIImage* lineImage = [UIImage imageNamed:@"viewline.png"];
        UIImageView* lineImageView = [[UIImageView alloc]initWithFrame:
                                      CGRectMake(0, 150,
                                                 lineImage.size.width,
                                                 lineImage.size.height)];
        lineImageView.image = lineImage;
        [goodsImageView addSubview:lineImageView];
        
        
        
        UIImageView* middleImageView = [[UIImageView alloc]initWithFrame:
                                        CGRectMake(0, 0,
                                                   150.0,103)];
        if (productList.imageURLString != nil) {
            
            DACircularProgressView* progressView = [[DACircularProgressView alloc]init];
            progressView.frame = CGRectMake((middleImageView.frame.size.width - 20)/2.0, (middleImageView.frame.size.height - 20)/2.0, 20.0, 20.0);
            
            progressView.progress = 0.0;
            [middleImageView addSubview:progressView];
            
            [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:productList.imageURLString] options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
                [progressView setProgress:((double)receivedSize/(double)expectedSize) animated:YES];
                
                
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                
                if (finished && error ==nil) {
                    
                    
                    middleImageView.image = image;
                    
                }
                
                [progressView removeFromSuperview];
                
            }];
            
            
            
        }
        
        
        [goodsImageView addSubview:middleImageView];
        
        
        UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 154, 150, 15)];
        titleLabel.font = [UIFont systemFontOfSize:11];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = productList.title;
        titleLabel.textColor = UIColorFromRGB(68.0, 68.0, 68.0);
        [goodsImageView addSubview:titleLabel];
        
        
        UILabel* subtitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 173, 150, 8)];
        subtitleLabel.font = [UIFont systemFontOfSize:10];
        subtitleLabel.text = [NSString stringWithFormat:@"￥%0.f", productList.productPrice];
        subtitleLabel.backgroundColor = [UIColor clearColor];
        subtitleLabel.textColor = UIColorFromRGB(230.0, 0.0, 18.0);
        [goodsImageView addSubview:subtitleLabel];
        
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(pressed:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        tapGestureRecognizer.numberOfTouchesRequired = 1;
        [goodsImageView addGestureRecognizer:tapGestureRecognizer];
        
    }

    
    

 
    
}

#pragma mark clickUiimageViewDelegate
//goodListController上的contentview的点击响应方法
-(void)pressed:(UITapGestureRecognizer*)tap
{
    NSLog(@"pressed");
    
    NSInteger productID = [[self.productIDArray objectAtIndex:tap.view.tag] intValue];
    
    DetailViewController* detailVC = [[DetailViewController alloc] initWithProductID:[NSNumber numberWithInteger:productID]];
    detailVC.hidesBottomBarWhenPushed = YES;
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        detailVC.edgesForExtendedLayout = NO;
        
    }
    [self.navigationController pushViewController:detailVC animated:YES];
}

//返回代理方法
-(void)backButtonMethod
{
//        [self.toogleClickDelegate toggleClickButton:self];
    [self.navigationController popViewControllerAnimated:YES];
}

//右button响应的代理方法
- (void)rightButtonMethod
{
    
    
//    [self.toogleClickDelegate toggleClickButton:nil];
 
    [[NSNotificationCenter defaultCenter] postNotificationName:TOGGLE_FILTER_SIDEBR_NOTIFICATION
                                                        object:self
                                                      userInfo:nil];

    
}


-(void)resetProductScrollViewFrame:(GoodsListViewController*)collect height:(CGFloat)height
{
    
    NSLog(@"%f",height);
    
    NSLog(@"search =  %@",NSStringFromCGRect(collect.view.frame));
    
    
//    collect.view.frame = CGRectMake(self.view.frame.origin.x,
//                                    self.view.frame.origin.y,
//                                    self.view.frame.size.width,
//                                    height);
    
    mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width, height);
    
    NSLog(@"mainScrollView.contentSize.height = %f",mainScrollView.contentSize.height);
    
    
}


- (void)reloadData
{
    // Remove all views
    for (UIView *subview in mainScrollView.subviews) {
        [subview removeFromSuperview];
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        Result* result = [Product requestListWithIsRecommend:self.isRecommend
                                           productCategoryID:self.productCategoryID
                                              productBrandID:self.productBrandID
                                               searchKeyword:self.searchKeyword
                                                      offset:0
                                                       limit:LIMIT];
        if (result.isSuccess) {
            productArray = (NSArray*)result.data;

            self.productListImageArray = [NSMutableArray arrayWithCapacity:0];
            self.productPriceArray = [NSMutableArray arrayWithCapacity:0];
            self.productTitleArray = [NSMutableArray arrayWithCapacity:0];
            self.productIDArray = [NSMutableArray arrayWithCapacity:0];

            for (Product* model in productArray) {
                [self.productTitleArray addObject:model.title];
                [self.productPriceArray addObject:[NSNumber numberWithInt:model.productID]];
                [self.productListImageArray addObject:model.imageURLString];
                [self.productIDArray addObject:[NSNumber numberWithInt:model.productID]];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createGoodsListView];
        });
    });
}


- (void)filterSidebarOptionUpdated:(NSNotification *)notification
{
    NSLog(@"filterSidebarOptionUpdated %@", notification);
    
    NSNumber *productCategoryID = [[notification object] objectForKey:FILTER_SIDEBAR_OPTION_PRODUCT_CATEGORY_ID];
    if (productCategoryID == nil) {
        productCategoryID = @0;
    }
    self.productCategoryID = productCategoryID;
    
    NSNumber *productBrandID = [[notification object] objectForKey:FILTER_SIDEBAR_OPTION_PRODUCT_BRAND_ID];
    if (productBrandID == nil) {
        productBrandID = @0;
    }
    self.productBrandID = productBrandID;
    
    NSString *searchKeyword = [[notification object] objectForKey:FILTER_SIDEBAR_OPTION_PRODUCT_SEARCH_KEYWORD];
    if (searchKeyword == nil) {
        searchKeyword = @"";
    }
    self.searchKeyword = searchKeyword;
    
    [self reloadData];

}

@end
