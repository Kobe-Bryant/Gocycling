//
//  BinnerViewController.m
//  domcom.Goclay
//
//  Created by 马峰 on 14-3-12.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import "BinnerViewController.h"
#import "DACircularProgressView.h"
#import "SDWebImage/UIImageView+WebCache.h"
@interface BinnerViewController ()

@end

@implementation BinnerViewController

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
   
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, 320.0, 210.0)];
    self.imageView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.imageView];

    DACircularProgressView* progressView = [[DACircularProgressView alloc] init];
    progressView.frame = CGRectMake((self.imageView.frame.size.width - 20.0) / 2.0,
                                    (self.imageView.frame.size.height - 20.0) / 2.0,
                                    20.0,
                                    20.0);
    progressView.progress = 0.0;
    progressView.backgroundColor = [UIColor lightGrayColor];
    [self.imageView addSubview:progressView];
    
    [[SDWebImageManager sharedManager] downloadWithURL:[[NSURL alloc] initWithString:self.dataObject] options:SDWebImageProgressiveDownload progress:
     ^(NSInteger receivedSize, NSInteger expectedSize) {
         [progressView setProgress:((double)receivedSize / (double)expectedSize) animated:YES];
     } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
         if (finished && error == nil) {
             [progressView setProgress:1.0 animated:YES];
             self.imageView.image = image;
         }
         
         [progressView removeFromSuperview];
     }];
    
    
    //透明的view
    UIView* blackView = [[UIView alloc] init];
    blackView.frame = CGRectMake(0.0, self.imageView.frame.size.height - 25.0, 320.0, 25.0);
//    blackview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lable.png"]];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.4;
    [self.view addSubview:blackView];
    
    
    UILabel* label = [[UILabel alloc] init];
    label.frame = CGRectMake(5.0,
                             blackView.frame.origin.y,
                             blackView.frame.size.width - 5.0,
                             blackView.frame.size.height);
    NSString* title = (NSString*) self.titleString;
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.alpha = 1;
    label.text = title;
    [self.view addSubview:label];
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    NSDictionary *dict = @{@"dataObject": self.dataObject};
//    [[NSNotificationCenter defaultCenter] postNotificationName:
//                                            @"ChangeBannerIndex" object:dict];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
