//
//  BrandViewController.m
//  domcom.Goclay
//
//  Created by 马峰 on 14-3-12.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import "BrandViewController.h"
#import "Macros.h"
#import "BrandGoodsViewController.h"
#import "Result.h"
#import "DACircularProgressView.h"
#import "Brand.h"
#import "SDWebImage/UIImageView+WebCache.h"

#define kBrandImageWidth 150.0
#define kBrandImageHeight 145.0


@interface BrandViewController ()
{

    UIScrollView* mainScrollView;
    NSMutableArray* imageArray;
    NSMutableArray* labelArray;
    NSMutableArray* brandlistIDArray;
    BOOL isEnter;
    
}
@property(nonatomic,strong) NSArray* dataArray;


//创建品牌下的view
-(void)createBrandView;
@end

@implementation BrandViewController

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
    
    
    self.title = @"品牌";
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    self.tabBarController.tabBar.hidden = NO;

    if (isEnter) {
        
        return ;
        
    }else {
        
        isEnter = YES;
        
    }
    
    //创建ScrollView
    mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake
                                            (0, 0, self.view.frame.size.width,
                                                 self.view.frame.size.height)];
    mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width,
                                              self.view.frame.size.height+20);
    
    if ((IOS_VERSION_LESS_THAN(@"7.0"))) {
        
        mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width,
                                            self.view.frame.size.height+100);

    }
    mainScrollView.showsHorizontalScrollIndicator = YES;
    mainScrollView.userInteractionEnabled = YES;
    [self.view addSubview:mainScrollView];
    [mainScrollView setBackgroundColor:[UIColor colorWithCGColor:
                                  UIColorFromRGB(235.0, 239.0, 241.0).CGColor]];
    
    
    

    
    //创建品牌下的view
    [self createBrandView];

    //请求网络数据
    [self getWebserviceData];
    
}

-(void)getWebserviceData
{

  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
        
        Result* result = [Brand requestListWithIsRecommend:NO productCategoryID:@-1];
        
        
        
        
        if (result.isSuccess) {
            
       
            self.dataArray = (NSArray*)result.data;
            imageArray = [NSMutableArray arrayWithCapacity:4];
            labelArray = [NSMutableArray arrayWithCapacity:4];
            brandlistIDArray = [NSMutableArray arrayWithCapacity:4];
            
            
            for (Brand* list in self.dataArray) {
                
    
                [imageArray addObject:list.imageURLString];
                [labelArray addObject:list.title];
                [brandlistIDArray addObject:[NSNumber numberWithInt:list.brandID]];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
       
           //创建品牌列表
            [self createBrandView];
            
        });
        
        
});
    
    
}

//创建品牌下的view
-(void)createBrandView
{
    
   
    
    CGFloat dividingDistance = (self.view.frame.size.width - kBrandImageWidth*2.0)/3.0;
    
    for (int i = 0; i < self.dataArray.count;  i++)
    {
        
        Brand* brandlist = [self.dataArray objectAtIndex:i];
        
        
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
        
        if (brandlist.imageURLString != nil) {
            
            DACircularProgressView* progressView = [[DACircularProgressView alloc]init];
            progressView.frame = CGRectMake((middleImageView.frame.size.width - 20)/2.0,
                            (middleImageView.frame.size.height - 20)/2.0, 20.0, 20.0);
            
            progressView.progress = 0.0;
            [middleImageView addSubview:progressView];
            
            [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:brandlist.imageURLString]
            options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
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
        label.text = brandlist.title;
        
        label.font = [UIFont systemFontOfSize:12];
        [contentView addSubview:label];
        
        [mainScrollView  addSubview:contentView];
     //   mainScrollView.contentSize = CGSizeMake(mainScrollView.frame.size.width,
                       //                         CGRectGetMaxY(contentView.frame) + 10.0);
    }
    
    mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.dataArray.count/2* (kBrandImageHeight+8.0));
    
    
}

//为每一个view创建一个手势方法
-(void)clickBrandProductTap:(UITapGestureRecognizer*)tap
{
   
    
    int ID = [[brandlistIDArray objectAtIndex:tap.view.tag] intValue];
    
    NSLog(@"%d",ID);
    
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:ID] forKey:@"productBrandId"];
    
    BrandGoodsViewController* brandViewVC = [[BrandGoodsViewController alloc]init];
    brandViewVC.brandProductID= [[brandlistIDArray objectAtIndex:tap.view.tag] intValue];
    brandViewVC.hidesBottomBarWhenPushed= YES;
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        brandViewVC.edgesForExtendedLayout = NO;
    }
    [self.navigationController pushViewController:brandViewVC  animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
