//
//  SearchViewController.m
//  domcom.Goclay
//
//  Created by 马峰 on 14-3-12.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import "SearchViewController.h"
#import "BinnerViewController.h"
#import "GoodsListViewController.h"
#import "SearchResultViewController.h"
#import "Macros.h"
#import "FilterViewController.h"
#import "CoustomPageControl.h"
#import "TitleView.h"
#import "DetailViewController.h"
#import "Result.h"
#import "Banner.h"
#import "Product.h"
#import "AFNetworkReachabilityManager.h"
#import "DACircularProgressView.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "Product.h"
#import "CustomMarcos.h"

#define kImageWidth  155.0
#define kImageHeight 165.0
#define LIMIT 6

@interface SearchViewController ()
{
//    UISearchBar* titleSearchBar;
    UIScrollView* mainScrollView;
    UIView* contentView;
    NSMutableArray* searchResultArray;
    UITableView* mainTableView;
    NSMutableArray* array;
    BOOL isFind;
    UITapGestureRecognizer* viewTapGesture;
    UIImage* lineImage ;
    CoustomPageControl *coustomPageControl;
    TitleView* titleView;
//    UIButton* cancelButton;
    BOOL isEnter;
    UITapGestureRecognizer* closeKeyboardGesture;
//    UIImageView* leftImageView;
    BOOL hasSearched;
    UIActivityIndicatorView* activityIndicatorView;
    NSArray* getProductArray;
    NSMutableArray* searchIDArray;
    UIImageView* moreImageView;
}

@property(nonatomic,strong) NSArray* bannerArray;
@property(nonatomic,strong) NSMutableArray* homeImageArray;
@property(nonatomic,strong) NSMutableArray* homeTitleImageArray;
@property(nonatomic,strong) NSMutableArray* productImageArray;
@property(nonatomic,strong) NSMutableArray* productTitleArray;
@property(nonatomic,strong) NSMutableArray* productIDArray;

//获取网络数据。
- (void)getWebServiceData;

@end

