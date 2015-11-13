//
//  GoodsEvaluatesViewController.m
//  doomcom.Goclaying
//
//  Created by Apple on 14-3-25.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import "GoodsEvaluatesViewController.h"
#import "Macros.h"
#import "GoodsEvaluateCell.h"
#import "RatingView.h"
#import "ProductComment.h"
#import "Result.h"

@interface GoodsEvaluatesViewController ()
{
    
    UITableView* mainTableView;
    UIImageView* segmentImageView;
    UITapGestureRecognizer* segmentTapGesture;
    UIImage* segmentImage;
    UIScrollView*  mainScrollView;
    RatingView*  ratingView;
    UITextField* writeTextField;
    BOOL isEnter;
    UILabel* seeLabel;
    
    
}

@property(nonatomic,strong) NSArray* dataArray;


@end

@implementation GoodsEvaluatesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        isEnter = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //navigationItem的titleView
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, 75, 20)];
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = NSLocalizedString(@"产品评论", nil);
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
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    NSLog(@"GoodsEvaluatesViewController   =  %@",NSStringFromCGRect(self.view.frame));
    
    [self getWebServiceData];

    //判断是否进入
    if (isEnter) {
        
        return;
        
    }else
    {
        
        isEnter = YES;
    }

    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        
        //设置导航栏的背景
        UIImage* barImage = [UIImage imageNamed:@"navigaback.png"];
        [self.navigationController.navigationBar setBackgroundImage:barImage
                                                      forBarMetrics:UIBarMetricsDefault];
        
    }else  {
    
        
        //设置导航栏的背景
        UIImage* barImage = [UIImage imageNamed:@"navigationbar_"];
        [self.navigationController.navigationBar setBackgroundImage:barImage
                                                      forBarMetrics:UIBarMetricsDefault];
    
    }
    
    
    
    //导航栏下面的分段控件视图
    segmentImage = [UIImage imageNamed:@"segment.png"];
    segmentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(
                   (self.view.frame.size.width-segmentImage.size.width)/2.0, 5,
                            segmentImage.size.width, segmentImage.size.height)];
    segmentImageView.image = segmentImage;
    segmentImageView.userInteractionEnabled = YES;
    segmentTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                   action:@selector(clicktap:)];
    [segmentImageView addGestureRecognizer:segmentTapGesture];
    [self.view addSubview:segmentImageView];
    
    
    //导航栏下面的线条
    UIImage* bardownLineImage = [UIImage imageNamed:@"_barline.png"];
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,
                                                   10+segmentImage.size.height,
                                            320, bardownLineImage.size.height)];
    imageView.image = bardownLineImage;
    [self.view addSubview:imageView];
    
    
    //分段控件上面的label 包括seeLabel | evaluateLable
    seeLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 150, 30)];
    seeLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                 (255.0, 255.0, 255.0).CGColor];
    seeLabel.font = [UIFont systemFontOfSize:13];
    seeLabel.backgroundColor = [UIColor clearColor];
    [segmentImageView addSubview:seeLabel];
    
    UILabel* evaluateLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 0, 100, 30)];
    evaluateLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                    (68.0, 68.0, 68.0).CGColor];
    evaluateLabel.font = [UIFont systemFontOfSize:13];
    evaluateLabel.backgroundColor = [UIColor clearColor];
    evaluateLabel.text = @"我要评论";
    [segmentImageView addSubview:evaluateLabel];
    
    
    //创建TableView
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,40,
                                                    self.view.frame.size.width,
                                                    self.view.frame.size.height)
                                                   style:UITableViewStylePlain];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    [self.view addSubview:mainTableView];
    
}

-(void)getWebServiceData
{

  
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
        NSNumber* productID = [[NSUserDefaults standardUserDefaults]objectForKey:
                               @"currentProductID"];
        
        Result* result = [ProductComment requestListWithOffset:0 limit:4 productID:productID];
        

        if (result.isSuccess) {
      
            
            self.dataArray = (NSArray*)result.data;
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
          
            seeLabel.text = [NSString stringWithFormat:@"查看评论(%d)",self.dataArray.count];
 
            [mainTableView reloadData];
            
        });
        
        
    });


}


