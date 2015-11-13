//
//  GoodDetailViewController.m
//  doomcom.Goclaying
//
//  Created by Apple on 14-3-24.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import "GoodDetailViewController.h"
#import "Macros.h"
@interface GoodDetailViewController ()
{

    UIScrollView* mainScrollView;
    BOOL isEnter;


}
@end

@implementation GoodDetailViewController

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
                                          (255.0, 255.0, 255.0).CGColor];
  
    NSLog(@"%@",self.syBaseString);
    NSLog(@"%@",self.detailString);

    
    
    //设置navigationItem的titleView
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(160, 0, 40, 30)];
    label.textColor = [UIColor colorWithCGColor:UIColorFromRGB(49.0, 49.0, 49.0).CGColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = NSLocalizedString(@"产品详情", nil);
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
    
    
    
    UIImage* barDownLineImage = [UIImage imageNamed:@"barDownLineImage.png"];
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,
                                            320, barDownLineImage.size.height)];
    imageView.image = barDownLineImage;
    [self.view addSubview:imageView];
    
    
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        
        //设置导航栏的背景
        UIImage* navigationbarImage = [UIImage imageNamed:@"navigaback.png"];
        [self.navigationController.navigationBar setBackgroundImage:
         navigationbarImage forBarMetrics:UIBarMetricsDefault];
        
    }else {
        
        //设置导航栏的背景
        UIImage* barImage = [UIImage imageNamed:@"navigationbar_"];
        [self.navigationController.navigationBar setBackgroundImage:barImage
                                                      forBarMetrics:UIBarMetricsDefault];
    }
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    
    
    //判断是否进入
    if (isEnter) {
        
        return;
        
    }else
    {
        
        isEnter = YES;
    }
    

    mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake
                      (0, 0, self.view.frame.size.width, self.view.frame.size.height)];

    mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 600);
    mainScrollView.showsHorizontalScrollIndicator = YES;
    mainScrollView.userInteractionEnabled=YES;
    [self.view addSubview:mainScrollView];
    
    UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake
                           (17, 18, 100, 30)];
    
    titleLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                            (49.0, 49.0, 49.0).CGColor];
    titleLabel.text = @"产品介绍";
    
    titleLabel.font = [UIFont systemFontOfSize:18];
    
    [mainScrollView addSubview:titleLabel];
    
    
      CGSize size = [self.detailString sizeWithFont:[UIFont systemFontOfSize:12.0]
                  constrainedToSize:CGSizeMake(self.view.frame.size.width, 1000)
                                       lineBreakMode:NSLineBreakByWordWrapping];
    
    NSLog(@"%f",size.height);
    
    
    UIWebView* webView = [[UIWebView alloc]init];
    
    webView.frame = CGRectMake(0.0, 60.0, self.view.frame.size.width,size.height*2);
    
    webView.backgroundColor = [UIColor clearColor];
    webView.opaque = NO;
    
    [webView loadHTMLString:self.detailString baseURL:nil];
    
    [mainScrollView addSubview:webView];
    
    
    
    UIImage* sectionlineImage = [UIImage imageNamed:@"sectionline.png"];
    UIImageView* lineImageView = [[UIImageView alloc]initWithFrame:
                                                              CGRectMake(0, size.height*2+50,
                                                   sectionlineImage.size.width,
                                                 sectionlineImage.size.height)];
    lineImageView.image = sectionlineImage;
    [mainScrollView addSubview:lineImageView];
    
    
    
    UILabel* subLable = [[UILabel alloc]initWithFrame:CGRectMake(17,size.height*2+45+sectionlineImage.size.height+20,100, 30)];
    subLable.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                          (49.0, 49.0, 49.0).CGColor];
    subLable.text = @"配置参数";
    subLable.font = [UIFont systemFontOfSize:18];
    [mainScrollView addSubview:subLable];
    
    
    CGSize sizefit = [self.syBaseString sizeWithFont:[UIFont systemFontOfSize:12.0]
                                constrainedToSize:CGSizeMake(self.view.frame.size.width, 1000)
                                    lineBreakMode:NSLineBreakByWordWrapping];
    
    UIWebView* syWebView = [[UIWebView alloc]init];
    
    syWebView.frame = CGRectMake(0.0, size.height*2+45+sectionlineImage.size.height+20+30+12, self.view.frame.size.width,sizefit.height*2);
    
    syWebView.backgroundColor = [UIColor clearColor];
    
    syWebView.opaque = NO;
    
    [syWebView loadHTMLString:self.syBaseString baseURL:nil];
    
    [mainScrollView addSubview:syWebView];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
    UIImage* shadowImage = [UIImage imageNamed:@"navigationshadowImage.png"];
    
    [self.navigationController.navigationBar setBackgroundImage:shadowImage
                                            forBarMetrics:UIBarMetricsDefault];
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
