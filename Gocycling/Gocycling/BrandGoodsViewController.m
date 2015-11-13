//
//  BrandGoodsViewController.m
//  doomcom.Goclaying
//
//  Created by Apple on 14-3-19.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import "BrandGoodsViewController.h"
#import "GoodsListViewController.h"
#import "Macros.h"
#import "FilterViewController.h"
#import "Brand.h"
#import "DACircularProgressView.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "LoginViewController.h"
#import "Member.h"

@interface BrandGoodsViewController ()
{
    UIScrollView* mainScrollView;
    UIView* downView ;
    BOOL isEnter;
    BOOL isCollecting;
    UILabel* onBlackViewlabel;
    UIView* cancelBlackView;
    UILabel* cancelLabel;
    UIView* blackView;
    UIImageView* lookGoodsView;
    UIImageView* collectView;
    UILabel* collectLabel;
    UIView* upView;
    UILabel* titleLabel;
    UITextView* textView;
    Brand* brandDetail;
    UILabel* lookLabel;
    UIImageView* middleImageView;
    BOOL hasCollected;
    
    
}
@end

@implementation BrandGoodsViewController

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
//    label.text = NSLocalizedString(@"品牌", nil);
//    self.navigationItem.titleView = label;
    self.title = @"品牌";
    
    
    
    //返回的leftBarButtonItem
    UIImage* backImage = [UIImage imageNamed:@"arrowback.png"];
    UIButton* bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = CGRectMake(0, 0,backImage.size.width, backImage.size.height);
    [bt setImage:backImage forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(backButtonMethod) forControlEvents:
     UIControlEventTouchUpInside];
    UIBarButtonItem* left = [[UIBarButtonItem alloc]initWithCustomView:bt];
    self.navigationItem.leftBarButtonItem = left;
    
    
    self.view.backgroundColor = UIColorFromRGB(235.0, 239.0, 241.0);
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    
    if (isEnter) {
        
//        self.navigationController.navigationBarHidden = NO;
//        self.tabBarController.tabBar.hidden = YES;
        
        return ;
        
    }else {
        
        isEnter = YES;
    }
    
    //创建ScrollView
    mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,
                                                                   self.view.frame.size.width,
                                                                   self.view.frame.size.height)];
    mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 600);
    mainScrollView.showsHorizontalScrollIndicator = YES;
    [self.view addSubview:mainScrollView];
    
    
    //navigationbar下面的view
    upView = [[UIView alloc] initWithFrame:CGRectMake(0.0,
                                                      0.0,
                                                      self.view.frame.size.width,
                                                      self.view.frame.size.width)];
    upView.backgroundColor = [UIColor whiteColor];
    [mainScrollView addSubview:upView];
    
    
    
    
    
    middleImageView = [[UIImageView alloc]initWithFrame:CGRectMake
                                    (0,
                                     0,
                                     self.view.frame.size.width,
                                     230)];
    middleImageView.center = upView.center;
    [upView addSubview:middleImageView];
    
    
    //navigationbar最下面的view
    downView = [[UIView alloc]initWithFrame:CGRectMake(0, 320.0,
                                                       self.view.frame.size.width,
                                                       self.view.frame.size.height)];
//    [downView setBackgroundColor:[UIColor colorWithCGColor:UIColorFromRGB
//                                  (235.0, 239.0, 241.0).CGColor]];
    [mainScrollView addSubview:downView];
    
    
    //downView上的四个子视图 titleLabel| textView | downgoodsView | collectView
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 300,15)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                            (56.0, 56.0, 56.0).CGColor];
    titleLabel.font = [UIFont systemFontOfSize:18];
    
    [downView addSubview:titleLabel];
    
    
    textView = [[UITextView alloc]initWithFrame:CGRectMake(6,35,self.view.frame.size.width,
                                                                       80)];
    textView.textColor = [UIColor colorWithCGColor:
                          UIColorFromRGB(86.0, 86.0, 86.0).CGColor];
    textView.backgroundColor = [UIColor clearColor];
    textView.scrollEnabled = NO;
    
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        textView.selectable = NO;
        
    }else {
        
        textView.clearsOnInsertion = YES;
        textView.editable = NO;
    }
    textView.font = [UIFont systemFontOfSize:15];
    [downView addSubview:textView];
    
    
    UIImage* lookgoodsImage = [UIImage imageNamed:@"lookgoodsimage.png"];
    lookGoodsView  = [[UIImageView alloc]init];
    lookGoodsView.image = lookgoodsImage;
    
    lookGoodsView.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(clickTap:)];
    [lookGoodsView addGestureRecognizer:tapGesture];
    
    [downView addSubview:lookGoodsView];
    
    lookLabel = [[UILabel alloc]initWithFrame:CGRectMake(28, 5, 140, 30)];
    lookLabel.textColor = [UIColor colorWithCGColor:
                           UIColorFromRGB(81.0, 81.0, 81.0).CGColor];
    lookLabel.backgroundColor = [UIColor clearColor];
    lookLabel.font = [UIFont systemFontOfSize:15];
    [lookGoodsView addSubview:lookLabel];
    
    UIImage* collectImage = [UIImage imageNamed:@"collectgoodsImage.png"];
    collectView = [[UIImageView alloc]init];
    collectView.userInteractionEnabled = YES;
    collectView.image = collectImage;
    
    
    UITapGestureRecognizer* collectTapGesture = [[UITapGestureRecognizer alloc]
                                                 initWithTarget:self action:@selector(saveMethod:)];
    [collectView addGestureRecognizer:collectTapGesture];
    [downView addSubview:collectView];
    
    
    collectLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 5, 50, 30)];
    collectLabel.font = [UIFont systemFontOfSize:15.0];
    collectLabel.textColor = [UIColor colorWithCGColor:
                              UIColorFromRGB(67.0, 67.0, 67.0).CGColor];
    
    collectLabel.text = @"收藏";
    [collectView addSubview:collectLabel];
    
    //获取网络数据
    [self getWebServiceData];
    
    
 
    
}