-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
    UIImage* shadowImage = [UIImage imageNamed:@"navigationshadowImage.png"];
    
    [self.navigationController.navigationBar setBackgroundImage:shadowImage forBarMetrics:UIBarMetricsDefault];
    
}
#pragma mark UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:
                    (NSIndexPath *)indexPath
{
    
    return 140.0;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
                        (NSInteger)section
{
    
    return self.dataArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
                               (NSIndexPath *)indexPath
{
    
    static NSString* cellId = @"cellid";
    
    GoodsEvaluateCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        
        cell = [[GoodsEvaluateCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                        reuseIdentifier:cellId];
        
    }
    
    
    [cell setCellInformation:self.dataArray[indexPath.row]];
    
    return cell;
    
}

//返回按钮
-(void)backButtonMethod
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//分段控件添加的手势，判断点击左或右
-(void)clicktap:(UITapGestureRecognizer*)segmentGesture
{

    
    CGPoint point =  [segmentGesture locationInView:segmentImageView];
  
    if (point.x<=segmentImageView.frame.size.width/2.0) {
        
        [mainScrollView removeFromSuperview];
        segmentImage = [UIImage imageNamed:@"segment.png"];
        
        segmentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(
                       (self.view.frame.size.width-segmentImage.size.width)/2.0,
                                                                              5,
                                                        segmentImage.size.width,
                                                     segmentImage.size.height)];
        segmentImageView.image = segmentImage;
        
        [self.view addSubview:segmentImageView];
        
        
        UILabel* searchLable = [[UILabel alloc]initWithFrame:CGRectMake
                                                      (40, 0, 150, 30)];
        searchLable.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                (255.0, 255.0, 255.0).CGColor];
        searchLable.font = [UIFont systemFontOfSize:13];
        searchLable.backgroundColor = [UIColor clearColor];
        searchLable.text = [NSString stringWithFormat:@"查看评论(%d)",self.dataArray.count];
        [segmentImageView addSubview:searchLable];
        UILabel* evaluateLable = [[UILabel alloc]initWithFrame:CGRectMake
                                                           (200, 0, 100, 30)];
        evaluateLable.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                   (68.0, 68.0, 68.0).CGColor];
        evaluateLable.font = [UIFont systemFontOfSize:13];
        evaluateLable.backgroundColor = [UIColor clearColor];
        evaluateLable.text = @"我要评论";
        [segmentImageView addSubview:evaluateLable];
        
        
        [self.view addSubview:mainTableView];
        
    }else  {
   
        
        mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake
                                              (0, 11+segmentImage.size.height,
                                                   self.view.frame.size.width,
                                                 self.view.frame.size.height)];
        mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width,600);
        mainScrollView.delegate = self;
        mainScrollView.showsHorizontalScrollIndicator = YES;
        mainScrollView.userInteractionEnabled=YES;
        [self.view addSubview:mainScrollView];
        
        [mainTableView removeFromSuperview];
        
        
        segmentImage = [UIImage imageNamed:@"segmentImage.png"];

        segmentImageView.image = segmentImage;
        
        UILabel* evaluateLabel = [[UILabel alloc]initWithFrame:CGRectMake
                                                            (200, 0, 100, 30)];
        evaluateLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                 (255.0, 255.0, 255.0).CGColor];
        evaluateLabel.font = [UIFont systemFontOfSize:13];
        evaluateLabel.text = @"我要评论";
        evaluateLabel.backgroundColor = [UIColor clearColor];
        [segmentImageView addSubview:evaluateLabel];
        
        seeLabel = [[UILabel alloc]initWithFrame:CGRectMake
                                                              (40, 0, 150, 30)];
        seeLabel.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                                                   (68.0, 68.0, 68.0).CGColor];
        seeLabel.font = [UIFont systemFontOfSize:13];
        seeLabel.backgroundColor = [UIColor clearColor];
        
        seeLabel.text = [NSString stringWithFormat:@"查看评论(%d)",self.dataArray.count];
        [segmentImageView addSubview:seeLabel];
        
        [self.view addSubview:segmentImageView];
        
      
    
        //评级视图
        UIImage* starImage = [UIImage imageNamed:@"biggrayStar.png"];
        
        ratingView = [[RatingView alloc]initWithFrame:CGRectMake(20, 25,
                                                         starImage.size.width*5,
                                                         starImage.size.height)
                                                        andFloat:0 starStyle:1];
        
        ratingView.userInteractionEnabled = YES;
        UITapGestureRecognizer* clickStarGesture = [[UITapGestureRecognizer alloc]
                              initWithTarget:self action:@selector(clickStar:)];
        [ratingView addGestureRecognizer:clickStarGesture];
        
        [mainScrollView addSubview:ratingView];
        
        //星星下面的uitexfield的背景图片
        UIImage* writeBackImage = [UIImage imageNamed:@"writeback.png"];
        
        
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(
                     (self.view.frame.size.width-writeBackImage.size.width)/2.0,
                                                                             80,
                                                      writeBackImage.size.width,
                                                   writeBackImage.size.height)];
        imageView.userInteractionEnabled = YES;
        imageView.image = writeBackImage;
        [mainScrollView addSubview:imageView];
        
        
        if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            
            writeTextField = [[UITextField alloc]initWithFrame:CGRectMake(17,
                                                                          -50,
                                                    writeBackImage.size.width,
                                                   writeBackImage.size.height)];
            
        }else {
        
            writeTextField = [[UITextField alloc]initWithFrame:CGRectMake(17,
                                                                          20,
                                                      writeBackImage.size.width,
                                                   writeBackImage.size.height)];
        }
        writeTextField.delegate = self;
        writeTextField.tag = 1;
        writeTextField.placeholder = @"写点什么吧.......";
        writeTextField.userInteractionEnabled = YES;
        [imageView addSubview:writeTextField];
      
        
        //确定按钮
        UIImage* sureImage = [UIImage imageNamed:@"sure_.png"];
        
        UIImageView* sureImageView = [[UIImageView alloc]initWithFrame:
              CGRectMake((self.view.frame.size.width-sureImage.size .width)/2.0,
                          230.0,sureImage.size.width, sureImage.size.height)];
        sureImageView.userInteractionEnabled = YES;
        sureImageView.image = sureImage;
        [mainScrollView addSubview:sureImageView];
    
    }
    
    
}

