//
//  BinnerThreeViewController.m
//  doomcom.Goclaying
//
//  Created by Apple on 14-3-20.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import "BinnerThreeViewController.h"



@interface BinnerThreeViewController ()

@end

@implementation BinnerThreeViewController

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
    

    UIImage* image = [UIImage imageNamed:self.dataObject];
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake
                      (0, 0, 320.0, 210.0)];
    self.imageView.image = image;
    [self.view addSubview:self.imageView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    
    
    NSDictionary* dic = @{@"dateobject":self.dataObject};
    
    [[NSNotificationCenter defaultCenter]postNotificationName:
             @"BinnerThreeViewControllerIndex"    object:dic];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