@implementation SearchViewController


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
    
    NSLog(@"SearchViewController viewDidLoad");
    
    
    
    // Logo
    UIImageView *logoImageView = [[UIImageView alloc] init];
    logoImageView.image = [UIImage imageNamed:@"tabbar.png"];
    logoImageView.frame = CGRectMake(0.0,
                                     0.0,
                                     logoImageView.image.size.width,
                                     logoImageView.image.size.height);
    self.navigationItem.titleView = logoImageView;


    // Search
    UIImage* searchIconImage = [UIImage imageNamed:@"SearchIcon"];
    UIButton* searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(0.0,
                                    0.0,
                                    searchIconImage.size.width,
                                    searchIconImage.size.height);
    [searchButton setImage:searchIconImage forState:UIControlStateNormal];
    [searchButton addTarget:self
                     action:@selector(searchButtonTapped:)
           forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"SearchViewController viewWillAppear");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ENABLED_VIEW_DECK_NOTIFICATION
                                                        object:self
                                                      userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:FILTER_SIDEBAR_OPTION_RESETED_NOTIFICATION
                                                        object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:FILTER_SIDEBAR_PUSH_SETTING_CHANGED_NOTIFICATION
                                                        object:self
                                                      userInfo:@{FILTER_SIDEBAR_PUSH_SETTING_IS_PUSH: @1}];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pushProduct:)
                                                 name:PUSH_PRODUCT_NOTIFICATION
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pushProductSearch:)
                                                 name:PUSH_PRODUCT_SEARCH_NOTIFICATION
                                               object:nil];

    
    //判断是否进入
    NSLog(@"isEnter = %i", isEnter);
    
    if (isEnter) {

        
        return;
    } else {
        //准备数据源。
    
    
        //创建scrollview
        mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0,
                                                                        0.0,
                                                                        self.view.frame.size.width,
                                                                        self.view.frame.size.height)];
        mainScrollView.showsHorizontalScrollIndicator = YES;
        mainScrollView.delegate = self;
        mainScrollView.userInteractionEnabled = YES;
        mainScrollView.backgroundColor = UIColorFromRGB(235.0, 239.0, 241.0);
        [self.view addSubview:mainScrollView];

    
        //创建tableview
        mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0,
                                                                      0.0,
                                                                      self.view.frame.size.width,
                                                                      self.view.frame.size.height)
                                                    style:UITableViewStylePlain];
        mainTableView.contentSize = CGSizeMake(self.view.frame.size.width,
                                               self.view.frame.size.height);
        mainTableView.delegate = self;
        mainTableView.hidden = YES;
        mainTableView.dataSource = self;
        mainTableView.userInteractionEnabled = YES;
        [self.view addSubview:mainTableView];


        //pageController下面的view
        UIImage* moreImage = [UIImage imageNamed:@"middleImage.png"];
        moreImageView = [[UIImageView alloc] init];
        moreImageView.frame = CGRectMake(5.0, 215.0, 310.0, moreImage.size.height + 5.0);
        moreImageView.image = moreImage;
        moreImageView.userInteractionEnabled = YES;
        [mainScrollView addSubview:moreImageView];


        UILabel* goodsLabel = [[UILabel alloc] init];
        goodsLabel.frame = CGRectMake(10.0, 0.0, 100.0, moreImageView.frame.size.height);
        goodsLabel.font = [UIFont systemFontOfSize:15];
        goodsLabel.text = @"新品推荐";
        goodsLabel.textColor = UIColorFromRGB(49.0, 49.0, 49.0);
        [moreImageView addSubview:goodsLabel];

    
        UIImage* arrowImage = [UIImage imageNamed:@"arrow.png"];
        UIImageView* arrowImageView = [[UIImageView alloc] init];
        arrowImageView.frame = CGRectMake(moreImageView.frame.size.width - arrowImage.size.width - 10.0,
                                          (moreImageView.frame.size.height - arrowImage.size.height) / 2.0,
                                          arrowImage.size.width,
                                          arrowImage.size.height);
        arrowImageView.image = arrowImage;
        [moreImageView addSubview:arrowImageView];


        UIButton* moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        moreButton.frame = CGRectMake(CGRectGetMaxX(arrowImageView.frame) - 40.0,
                                      (moreImageView.frame.size.height - 20.0) / 2.0,
                                      40.0,
                                      20.0);
        [moreButton setTitle:@"更多" forState:UIControlStateNormal];
        [moreButton setTitleColor:UIColorFromRGB(150.0, 150.0, 150.0)
                         forState:UIControlStateNormal];
        [moreButton addTarget:self
                       action:@selector(moreButton:)
             forControlEvents:UIControlEventTouchUpInside];
        moreButton.titleLabel.font = [UIFont systemFontOfSize:11];
        [moreImageView addSubview:moreButton];

    

        isEnter = YES;
    
        [self getWebServiceData];

    }
    
    activityIndicatorView = [[UIActivityIndicatorView alloc]
                             initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    activityIndicatorView.frame = CGRectMake((self.view.frame.size.width - 100.0) / 2.0,
                                             (self.view.frame.size.height - 100.0) / 2.0, 100.0, 100.0);
    activityIndicatorView.backgroundColor = [UIColor blackColor];
    activityIndicatorView.layer.cornerRadius = 10.0;
    activityIndicatorView.alpha = 0.5;
    [activityIndicatorView startAnimating];
    [self.view addSubview:activityIndicatorView];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DISABLED_VIEW_DECK_NOTIFICATION
                                                        object:self
                                                      userInfo:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)createProductView
{
    //行的个数。
    NSInteger rowCount = ceilf((getProductArray.count) / 2.0);
    if (rowCount < 2) {
        rowCount = 2;
    }

    
    
    //重新设置mainScrollView的高度
    CGFloat height = 198.0 + kImageHeight * rowCount;
    if (IOS_VERSION_LESS_THAN(@"7.0")) {
        height += 65.0;
    }
    [self resetScrollViewFrame:self height:height];
    
    for (int i = 0; i < getProductArray.count; i++) {
        
        Product* list = (Product*)[getProductArray objectAtIndex:i];
        
        CGFloat x;

        NSInteger row = floor(i / 2.0);
        
        if (i % 2 == 0) {
            x = 4.5;
        } else {
            x = 4.5 + kImageWidth;
        }
        CGFloat y = 215 + 40.0 + kImageHeight * row;
        
        contentView = [[UIView alloc] init];
        contentView.frame = CGRectMake(x, y, kImageWidth, kImageHeight);
        [contentView.layer setBorderWidth:0.25];
        if (IOS_VERSION_LESS_THAN(@"7.0")) {
            [contentView.layer setBorderWidth:0.45];
        }
        [contentView.layer setBorderColor:UIColorFromRGB(219.0, 219.0, 219.0).CGColor];
        contentView.tag = i;
        [contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"contentViewbackImage"]]];
        
        viewTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                 action:@selector(clickProductTapGesture:)];
        [contentView addGestureRecognizer:viewTapGesture];
        
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 135, contentView.frame.size.width, 30)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:11];
        label.textColor = UIColorFromRGB(68.0, 68.0, 68.0);
        [mainScrollView addSubview:contentView];
        
        //contentView上的两个子视图middleImageView | label
        UIImageView* middleImageView = [[UIImageView alloc] initWithFrame:CGRectMake((contentView.frame.size.width - 150.0) / 2.0,
                                                                                     20.0,
                                                                                     150.0,
                                                                                     116.0)];
        
        middleImageView.backgroundColor = [UIColor lightGrayColor];
        
        if (list.imageURLString != nil) {
            DACircularProgressView* progressView = [[DACircularProgressView alloc]init];
            progressView.frame = CGRectMake((middleImageView.frame.size.width - 40.0) / 2.0,
                                            (middleImageView.frame.size.height - 40.0) / 2.0, 40.0, 40.0);
            progressView.backgroundColor = [UIColor grayColor];
            progressView.progress = 0.0;
            [contentView addSubview:progressView];
            

            [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:list.imageURLString] options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                [progressView setProgress:((double)receivedSize / (double)expectedSize) animated:YES];
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                if (finished && !error) {
                    [progressView setProgress:1.0 animated:YES];
                    middleImageView.image = image;
                }
                
                [progressView removeFromSuperview];
            }];
        }
        
        label.text = list.title;