//确定星星的分数的点击方法
-(void)clickStar:(UITapGestureRecognizer*)clickStarGesture
{
 
    CGPoint point = [clickStarGesture locationInView:ratingView];
    
    
    if (point.x >= 4.0 && point.x <= 35) {
        
        ratingView.lable.text = nil;
        
        
        ratingView = [ratingView initWithFrame:CGRectZero andFloat:1 starStyle:1];
        
            if (point.x >= 4.0 && point.x <= 10) {
      
            ratingView.lable.text = nil;

            ratingView = [ratingView initWithFrame:CGRectZero andFloat:0
                                                             starStyle:1];
            }
        
    }
    if (point.x >= 40.0 && point.x <= 75) {
        
        ratingView.lable.text = nil;
        
        ratingView = [ratingView initWithFrame:CGRectZero andFloat:2 starStyle:1];
    }
    if (point.x >= 80.0 && point.x <= 113) {
        
        ratingView.lable.text = nil;
        
        ratingView = [ratingView initWithFrame:CGRectZero andFloat:3 starStyle:1];
    }
    if (point.x >= 122.0 && point.x <= 155) {
        
        ratingView.lable.text = nil;
        
        ratingView = [ratingView initWithFrame:CGRectZero andFloat:4 starStyle:1];
    }
    if (point.x >= 160.0 && point.x <= 180) {
        
        ratingView.lable.text = nil;
        
        ratingView = [ratingView initWithFrame:CGRectZero andFloat:5 starStyle:1];
    }
    
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 1) {
        
        if (IOS_VERSION_LESS_THAN(@"7.0")) {
            
       
            mainScrollView.contentOffset = CGPointMake(0, 65);
       }
        
            mainScrollView.contentOffset = CGPointMake(0, 35);
    }
    
       return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    return YES;
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    
    if (textField.tag == 1) {
        
        [writeTextField resignFirstResponder];
        mainScrollView.contentOffset = CGPointMake(0, 0);
    }
  
    return YES;
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{

    if ([scrollView isMemberOfClass:[UIScrollView class]]) {
   
        
        [writeTextField resignFirstResponder];
        
         NSLog(@"scrollView WillBeginDragging");
        
    }else  {
        

         NSLog(@"tableview BeginDragging");
        
    }
    
}

- (void)didReceiveMemoryWarning
{
   
    [super didReceiveMemoryWarning];
}

@end
