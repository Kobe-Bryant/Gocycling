//
//  SearchResultViewController.m
//  doomcom.Goclaying
//
//  Created by Apple on 14-3-17.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import "SearchResultViewController.h"
#import "Macros.h"
#import "SearchViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "DACircularProgressView.h"
#import "Product.h"
#import "DetailViewController.h"


#define kProductImageWidth 151.0
#define kProductImageHeight 189.0


@interface SearchResultViewController ()
{
  
    UIScrollView* mainScrollView;
    BOOL isEnter;
    UIImageView* goodsImageView;
    
    
}
@end

@implementation SearchResultViewController

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

    self.view.backgroundColor = UIColorFromRGB(235.0, 239.0, 241.0);
    //返回的leftBarButtonItem
    UIImage* image = [UIImage imageNamed:@"arrowback.png"];
    UIButton* bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = CGRectMake(0, 0,image.size.width, image.size.height);
    [bt setImage:image forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(backButtonMethod) forControlEvents:
     UIControlEventTouchUpInside];
    UIBarButtonItem* left = [[UIBarButtonItem alloc]initWithCustomView:bt];
    self.navigationItem.leftBarButtonItem = left;

    
    NSDictionary *dict=[NSDictionary dictionaryWithObjects:
                                 [NSArray arrayWithObjects:[UIColor whiteColor],
                                 [UIFont boldSystemFontOfSize:18],
                                 [UIColor clearColor],nil]
                                 forKeys:[NSArray arrayWithObjects:
                                 UITextAttributeTextColor,
                        UITextAttributeFont,UITextAttributeTextShadowColor,nil]];
   self.navigationController.navigationBar.titleTextAttributes=dict;
//    self.title = NSLocalizedString(@"搜索结果（%d）", self.productArray.count);
    self.title = [NSString stringWithFormat:@"搜索结果(%d)",self.productArray.count];
    
    

    
    
    
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
-(void)viewWillAppear:(BOOL)animated
{
    
    self.productIDArray = [NSMutableArray array];
    for (Product* list in self.productArray) {
        [self.productIDArray addObject:[NSNumber numberWithInt:list.productID]];
    }
    
    if (isEnter) {
        
        return ;
        
    }else {
        
        isEnter = YES;
        
    }


    
    CGFloat dividingDistance = (self.view.frame.size.width - kProductImageWidth * 2.0) / 3.0;
    
    //行的个数。
    NSInteger rowCount = ceilf((self.productArray.count) / 2.0);
    
    if (rowCount < 2) {
        rowCount = 2;
    }
    
    CGFloat height = dividingDistance * (rowCount + 1) + kProductImageHeight * rowCount;
    
    
    NSLog(@"%f",height);
    
    
    
    mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   self.view.frame.size.width,
                                                                   504)];
    mainScrollView.backgroundColor = [UIColor colorWithCGColor:
                                      UIColorFromRGB(235.0, 239.0, 241.0).CGColor];
    mainScrollView.showsHorizontalScrollIndicator = YES;
    mainScrollView.tag = 100;
    mainScrollView.userInteractionEnabled = YES;
    [self.view addSubview:mainScrollView];
    //重新设置mainScrollView的高度
    [self resetProductScrollViewFrame:self height:height];
    
    
   for (int i = 0; i < self.productArray.count;  i++)
    {
        
        
        Product* productList = [self.productArray objectAtIndex:i];
        
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
        
        
        UILabel* titleLable = [[UILabel alloc]initWithFrame:CGRectMake(5.0, 154.0, 150.0, 15.0)];
        titleLable.font = [UIFont systemFontOfSize:11.0];
        titleLable.backgroundColor = [UIColor clearColor];
        titleLable.text = productList.title;
        titleLable.textColor = UIColorFromRGB(68.0, 68.0, 68.0);
        [goodsImageView addSubview:titleLable];
        
        
        UILabel* priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(5.0, 173.0, 150.0, 8.0)];
        priceLabel.font = [UIFont systemFontOfSize:10.0];
        priceLabel.text = [NSString stringWithFormat:@"￥%0.f", productList.productPrice];
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.textColor = UIColorFromRGB(230.0, 0.0, 18.0);
        [goodsImageView addSubview:priceLabel];
        
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressed:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        tapGestureRecognizer.numberOfTouchesRequired = 1;
        [goodsImageView addGestureRecognizer:tapGestureRecognizer];
        
    }
    
}

//当前视图控制器上的contentview的点击响应方法
-(void)clickViewGesture:(UITapGestureRecognizer*)tapGesture
{

    NSLog(@"tapGesture");
    
}

//返回方法
-(void)backButtonMethod
{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"setTableViewBackGround" object:nil];
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)resetProductScrollViewFrame:(SearchResultViewController*)collect height:(CGFloat)height
{
    
    NSLog(@"%f",height);
    
    NSLog(@"search =  %@",NSStringFromCGRect(collect.view.frame));
    
    
    collect.view.frame = CGRectMake(0.0, 64.0, self.view.frame.size.width, height);
    
    mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(collect.view.frame));
    
    NSLog(@"mainScrollView.contentSize.height = %f",mainScrollView.contentSize.height);
    
    
}
-(void)pressed:(UITapGestureRecognizer*)tap
{
    NSLog(@"pressed");
    
    NSLog(@"%@",self.productIDArray);
    
    
    NSInteger productID = [[self.productIDArray objectAtIndex:tap.view.tag] intValue];
    
    NSLog(@"%d",productID);
    
    
    
    DetailViewController* detailVC = [[DetailViewController alloc] initWithProductID:[NSNumber numberWithInteger:productID]];
    detailVC.hidesBottomBarWhenPushed = YES;
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        detailVC.edgesForExtendedLayout = NO;
        
    }
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
