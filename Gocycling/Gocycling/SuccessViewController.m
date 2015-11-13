//
//  SuccessViewController.m
//  doomcom.Goclaying
//
//  Created by Apple on 14-3-21.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import "SuccessViewController.h"
#import "Macros.h"
@interface SuccessViewController ()
{
    
    UITapGestureRecognizer* alipayTapGesture;
    UITapGestureRecognizer* chinaBankTapgesture ;
    UITapGestureRecognizer* merchantBankTapGesture;
    UIScrollView* mainScrollView;
    BOOL isEnter;
    
}
@end

@implementation SuccessViewController

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
    
    //设置navigationItem的titleView
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(160, 0, 40, 30)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = NSLocalizedString(@"报名成功", nil);
    self.navigationItem.titleView = label;
    
    
    //返回的leftBarButtonItem
    UIImage* backImage = [UIImage imageNamed:@"arrowback.png"];
    UIButton* bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = CGRectMake(0, 0,backImage.size.width, backImage.size.height);
    [bt setImage:backImage forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(backButtonMethod) forControlEvents:
     UIControlEventTouchUpInside];
    UIBarButtonItem* left = [[UIBarButtonItem alloc]initWithCustomView:bt];
    self.navigationItem.leftBarButtonItem = left;

}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    
    mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake
                      (0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 600);
    mainScrollView.showsHorizontalScrollIndicator = YES;
    mainScrollView.userInteractionEnabled=YES;
    [self.view addSubview:mainScrollView];

    
    //mainScrollView下面的view
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,
                                                                     320, 240)];
    
    imageView.backgroundColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                 (235.0, 239.0, 241.0).CGColor];
    [mainScrollView addSubview:imageView];
    
    
    
    //mainScrollView上面的子视图 labelOne| labelTwo | labelThree |
     //                        labelFour | labelFive | labelSix | labelSenven
    UILabel* labelOne = [[UILabel alloc]initWithFrame:CGRectMake(120, 40, 200, 25)];
    labelOne.font = [UIFont systemFontOfSize:24];
    labelOne.backgroundColor = [UIColor clearColor];
    labelOne.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                      (235.0, 97.0, 0).CGColor];
    labelOne.text = @"恭喜您！";
    [imageView addSubview:labelOne];
    
    UILabel* labelTwo = [[UILabel alloc]initWithFrame:CGRectMake(60, 70, 250, 25)];
    labelTwo.font = [UIFont systemFontOfSize:24];
    labelTwo.backgroundColor = [UIColor clearColor];
    labelTwo.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                    (27.0, 27.0, 27.0).CGColor];
    labelTwo.text = @"报名信息提交成功！";
    [imageView addSubview:labelTwo];
    
    UILabel* labelThree = [[UILabel alloc]initWithFrame:CGRectMake(70, 140, 200, 25)];
    labelThree.font = [UIFont systemFontOfSize:15];
    labelThree.backgroundColor = [UIColor clearColor];
    labelThree.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                    (67.0, 67.0, 67.0).CGColor];
    labelThree.text = @"希望您尽快完成付款，谢谢！";
    [imageView addSubview:labelThree];
    
    UILabel* labelFour = [[UILabel alloc]initWithFrame:CGRectMake(50, 170, 105, 25)];
    labelFour.font = [UIFont systemFontOfSize:15];
    labelFour.backgroundColor = [UIColor clearColor];
    labelFour.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                 (126.0, 126.0, 126.0).CGColor];
    labelFour.text = @"您的报名编号：";
    [imageView addSubview:labelFour];
    
    
    UILabel* labelFive = [[UILabel alloc]initWithFrame:CGRectMake(150, 170, 250, 25)];
    labelFive.font = [UIFont systemFontOfSize:15];
    labelFive.backgroundColor = [UIColor clearColor];
    labelFive.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                    (230.0, 0.0, 18.0).CGColor];
    labelFive.text = self.submitList.orderSn;
    [imageView addSubview:labelFive];
    
    
    UILabel* labelSix = [[UILabel alloc]initWithFrame:CGRectMake(67, 200, 140, 25)];
    labelSix.font = [UIFont systemFontOfSize:15];
    labelSix.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                 (126.0, 126.0, 126.0).CGColor];
    labelSix.text = @"您的报名费用合计： ";
    labelSix.backgroundColor = [UIColor clearColor];
    [imageView addSubview:labelSix];
    
    UILabel* priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 200, 100, 25)];
    priceLabel.font = [UIFont systemFontOfSize:15];
    priceLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                    (230.0, 0.0, 18.0).CGColor];
    priceLabel.backgroundColor = [UIColor clearColor];
    priceLabel.text = [NSString stringWithFormat:@"￥%0.f",self.submitList.totalPrice];

    [imageView addSubview:priceLabel];
    
    UILabel* labelSenven = [[UILabel alloc]initWithFrame:CGRectMake(20, 250, 200, 25)];
    labelSenven.font = [UIFont systemFontOfSize:12];
    labelSenven.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                 (118.0, 118.0, 118.0).CGColor];
    labelSenven.backgroundColor = [UIColor clearColor];
    labelSenven.text = @"您可以通过以下方式付款 ";
    [mainScrollView addSubview:labelSenven];
    
    
    
    //支付宝view
    UIImage* alipayImage = [UIImage imageNamed:@"alipayImage.png"];
    UIImageView*  alipayImageView = [[UIImageView alloc]initWithFrame:CGRectMake
                      ((self.view.frame.size.width-alipayImage.size.width)/2.0,
                                                                           285,
                                                        alipayImage.size.width,
                                                      alipayImage.size.height)];
    alipayImageView.image = alipayImage;
    alipayTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                    action:@selector(success:)];
    alipayImageView.userInteractionEnabled = YES;
    [alipayImageView addGestureRecognizer:alipayTapGesture];
    [mainScrollView addSubview:alipayImageView];
    
    
    
    //中国银行view
    UIImage* chinaBankImage = [UIImage imageNamed:@"chinaBankImage.png"];
    
    UIImageView* chinaBankImageView = [[UIImageView alloc]initWithFrame:
         CGRectMake((self.view.frame.size.width-chinaBankImage.size.width)/2.0,
                                                285+alipayImage.size.height+15,
                                                     chinaBankImage.size.width,
                                                   chinaBankImage.size.height)];
    chinaBankImageView.userInteractionEnabled = YES;
    chinaBankImageView.image = chinaBankImage;
    
    chinaBankTapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                    action:@selector(success:)];
    [chinaBankImageView addGestureRecognizer:chinaBankTapgesture];
    [mainScrollView addSubview:chinaBankImageView];
    
    
    //招商银行view
    UIImage* merchantBankImage = [UIImage imageNamed:@"merchantBankImage.png"];
    
    UIImageView* merchantBankImageView = [[UIImageView alloc]initWithFrame:
      CGRectMake((self.view.frame.size.width-merchantBankImage.size.width)/2.0,
                   285+alipayImage.size.height+17+chinaBankImage.size.height+15,
                                                  merchantBankImage.size.width,
                                                merchantBankImage.size.height)];
    merchantBankImageView.userInteractionEnabled = YES;
    merchantBankImageView.image = merchantBankImage;
    
    merchantBankTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                    action:@selector(success:)];
    
    [merchantBankImageView addGestureRecognizer:merchantBankTapGesture];
    
    [mainScrollView addSubview:merchantBankImageView];
    
    
}

//返回按钮
-(void)backButtonMethod
{

    [self.navigationController popViewControllerAnimated:YES];

}

///手势方法
-(void)success:(UITapGestureRecognizer*)tap
{
    if (tap == alipayTapGesture) {
        
        NSLog(@"支付宝");
        
        
    } else if (tap == merchantBankTapGesture) {
        
      
        NSLog(@"招商银行");
        
    }else {
        
        NSLog(@"中国银行");
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
