//
//  ActivityDetailViewController.m
//  doomcom.Goclaying
//
//  Created by Apple on 14-3-20.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "Macros.h"
#import "WebView.h"

@interface ActivityDetailViewController ()
{
    
    UIScrollView* mainScrollView;
    BOOL isEnter;
    
}

@property(nonatomic,strong) WebView* webView;

@end

@implementation ActivityDetailViewController

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
                                              (251.0, 251.0, 251.0).CGColor];
    
    //设置navigationItem的titleView
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(160, 0, 40, 30)];
    label.textColor = [UIColor colorWithCGColor:UIColorFromRGB(49.0, 49.0, 49.0).CGColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.text = NSLocalizedString(@"赛事详情", nil);
    self.navigationItem.titleView = label;
    
    
    
    //返回的leftBarButtonItem
    UIImage* image = [UIImage imageNamed:@"_leftbutton.png"];
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0,image.size.width, image.size.height);
    [leftButton setImage:image forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backButtonMethod)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
  
    
    
    //navigationBar下面的线条
    UIImage* bardownlineImage = [UIImage imageNamed:@"_barline.png"];
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,
                                            320, bardownlineImage.size.height)];
    imageView.image = bardownlineImage;
    [self.view addSubview:imageView];
    
    
    UIImageView* downImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -20,
                                            320, bardownlineImage.size.height)];
    downImageView.backgroundColor = [UIColor redColor];
    downImageView.image = bardownlineImage;
    [self.view addSubview:downImageView];
    
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        //设置navigationBar的背景图片
        [self.navigationController.navigationBar setBackgroundImage:
         [UIImage imageNamed:@"navigaback.png"] forBarMetrics:UIBarMetricsDefault];
        
    } else  {
        
        //设置导航栏的背景
        UIImage* barImage = [UIImage imageNamed:@"navigationbar_"];
        [self.navigationController.navigationBar setBackgroundImage:barImage
                                                      forBarMetrics:UIBarMetricsDefault];
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear: animated];
    
    
    
    if (isEnter) {
        
        return ;
        
    }else {
        
        isEnter = YES;
        
    }
    
    mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,
                                                     self.view.frame.size.width,
                                                  self.view.frame.size.height)];
    mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 600);
    mainScrollView.showsHorizontalScrollIndicator = YES;
    mainScrollView.userInteractionEnabled=YES;
    [self.view addSubview:mainScrollView];
    
    self.webView = [[WebView alloc] init];
    self.webView.frame = CGRectMake(0.0,
                                    0.0,
                                    self.view.frame.size.width,
                                    self.view.frame.size.height);
    self.webView.delegate = self;
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.opaque = NO;
    [self.view addSubview:self.webView];
  
    [self.webView loadHTMLStringWithCustomStyle:self.detailDescrption baseURL:nil];
    
    
    
    
    

}

-(void)backButtonMethod
{

    [self dismissViewControllerAnimated:YES completion:nil];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