//        contentView.backgroundColor = [UIColor greenColor];
//        contentView.alpha  = 0.5;
        [contentView addSubview:middleImageView];
        [contentView addSubview:label];
    }
}


//获取网络数据。
-(void)getWebServiceData
{
    NSLog(@"getWebServiceData");
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        Result* result = [Banner requestList];
        if (result.isSuccess) {

            NSArray* bannerArray = (NSArray*)result.data;
            self.bannerArray = [NSArray arrayWithArray:bannerArray];
            self.homeImageArray = [NSMutableArray array];
            self.homeTitleImageArray = [NSMutableArray array];
            
            for (Banner* model in bannerArray) {
                [self.homeImageArray addObject:model.imageURLString];
                [self.homeTitleImageArray addObject:model.title];
            }

            dispatch_async(dispatch_get_main_queue(), ^{
                //创建pageController
                NSDictionary* dic = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                                                forKey:UIPageViewControllerOptionSpineLocationKey];

                self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:
                                       UIPageViewControllerTransitionStyleScroll navigationOrientation:
                                       UIPageViewControllerNavigationOrientationHorizontal options:dic];
                pageController.dataSource = self;
                pageController.delegate = self;
                pageController.view.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, 210.0);
                pageController.view.backgroundColor = [UIColor whiteColor];


                BinnerViewController* binnerView = [self viewControllerAtIndex:0];
                if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                    binnerView.edgesForExtendedLayout = NO;
                }

                NSArray* viewcontrollers = [NSArray arrayWithObject:binnerView];
                [pageController setViewControllers:viewcontrollers direction:
                 UIPageViewControllerNavigationDirectionForward animated:NO
                                        completion:nil];
                [self addChildViewController:pageController];
                [mainScrollView addSubview:pageController.view];

                
                //自定义UIPageControl
                coustomPageControl = [[CoustomPageControl alloc] init] ;
                coustomPageControl.frame = CGRectMake(270.0, pageController.view.frame.size.height - 34.0, 120.0, 25.0);
                [coustomPageControl setNumberOfPages:self.bannerArray.count];
                [coustomPageControl setCurrentPage:0];
                [coustomPageControl setDefersCurrentPageDisplay:YES];
                [coustomPageControl setType:DDPageControlTypeOnFullOffEmpty];
                [coustomPageControl setOnColor:[UIColor whiteColor]];
                [coustomPageControl setOffColor:[UIColor whiteColor]];
                [coustomPageControl setIndicatorDiameter:6.0];
                [coustomPageControl setIndicatorSpace:5.0];
                [pageController.view addSubview:coustomPageControl];
            });
        }
    });
    
    dispatch_group_async(group, queue, ^{
        Result* productResult = [Product requestListWithIsRecommend:@1
                                                  productCategoryID:@-1
                                                     productBrandID:@-1
                                                      searchKeyword:@""
                                                             offset:0
                                                              limit:LIMIT];
        if (productResult.isSuccess) {
            getProductArray = (NSArray*)productResult.data;
            self.productImageArray = [NSMutableArray array];
            self.productTitleArray = [NSMutableArray array];
            self.productIDArray = [NSMutableArray array];
            
            for (Product* model  in getProductArray) {
                [self.productIDArray addObject:[NSNumber numberWithInt:model.productID]];
                [self.productImageArray addObject:model.imageURLString];
                [self.productTitleArray addObject:model.title];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self createProductView];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString* error = [productResult.error.userInfo objectForKey:NSLocalizedDescriptionKey];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:error delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            });
        }
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [activityIndicatorView removeFromSuperview];
    });
}

