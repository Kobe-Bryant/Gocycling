//
//  MyCollectViewController.m
//  doomcom.Goclaying
//
//  Created by Apple on 14-3-21.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import "MyCollectViewController.h"
#import "Macros.h"
#import "Result.h"
#import "Member.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "DACircularProgressView.h"
#import "DetailViewController.h"
#import "BrandGoodsViewController.h"
#import "Brand.h"
#import "Product.h"

#define LIMIT 6
#define kPageSize 5;

#define kProductImageWidth 151.0
#define kProductImageHeight 189.0

#define kBrandImageWidth   150.0
#define kBrandImageHeight 145.0


@interface MyCollectViewController ()
{

    UIImage* selectedImage;
    UIImageView* selectedImageView;
    UILabel* brandLabel;
    UILabel* goosLabel;
    UIScrollView* goodScrollView;
    UIScrollView* brandScrollerView;
    UIImageView* goodsImageView;
    UIImageView* brandImageView;
    NSArray* titleArray;
    UIView *leftSegmentView ;
    UIView *rightSegmentView ;
    BOOL isCreateBrandView;
    NSMutableArray* productArray ;
    NSMutableArray* productBrandArray;
    NSMutableArray* brandIDArray;
    NSMutableArray* productIDArray;
    BOOL isEnter;
    BOOL isEnterBrandDetail;
    
    
}
@property(nonatomic,assign) int offset;

//创建产品列表的视图
-(void)createGoodsListView;

//创建品牌列表的视图
-(void)createBrandListView;

-(void)getWebServiceData;



@end

@implementation MyCollectViewController

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

   
    
    
    self.view.backgroundColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                (235.0, 239.0, 241.0).CGColor];
    
    //设置navigationItem的titleView
    UILabel* lable = [[UILabel alloc]initWithFrame:CGRectMake(160, 0, 40, 30)];
    lable.textColor = [UIColor whiteColor];
    lable.backgroundColor = [UIColor clearColor];
    lable.text = NSLocalizedString(@"我的收藏", nil);
    lable.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = lable;
    
    //返回的leftBarButtonItem
    UIImage* image = [UIImage imageNamed:@"arrowback.png"];
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0,image.size.width, image.size.height);
    [leftButton setImage:image forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backButtonMethod)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //去掉navigationBar阴影

    
    UIImage* showImage = [UIImage imageNamed:@"navigationshadowImage.png"];
    self.navigationController.navigationBar.shadowImage =showImage;

      isCreateBrandView = NO;
    brandIDArray = [NSMutableArray array];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"MyCollectViewController =  %@", NSStringFromCGRect(self.view.frame));
    
    
    
    
    
//    
//    [self getWebServiceData];
//  
//
//    
//    if (isEnter) {
//   
//     
//        
//        return ;
//        
//    } else {
//        
//        self.tabBarController.tabBar.hidden = YES;
//
//        isEnter = YES;
//        
//        
//    }
    
    
    //navigationBar下面的线条
    UIImage* bardownImage = [UIImage imageNamed:@"navibarImage.png"];
    UIImageView* bardownImageView = [[UIImageView alloc]initWithFrame:CGRectMake
                    (0, 0, bardownImage.size.width, bardownImage.size.height)];
    
  
    
    bardownImageView.userInteractionEnabled = YES;
    bardownImageView.image = bardownImage;
    [self.view addSubview:bardownImageView];
    
    
    //大的segmentView
    UIView* segmentBigView = [[UIView alloc]initWithFrame:CGRectMake(10, 2, 300,32)];
    segmentBigView.userInteractionEnabled = YES;
    segmentBigView.backgroundColor = [UIColor whiteColor];
    [segmentBigView.layer setBorderColor:(__bridge CGColorRef)([UIColor
                colorWithCGColor:UIColorFromRGB(255.0, 255.0, 255.0).CGColor])];
    segmentBigView.layer.cornerRadius = 8;
    segmentBigView.layer.masksToBounds = YES;
    segmentBigView.layer.borderWidth = 5.0;
    [bardownImageView addSubview:segmentBigView];
    
    
    
    
    leftSegmentView = [[UIView alloc] initWithFrame:CGRectMake(2.0,
                                                             1.0,
                                    segmentBigView.frame.size.width / 2.0 - 1.0,
                                 segmentBigView.frame.size.height - 1.5 * 1.5)];
    leftSegmentView.backgroundColor = [UIColor whiteColor];
    
    
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:
    leftSegmentView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft
                                                  cornerRadii:CGSizeMake(7, 7)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = leftSegmentView.bounds;
    maskLayer.path = maskPath.CGPath;
    leftSegmentView.layer.mask = maskLayer;
    
    [segmentBigView addSubview:leftSegmentView];
    
    
    rightSegmentView = [[UIView alloc] initWithFrame:CGRectMake(150.0,
                                                             1,
                                    segmentBigView.frame.size.width / 2.0 - 1.0,
                                 segmentBigView.frame.size.height - 1.5 * 1.5)];
    
   rightSegmentView.backgroundColor = [UIColor colorWithCGColor:
                                     UIColorFromRGB(19.0, 104.0, 194.0).CGColor];
    
    
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:
        rightSegmentView.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight
                                                  cornerRadii:CGSizeMake(7, 7)];
    
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.frame = rightSegmentView.bounds;
    maskLayer1.path = maskPath1.CGPath;
    rightSegmentView.layer.mask = maskLayer1;
    
    [segmentBigView addSubview:rightSegmentView];
    
    
    
    

    goosLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 3, 100, 22)];
    goosLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB(19.0, 106.0, 194.0).CGColor];
    goosLabel.font = [UIFont systemFontOfSize:13];
    goosLabel.textAlignment = NSTextAlignmentLeft;
    goosLabel.backgroundColor = [UIColor clearColor];
    [leftSegmentView addSubview:goosLabel];
    
    
    brandLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 3, 100, 22)];
    brandLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB(255.0, 255.0, 255.0).CGColor];
    brandLabel.font = [UIFont systemFontOfSize:13];
    brandLabel.backgroundColor = [UIColor clearColor];
    [rightSegmentView addSubview:brandLabel];
    
    
    UITapGestureRecognizer* leftTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickLeftview:)];
    
    [leftSegmentView addGestureRecognizer:leftTapGesture];
    
    UITapGestureRecognizer* rightTapGesture = [[UITapGestureRecognizer alloc]
                         initWithTarget:self action:@selector(clickrightview:)];
    
    [rightSegmentView addGestureRecognizer:rightTapGesture];
    
  
    
}