-(void)getWebServiceData
{

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
   dispatch_group_t group = dispatch_group_create();
    
   dispatch_group_async(group, queue, ^{
    
       NSNumber *productBrandID = [[NSUserDefaults standardUserDefaults]objectForKey:@"productBrandId"];
       
       Result* result = [Brand requestByBrandID:productBrandID.integerValue];
       
       
       if (result.isSuccess) {
           
           brandDetail = (Brand*)result.data;
       }
       
       dispatch_async(dispatch_get_main_queue(), ^{
           
           NSURL* url = [[NSURL alloc]initWithString:brandDetail.imageURLString];
           
           DACircularProgressView* progressView = [[DACircularProgressView alloc]init];
           progressView.frame = CGRectMake((middleImageView.frame.size.width-40.0)/2.0,
                                           (middleImageView.frame.size.height-40.0)/2.0, 40, 40);
           progressView.backgroundColor = [UIColor grayColor];
           
           progressView.progress = 0.0;
           [middleImageView addSubview:progressView];
           
           
           [[SDWebImageManager sharedManager] downloadWithURL:url
                                options:SDWebImageProgressiveDownload
                progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                         
            [progressView setProgress:((double)receivedSize / (double)expectedSize) animated:YES];
                                                         
                                                         
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                
                if (finished && error == nil) {
                                                             
                [progressView setProgress:1.0 animated:YES];
                                                             
                middleImageView.image = image;
                }
                [progressView removeFromSuperview];
            
            }];

           
           
           titleLabel.text = brandDetail.title;
           
           //重新定义textView的高度
           NSString* textViewString = brandDetail.summary;
           
           CGRect rect = textView.frame;
           
           CGSize size = [textViewString sizeWithFont:[UIFont systemFontOfSize:15.0]
                                    constrainedToSize:CGSizeMake(300, 1000)
                                        lineBreakMode:NSLineBreakByWordWrapping];
           
           rect.size.height = size.height+10;
           
           textView.frame = rect;
           
           textView.text = brandDetail.summary;
           
           
           
           collectView.frame = CGRectMake(160, textView.frame.size.height+30,
                                          145.0,
                                          40.0);
           lookGoodsView.frame = CGRectMake(10, textView.frame.size.height+30,
                                            145.0,
                                            40.0);
           lookLabel.text = [NSString stringWithFormat:@"查看商品(%d)",brandDetail.productCount];
           
           
       });
       
});
    
    dispatch_group_async(group, queue, ^{
        if ([[Member sharedMember] hasLogined]) {
            Result* result =  [[Member sharedMember] collectProductBrand:self.brandProductID];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (result.isSuccess) {
//                    ManagerMemberProduct* managerProduct = (ManagerMemberProduct*)result.data;
                    BOOL isProductBrandExsited = [result.data boolValue];
                    if (!isProductBrandExsited) {
                        collectLabel.text = @"收藏";
                        hasCollected = NO;
                    } else {
                        collectLabel.frame = CGRectMake(45, 5, 60, 30);
                        collectLabel.text = @"取消收藏";
                        hasCollected = YES;
                    }
                }
            });
        }
    });

}

//收藏按钮
-(void)saveMethod:(UITapGestureRecognizer*)tap
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        if ([[Member sharedMember] hasLogined]) {
            if (hasCollected) {
                Result* result = [[Member sharedMember] removeCollectProductBrand:self.brandProductID];
                if (result.isSuccess) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (cancelBlackView == nil) {
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
                        
                        collectLabel.frame = CGRectMake(55, 5, 50, 30);
                        collectLabel.text = @"收藏";
                        
                        hasCollected = NO;
                        
                        [self performSelector:@selector(removeBlackViewMethod) withObject:nil afterDelay:3];
                        
                    });
                }
                
            } else {
                
                Result* result = [[Member sharedMember] collectProductBrand:self.brandProductID];
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
                        
                        collectLabel.frame = CGRectMake(40, 5, 60, 30);
                        collectLabel.text = @"取消收藏";
                        hasCollected = YES;
                        
                        [self performSelector:@selector(removeBlackViewMethod) withObject:nil afterDelay:3];
                        
                    });
                    
                }
                
            }
            
        } else {
            
            
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
//点击查看商品按钮
-(void)clickTap:(UITapGestureRecognizer*)tap
{
    
//    BigTwoViewController* bigView = [[BigTwoViewController alloc]init];
//    bigView.isRecommend = @0;
//    bigView.productCategoryId = @-1;
//    bigView.productBrandId = [NSNumber numberWithInt:brandDetail.brandDetailID];
//    bigView.searchKeyword = @"";
//    bigView.isBrandProduct = YES;
//    self.navigationController.navigationBarHidden = YES;
//    bigView.hidesBottomBarWhenPushed = YES;
//    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
//        bigView.edgesForExtendedLayout = NO;
//    }
//    [self.navigationController pushViewController:bigView animated:YES];
    
    GoodsListViewController *goodsListVC = [[GoodsListViewController alloc] initWithIsRecommend:@0
                                                                              productCategoryID:@-1
                                                                                 productBrandID:[NSNumber numberWithInt:brandDetail.brandID]
                                                                                  searchKeyword:@""];
    [self.navigationController pushViewController:goodsListVC animated:YES];
}

-(void)backButtonMethod
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