//关闭键盘
- (void)close
{

    [titleView setIsZoomSearchBar:NO];
}

#pragma mark UIPageViewControllerDataSource Method
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    BinnerViewController* binnerVC =(BinnerViewController*) viewController;
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        binnerVC.edgesForExtendedLayout = NO;
    }
    
    NSUInteger index = [self indexOfViewController:binnerVC];
    if (index == NSNotFound) {
        return nil;
    }
    
    index--;
    
    if (index == -1) {
        index = [self.homeImageArray count] - 1;
    }
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    BinnerViewController *moreVC = (BinnerViewController *)viewController;
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        moreVC.edgesForExtendedLayout = NO;
    }
    
    NSInteger index = [self.homeImageArray indexOfObject:moreVC.dataObject];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.homeImageArray count]) {
        index = 0;
    }
    
    return [self viewControllerAtIndex:index];
}

- (BinnerViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.homeImageArray count] == 0) || (index >= [self.homeImageArray count])) {
        return nil;
    }
    
    // 创建一个新的控制器类，并且分配给相应的数据
    BinnerViewController *dataViewController = [[BinnerViewController alloc] init];
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        dataViewController.edgesForExtendedLayout = NO;
    }
    
    Banner* model = (Banner*)[self.bannerArray objectAtIndex:index];
    dataViewController.dataObject = model.imageURLString;
    dataViewController.titleString = model.title;
    dataViewController.currentIndex = index;
    
    return dataViewController;
    
}

- (NSUInteger)indexOfViewController:(BinnerViewController *)viewController
{
    return [self.homeImageArray indexOfObject:viewController.dataObject];
}