-(void)getWebServiceData
{
    
    
    dispatch_queue_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
   dispatch_group_t group = dispatch_group_create();
    
   dispatch_group_async(group, queue, ^{
       
       
       Result* result = [[Member sharedMember] collectProductListWithOffset:self.offset limit:LIMIT];
      
       if (result.isSuccess) {

       dispatch_async(dispatch_get_main_queue(), ^{
           
           
           productArray = [NSMutableArray array];
           productIDArray = [NSMutableArray array];

           
               
               productArray =(NSMutableArray*)result.data;
           
           NSLog(@"%@",productArray);
           
        
           
           
              for (Product* list in productArray) {
                   
                  
                   [productIDArray addObject:[NSNumber numberWithInt:list.productID]];
                   
                   
               }
               goosLabel.text = [NSString stringWithFormat:@"产品(%d)",productArray.count];
               
               [self refreshProductScrollView];



           });
       
       }
       
   });
    
   dispatch_group_async(group, queue, ^{
       Result* result = [[Member sharedMember] collectProductBrandListWithOffset:self.offset limit:LIMIT];
       if (result.isSuccess) {
           dispatch_async(dispatch_get_main_queue(), ^{
               productBrandArray = [NSMutableArray array];
               
               productBrandArray = (NSMutableArray*)result.data;
               
               for (Brand *list in productBrandArray) {
                   
                   [brandIDArray addObject:[NSNumber numberWithInt:list.brandID]];
                   
               }
               brandLabel.text = [NSString stringWithFormat:@"品牌(%d)",[productBrandArray count]];
               
               [self refreshBrandProductScrollView];
               
               
           });
       }
       
   });
    
    
    NSLog(@"%d",productIDArray.count);
    NSLog(@"%d",productBrandArray.count);

    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
       
        [self keepStaus];
        
        
    });
    
}

