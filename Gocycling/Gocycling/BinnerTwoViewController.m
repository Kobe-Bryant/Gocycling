//
//  BinnerTwoViewController.m
//  doomcom.Goclaying
//
//  Created by Apple on 14-3-18.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import "BinnerTwoViewController.h"
#import "DACircularProgressView.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface BinnerTwoViewController ()

@end

@implementation BinnerTwoViewController

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
    
    
    //view上的图片
    
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake
                      (0, 25, 320.0, 235.0)];
    
    
    [self.view addSubview:self.imageView];
    
    NSURL* url = [[NSURL alloc]initWithString:self.dataObject];
    
    DACircularProgressView* progressView = [[DACircularProgressView alloc]init];
    progressView.frame = CGRectMake((self.imageView.frame.size.width-20.0)/2.0,
                                    (self.imageView.frame.size.height-20.0)/2.0, 20, 20);
    progressView.progress = 0.0;
    progressView.backgroundColor = [UIColor lightGrayColor];
    
    [self.imageView addSubview:progressView];
    
    
    [[SDWebImageManager sharedManager] downloadWithURL:url options:
     SDWebImageProgressiveDownload progress:
     ^(NSInteger receivedSize, NSInteger expectedSize) {
         
         
         [progressView setProgress:((double)receivedSize / (double)expectedSize) animated:YES];
         
         
     } completed:^(UIImage *image, NSError *error, SDImageCacheType
                   cacheType, BOOL finished) {
         if (finished && error == nil) {
             
             [progressView setProgress:1.0 animated:YES];
             
             self.imageView.image = image;
             
         }
         
         [progressView removeFromSuperview];
     }];

   
    
    
    //发送一个通知
    NSDictionary* dic = @{@"dataObject":self.dataObject};
    
    [[NSNotificationCenter defaultCenter]postNotificationName:
                                   @"BinnerTwoViewControllerIndex" object:dic];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