#pragma mark UISearchbarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"searchBar searchBarShouldBeginEditing");
    
    //为当前视图控制器添加手势来关闭键盘
    if (closeKeyboardGesture == nil) {
        closeKeyboardGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                       action:@selector(closeKeyboard:)];
    }
    
    [self.view addGestureRecognizer:closeKeyboardGesture];

    [titleView setIsZoomSearchBar:YES];
    array = [[NSMutableArray alloc] init];
    [mainTableView reloadData];
     mainTableView.hidden = NO;

    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"searchBar textDidChange");
    
    
    //移除手势识别器
    [self.view removeGestureRecognizer:closeKeyboardGesture];
    
    //将数据源清空
    array = [NSMutableArray array];
    
    if ([searchText length] > 0) {
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            Result* productResult = [Product requestListWithIsRecommend:@0
                                                      productCategoryID:@-1
                                                         productBrandID:@-1
                                                          searchKeyword:searchText
                                                                 offset:0
                                                                  limit:100];
            if (productResult.isSuccess) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    searchResultArray = [NSMutableArray array];
                    searchResultArray = (NSMutableArray*)productResult.data;
                    searchIDArray = [NSMutableArray array];
                    for (Product* list in searchResultArray) {
                        [searchIDArray addObject:[NSNumber numberWithInt:list.productID]];
                    }
                    
                    //做标记
                    isFind = YES;
                    array = [NSMutableArray arrayWithArray:searchResultArray];
                    mainTableView.hidden = NO;
                    [mainTableView reloadData];
                });
            }
        });
    } else {
        [mainTableView reloadData];
    }
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"searchBarSearchButtonClicked");
    
    if (![searchBar.text isEqualToString:@""]) {
        isFind = YES;
        array = [NSMutableArray arrayWithArray:searchResultArray];
        [mainTableView reloadData];
        
        SearchResultViewController* searchResult = [[SearchResultViewController alloc]init];
        searchResult.productArray = array;
        if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            searchResult.edgesForExtendedLayout = NO;
        }
        [self.navigationController pushViewController:searchResult animated:YES];
//        self.tabBarController.tabBar.hidden = YES;
    } else {
        return;
    }
    
    [searchBar resignFirstResponder];

}

//关闭键盘
- (void)closeKeyboard:(UITapGestureRecognizer*)tapGesture
{
    if ([titleView.searchBar.text isEqualToString:@""]) {
        [titleView setIsZoomSearchBar:NO];
    
    }
}

#pragma mark UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = @"cellidenty";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:cellId];
    }
    if (isFind) {
        Product* list = array[indexPath.row];
        
        NSLog(@"list = %@",list.title);
        
        
        cell.textLabel.text = list.title;
    }
    
    //设置cell的选中背景
    UIImage* selectImage = [UIImage imageNamed:@"cellselectback.png"];
    UIImageView* cellImageView = [[UIImageView alloc]init];
    cellImageView.image = selectImage;
    cell.selectedBackgroundView = cellImageView;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    hasSearched = YES;
    NSInteger productID = [[searchIDArray objectAtIndex:indexPath.row] integerValue];
    DetailViewController* detailVC = [[DetailViewController alloc] initWithProductID:[NSNumber numberWithInteger:productID]];
    detailVC.hidesBottomBarWhenPushed = YES;
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        detailVC.edgesForExtendedLayout = NO;
    }
    [self.navigationController pushViewController:detailVC animated:YES];
}

//- (void)changeBannerIndex:(NSNotification *)notification
//{
//    NSString *imageURLString = [notification.object objectForKey:@"dataObject"];
//    coustomPageControl.currentPage = [self.homeImageArray indexOfObject:imageURLString];
//    [coustomPageControl setOnColor:[UIColor whiteColor]];
//	[coustomPageControl setOffColor:[UIColor whiteColor]];
//}


//点击更多按钮响应方法
- (IBAction)moreButton:(UIButton *)sender
{

//    BigTwoViewController *bigVC = [[BigTwoViewController alloc] init];
//    bigVC.isRecommend = @1;
//    bigVC.productCategoryId = @-1;
//    bigVC.productBrandId = @-1;
//    bigVC.searchKeyword = @"";
//    bigVC.hidesBottomBarWhenPushed = YES;
//    self.navigationController.navigationBarHidden = YES;
//    [self.navigationController pushViewController:bigVC animated:YES];    
    GoodsListViewController *goodListVC = [[GoodsListViewController alloc] initWithIsRecommend:@1 productCategoryID:@0 productBrandID:@0 searchKeyword:@""];
//    goodListVC.isRecommend = @1;
//    goodListVC.productCategoryId = @-1;
//    goodListVC.productBrandId = @-1;
//    goodListVC.searchKeyword = @"";
    goodListVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodListVC animated:YES];
}