-(void)keepStaus{

    
    if (!isEnterBrandDetail ) {
        
        [self clickLeftview:nil];
        
        
     }else  {
        
        
        [self clickrightview:nil];
        
        
    }


}
//创建产品列表的视图
-(void)refreshProductScrollView
{

    

    CGFloat dividingDistance = (self.view.frame.size.width - kProductImageWidth*2.0)/3.0;

    //行的个数。
    NSInteger rowcount = ceilf((productArray.count)/2.0);
    
    if (rowcount < 2) {
        
        rowcount = 2;
        
    }
    
    CGFloat height =64+ dividingDistance*(rowcount+1)+ kProductImageHeight* rowcount;
    
    
    NSLog(@"%f",height);
    
    
    
    goodScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 50,
                                                                   self.view.frame.size.width,
                                                                   504)];
    goodScrollView.backgroundColor = [UIColor colorWithCGColor:
                                      UIColorFromRGB(235.0, 239.0, 241.0).CGColor];
    goodScrollView.showsHorizontalScrollIndicator = YES;
    goodScrollView.tag = 100;
    goodScrollView.userInteractionEnabled = YES;
    [self.view addSubview:goodScrollView];
    //重新设置mainScrollView的高度
    [self resetProductScrollViewFrame:self height:height];
    
    
    
    NSLog(@"goodscroview = %@",NSStringFromCGRect(goodScrollView.frame));
    
    NSLog(@"goodScrollView.contentSize.height =   %f",goodScrollView.contentSize.height);
    
    
    
    for (int i = 0; i < productArray.count;  i++)
    {
        
    
        Product* productList = [productArray objectAtIndex:i];
        
        UIImage* image = [UIImage imageNamed:@"backimage.png"];

        goodsImageView = [[UIImageView alloc]init];
        
        NSUInteger row = floor(i/2.0);
        
        CGFloat x = 0.0;
        
        if (i% 2 ==0) {
            
            x = dividingDistance;
            
        } else{
        
            x= dividingDistance*2.0 + kProductImageWidth;
            
       }
        
        CGFloat y = dividingDistance*(row+1) + kProductImageHeight* row;
        
        
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

        [goodScrollView addSubview:goodsImageView];
        
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
        
        
        UILabel* titleLable = [[UILabel alloc]initWithFrame:CGRectMake
                               (5, 154, 150, 15)];
        titleLable.font = [UIFont systemFontOfSize:11];
        titleLable.backgroundColor = [UIColor clearColor];
        titleLable.text = productList.title;
        titleLable.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                (68.0, 68.0, 68.0).CGColor];
        [goodsImageView addSubview:titleLable];
        
        
        UILabel* subLable = [[UILabel alloc]initWithFrame:CGRectMake
                             (5, 173, 150, 8)];
        
        subLable.font = [UIFont systemFontOfSize:10];
        subLable.text = [NSString stringWithFormat:@"%0.f",productList.productPrice];
        subLable.backgroundColor = [UIColor clearColor];
        subLable.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                              (240.0, 135.0, 139.0).CGColor];
        [goodsImageView addSubview:subLable];
        
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressed:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        tapGestureRecognizer.numberOfTouchesRequired = 1;
        [goodsImageView addGestureRecognizer:tapGestureRecognizer];
        
}
    
    
}

//创建品牌列表的视图
-(void)refreshBrandProductScrollView
{
 
    NSLog(@"%d",productBrandArray.count);
    
    
    CGFloat dividingDistance = (self.view.frame.size.width - kBrandImageWidth*2.0)/3.0;
    //行的个数。
    NSInteger rowcount = ceilf((productBrandArray.count)/2.0);
    
    if (rowcount < 2) {
        
        rowcount = 2;
        
    }
    
    CGFloat height = dividingDistance*(rowcount+1)+ kBrandImageHeight* rowcount;
    
    
    
    brandScrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 50,
                                                                      self.view.frame.size.width,
                                                                      504)];
    brandScrollerView.backgroundColor = [UIColor colorWithCGColor:UIColorFromRGB
                                         (235.0, 239.0, 241.0).CGColor];
    
    brandScrollerView.tag = 101;
    brandScrollerView.showsHorizontalScrollIndicator = YES;
    brandScrollerView.hidden = YES;
    brandScrollerView.userInteractionEnabled = YES;
    [self.view addSubview:brandScrollerView];
    
    //重新设置mainScrollView的高度
    [self resetBrandProductScrollViewFrame:self height:height];
    
   
    
    
    
        for (int i = 0; i < productBrandArray.count;  i++)
        {
            Brand *brand = [productBrandArray objectAtIndex:i];
            
            
            NSInteger row = floor(i/2.0);
            
            CGFloat x = 0.0;
            
            if (i% 2 ==0) {
                
                x = dividingDistance;
                
            } else{
                
                x= dividingDistance*2.0 + kBrandImageWidth;
                
            }
            
            CGFloat y = dividingDistance*(row+1) + kBrandImageHeight* row;
            
            
            
            
            UIView* contentView = [[UIView alloc]init];
            
            contentView.frame = CGRectMake(x, y, kBrandImageWidth, kBrandImageHeight);
            
            
               contentView.layer.cornerRadius = 3.0;
               contentView.layer.masksToBounds = YES;
            
                contentView.userInteractionEnabled = YES;
                contentView.tag = i;
                
                UIImage* contentViewBackImage = [UIImage imageNamed:@"brandImage.png"];
                contentView.backgroundColor = [UIColor colorWithPatternImage:contentViewBackImage];
                
                if (IOS_VERSION_LESS_THAN(@"7.0")) {
                    
                    UIImage* contentViewBackImage = [UIImage imageNamed:@"ios6brandImage.png"];
                    contentView.backgroundColor = [UIColor colorWithPatternImage:contentViewBackImage];
                    
                    
                }
                
                
                UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]
                                                      initWithTarget:self
                                                      action:@selector(clickBrandProductTap:)];
                [contentView addGestureRecognizer:tapGesture];
                
            

        
                
                
                //contentView上的三个子视图 middleImageView | lineimageView | label
                UIImageView* middleImageView = [[UIImageView alloc]initWithFrame:
                                                CGRectMake(0, 0,
                                                           150.0,108.0)];

            if (brand.imageURLString != nil) {
                
                DACircularProgressView* progressView = [[DACircularProgressView alloc]init];
                progressView.frame = CGRectMake((middleImageView.frame.size.width - 20)/2.0, (middleImageView.frame.size.height - 20)/2.0, 20.0, 20.0);
                
                progressView.progress = 0.0;
                [middleImageView addSubview:progressView];
                
                [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:brand.imageURLString] options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    
                    [progressView setProgress:((double)receivedSize/(double)expectedSize) animated:YES];
                    
                    
                    
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                    
                    if (finished && error ==nil) {
                        
                        
                        middleImageView.image = image;
                        
                    }
                    
                    [progressView removeFromSuperview];
                    
                }];
                
                
                [contentView addSubview:middleImageView];

                
            }
            
            
                UIImage* lineImage = [UIImage imageNamed:@"brandline.png"];
                UIImageView* lineimageView = [[UIImageView alloc]initWithFrame:
                                              CGRectMake(0,
                                                         105,
                                                         lineImage.size.width,
                                                         lineImage.size.height)];
                lineimageView.image = lineImage;
                [contentView addSubview:lineimageView];
            
              UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(35, 110,92, 30)];

                label.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                   (30.0, 25.0, 23.0).CGColor];
               label.text = brand.title;
            
                label.font = [UIFont systemFontOfSize:12];
                [contentView addSubview:label];
                
                [brandScrollerView  addSubview:contentView];
                
            }
            

}