#pragma mark UITapGestureRecognizerMethod
//每一个view响应的方法
- (void)clickProductTapGesture:(UITapGestureRecognizer*)tap
{
    DetailViewController* detailVC = [[DetailViewController alloc]init];
    detailVC.productID = self.productIDArray[tap.view.tag];
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        detailVC.edgesForExtendedLayout = NO;
    }
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark UIScrollViewDelegate Method
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"scrollView %@", scrollView);
    
    if ([scrollView isMemberOfClass:[UIScrollView class]]) {
//        leftImageView.hidden = NO;
//        [titleView setIsHideLogo:NO];
        //关闭键盘
//        [self close];
    } else {
//        leftImageView.hidden = YES;
//        [titleView setIsHideLogo:YES];
//        [titleSearchBar resignFirstResponder];
        [titleView.searchBar resignFirstResponder];
    }
}

//重设mainScrollView的contentSize高度
- (void)resetScrollViewFrame:(SearchViewController*)search height:(CGFloat)height
{
    search.view.frame = CGRectMake(search.view.frame.origin.x,
                                   search.view.frame.origin.y,
                                   self.view.frame.size.width,
                                   height);
    mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width,
                                            CGRectGetMaxY(search.view.frame));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark TitleViewDelegate
- (void)didClickedCloseButton
{
    NSLog(@"didClickedCloseButton");
    mainTableView.hidden = YES;
//    self.tabBarController.tabBar.hidden = NO;
}

- (void)searchButtonTapped:(UIButton *)button
{
    NSLog(@"searchButtonTapped %@", button);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TOGGLE_FILTER_SIDEBR_NOTIFICATION
                                                        object:self
                                                      userInfo:nil];
    
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    NSLog(@"pageViewController didFinishAnimating");
    
    if (completed) {
        BinnerViewController *currentVC = (BinnerViewController *)[pageViewController.viewControllers lastObject];
        [coustomPageControl setCurrentPage:currentVC.currentIndex];
        [coustomPageControl setOnColor:[UIColor whiteColor]];
        [coustomPageControl setOffColor:[UIColor whiteColor]];

        NSLog(@"coustomPageControl.currentPage %i", coustomPageControl.currentPage);
    }
}


- (void)pushProduct:(NSNotification *)notification
{
    NSLog(@"pushProduct %@", notification);
    //    [self.viewDeckController closeRightViewAnimated:NO];
    
    NSNumber *productID = [[notification object] objectForKey:PRODUCT_ID];
    DetailViewController *productVC = [[DetailViewController alloc] initWithProductID:productID];
    productVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:productVC animated:NO];
}

- (void)pushProductSearch:(NSNotification *)notification
{
    NSLog(@"pushProductBrand %@", notification);
    //    [self.viewDeckController closeRightViewAnimated:NO];
    
    NSNumber *productCategoryID = [[notification object] objectForKey:FILTER_SIDEBAR_OPTION_PRODUCT_CATEGORY_ID];
    if (productCategoryID == nil) {
        productCategoryID = @0;
    }
    
    NSNumber *productBrandID = [[notification object] objectForKey:FILTER_SIDEBAR_OPTION_PRODUCT_BRAND_ID];
    if (productBrandID == nil) {
        productBrandID = @0;
    }
    
    NSString *searchKeyword = [[notification object] objectForKey:FILTER_SIDEBAR_OPTION_PRODUCT_SEARCH_KEYWORD];
    if (searchKeyword == nil) {
        searchKeyword = @"";
    }

    
    GoodsListViewController *goodsListVC = [[GoodsListViewController alloc] initWithIsRecommend:@0 productCategoryID:productCategoryID productBrandID:productBrandID searchKeyword:searchKeyword];
    goodsListVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodsListVC animated:NO];
}

@end