-(void)clickLeftview:(UITapGestureRecognizer*)leftTap
{

    leftSegmentView.backgroundColor = [UIColor whiteColor];
    rightSegmentView.backgroundColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                   (19.0, 104.0, 194.0).CGColor];
    brandLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                 (255.0, 255.0, 255.0).CGColor];
    goosLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                  (19.0, 106.0, 194.0).CGColor];
    
    brandScrollerView.hidden = YES;

    goodScrollView.hidden = NO;
    
     NSLog(@"left");

}
-(void)clickrightview:(UITapGestureRecognizer*)rightTap
{
    
    
    leftSegmentView.backgroundColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                  (19.0, 104.0, 194.0).CGColor];
    
    rightSegmentView.backgroundColor = [UIColor whiteColor];
    
    brandLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                   (19.0, 106.0, 194.0).CGColor];
    goosLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                  (255.0, 255.0, 255.0).CGColor];
    
     goodScrollView.hidden = YES;
  
      brandScrollerView.hidden = NO;
 
        NSLog(@"right");
}

-(void)backButtonMethod
{


    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)clickBrandProductTap:(UITapGestureRecognizer*)tap
{
  
    NSInteger brandID = [[brandIDArray objectAtIndex:tap.view.tag] intValue];
    BrandGoodsViewController* brandDetailVC = [[BrandGoodsViewController alloc]init];
    brandDetailVC.brandProductID = brandID;
    isEnterBrandDetail = YES;

    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        brandDetailVC.edgesForExtendedLayout = NO;
        
    }
    [self.navigationController pushViewController:brandDetailVC animated:YES];
    NSLog(@"%d",brandID);
    
}

-(void)pressed:(UITapGestureRecognizer*)tap
{
    NSLog(@"pressed");
    

    
    NSInteger productID = [[productIDArray objectAtIndex:tap.view.tag] intValue];
    
    DetailViewController* detailVC = [[DetailViewController alloc] initWithProductID:[NSNumber numberWithInteger:productID]];
    isEnterBrandDetail = NO;
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        detailVC.edgesForExtendedLayout = NO;
        
    }
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)resetProductScrollViewFrame:(MyCollectViewController*)collect height:(CGFloat)height
{

    NSLog(@"%f",height);
    
    NSLog(@"search =  %@",NSStringFromCGRect(collect.view.frame));
    
    
    collect.view.frame = CGRectMake(0.0, 64.0, self.view.frame.size.width, height);
    
    goodScrollView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(collect.view.frame));
    
    NSLog(@"mainScrollView.contentSize.height = %f",goodScrollView.contentSize.height);
    
    
}

-(void)resetBrandProductScrollViewFrame:(MyCollectViewController*)collect height:(CGFloat)height
{

    NSLog(@"%f",height);
    
    NSLog(@"search =  %@",NSStringFromCGRect(collect.view.frame));
    
    
    collect.view.frame = CGRectMake(0.0, 64.0, self.view.frame.size.width, height);
    
    brandScrollerView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(collect.view.frame));
    
    NSLog(@"mainScrollView.contentSize.height = %f",brandScrollerView.contentSize.height);
 

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
