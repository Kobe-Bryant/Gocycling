//
//  SelectProjectViewController.m
//  doomcom.Goclaying
//
//  Created by Apple on 14-3-20.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import "SelectProjectViewController.h"
#import "Macros.h"
#import "ActivityCell.h"
#import "ConfirmViewController.h"
#import "Result.h"
#import "ActivityCompetition.h"
//#import "ValidateOrderCompetionInfo.h"
#import "CommentSingleClass.h"
#import "ApplyViewController.h"
#import "Activity.h"
#import "TempOrderContestant.h"

@interface SelectProjectViewController ()
{
    
    UITableView* mainTableView;
    UIImage* image;
    UIImage* grayImage;
    UITapGestureRecognizer* continueApplyTapGesture;
    UITapGestureRecognizer* nextstepTapGesture;
    BOOL isEnter;
    NSArray* competionArray;
    NSMutableArray* eventcompetionIDArray;
    NSArray* eventIdArray;
    NSMutableArray* eventcompetionArray;
    //    ValidateOrderCompetionInfo* validateorderInfo;
    UIImage* hightImage;
    BOOL isRfesh;
    UILabel* applyLabel;
    NSString* idString;
    BOOL isChangeCellColor;
    BOOL hasSelectedRow;
    
    
    
    
    
    
    
    
}
//创建tableview的头部视图和底部视图
-(void)createTableViewHeadViewAndFooterView;

//获取网络数据
-(void)getWebServiceData;


@end

@implementation SelectProjectViewController

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
    //    label.text = NSLocalizedString(@"选择项目", nil);
    //    self.navigationItem.titleView = label;
    self.title = @"选择项目";
    
    
    
    //返回的leftBarButtonItem
//    UIImage* backImage = [UIImage imageNamed:@"arrowback.png"];
//    UIButton* bt = [UIButton buttonWithType:UIButtonTypeCustom];
//    bt.frame = CGRectMake(0, 0,backImage.size.width, backImage.size.height);
//    [bt setImage:backImage forState:UIControlStateNormal];
//    [bt addTarget:self action:@selector(backButtonMethod) forControlEvents:
//     UIControlEventTouchUpInside];
//    UIBarButtonItem* left = [[UIBarButtonItem alloc]initWithCustomView:bt];
//    self.navigationItem.leftBarButtonItem = left;
    UIImage* closeButtonImage = [UIImage imageNamed:@"_leftbutton.png"];
    UIButton* closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(0.0,
                                   0.0,
                                   closeButtonImage.size.width,
                                   closeButtonImage.size.height);
    [closeButton setImage:closeButtonImage forState:UIControlStateNormal];
    [closeButton addTarget:self
                    action:@selector(close)
          forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:closeButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;

    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearCount:)
                                                 name:@"clearApplyViewControllerDic"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeTableViewBackGround)
                                                 name:@"setTableViewBackGround"
                                               object:nil];
    
    //获取网络数据
    [self getWebServiceData];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    eventcompetionIDArray = [NSMutableArray array];
    eventcompetionArray= [NSMutableArray array];
    [mainTableView reloadData];
    
    
    
    
    if (isEnter) {
        
        return ;
        
    }else {
        
        isEnter = YES;
        
    }
    
    
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,
                                                                 self.view.frame.size.width,
                                                                 self.view.frame.size.height)
                                                style:UITableViewStyleGrouped];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    [self.view addSubview:mainTableView];
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320,
                                                           mainTableView.frame.size.height)];
    view.backgroundColor = [UIColor whiteColor];
    
    mainTableView.backgroundView = view;
    
    
    //创建tableview的头部视图和底部视图方法
    [self createTableViewHeadViewAndFooterView];
    
}

//创建tableview的头部视图和底部视图
-(void)createTableViewHeadViewAndFooterView
{
    
    //tableView的tableHeaderView
    UIView* tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,
                                                                    self.view.frame.size.width, 72)];
    
    tableHeadView.backgroundColor = UIColorFromRGB(235.0, 239.0, 241.0);
    
    UIImage* titleImage = [UIImage imageNamed:@"_titleimage.png"];
    
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 20,
                                                                          titleImage.size.width,
                                                                          titleImage.size.height)];
    imageView.image = titleImage;
    [tableHeadView addSubview:imageView];
    mainTableView.tableHeaderView = tableHeadView;
    mainTableView.sectionHeaderHeight = 0;
    mainTableView.sectionFooterHeight = 0;
    
    
    //tableView的tableFooterView
    UIView* tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,
                                                                      self.view.frame.size.width, 150)];
    
    tableFooterView.backgroundColor = [UIColor colorWithCGColor:
                                       UIColorFromRGB(255.0, 255.0, 255.0).CGColor];
    
    applyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
    applyLabel.backgroundColor = [UIColor clearColor];
    applyLabel.font = [UIFont systemFontOfSize:12];
    applyLabel.hidden = YES;
    applyLabel.textColor = UIColorFromRGB(233.0, 66.0, 75.0);
    
    [tableFooterView addSubview:applyLabel];
    
    
    
    //    UIImage* continueImage = [UIImage imageNamed:@"continue.png"];
    //
    //    UIImageView* continueImageView = [[UIImageView alloc]initWithFrame:CGRectMake
    //                                                                          (10,
    //                                                                           40,
    //                                                     continueImage.size.width,
    //                                                    continueImage.size.height)];
    //    continueImageView.image = continueImage;
    //    continueImageView.userInteractionEnabled = YES;
    
    
//    UIImage* nextstepImage = [UIImage imageNamed:@"nextstep.png"];
//    
//    
//    UIImageView* nextImageView = [[UIImageView alloc]initWithFrame:CGRectMake
//                                  (10,
//                                   40,
//                                   nextstepImage.size.width,
//                                   nextstepImage.size.height)];
//    nextImageView.image = nextstepImage;
//    nextImageView.userInteractionEnabled = YES;
//    [tableFooterView addSubview:nextImageView];
    
    
    //继续报名的手势方法
    //    continueApplyTapGesture = [[UITapGestureRecognizer alloc]
    //                          initWithTarget:self action:@selector(continuejoin:)];
    //    [continueImageView addGestureRecognizer:continueApplyTapGesture];
    
    
    //下一步的手势方法
//    nextstepTapGesture = [[UITapGestureRecognizer alloc]
//                          initWithTarget:self action:@selector(continuejoin:)];
//    [nextImageView addGestureRecognizer:nextstepTapGesture];
    UIImage *nextStepButtonImage = [UIImage imageNamed:@"nextstepImage"];
    UIButton *nextStepButton = [[UIButton alloc] init];
    nextStepButton.frame = CGRectMake(10.0,
                                      40.0,
                                      nextStepButtonImage.size.width,
                                      nextStepButtonImage.size.height);
    [nextStepButton setImage:nextStepButtonImage forState:UIControlStateNormal];
    [tableFooterView addSubview:nextStepButton];
    mainTableView.tableFooterView = tableFooterView;
    
    
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)getWebServiceData
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        Result* result = [Activity requestActivityCompetitionListByActivityID:self.eventID];
        if (result.isSuccess) {
            competionArray = (NSArray*)result.data;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [mainTableView reloadData];
        });
    });
}

#pragma mark UITableviewDatasource Method

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundView = nil;
    
    if (IOS_VERSION_LESS_THAN(@"7.0")) {
        tableView.separatorColor = UIColorFromRGB(191.0, 191.0, 191.0);
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    //为tableview的section的头部添加视图
    if (section == 0) {
        
        
        UIImageView* sectionHeadView = [[UIImageView alloc]initWithFrame:
                                        CGRectMake(0, 72,
                                                   self.view.frame.size.width, 25)];
        
        sectionHeadView.image = [UIImage imageNamed:@"sectionHeadview.png"];
        
        if (IOS_VERSION_LESS_THAN(@"7.0")) {
            
            sectionHeadView.image = [UIImage imageNamed:@"sectiontitleview-.png"];
            
            
        }
        
        UILabel* firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 4, 100, 17)];
        
        firstLabel.font = [UIFont systemFontOfSize:12];
        firstLabel.backgroundColor = [UIColor clearColor];
        firstLabel.textColor = [UIColor colorWithCGColor:
                                UIColorFromRGB(49.0, 49.0, 49.0).CGColor];
        
//        ActivityCompetition* list = competionArray[section];
        ActivityCompetitionCategory *competitionCategory = [competionArray objectAtIndex:section];
        
        
        firstLabel.text = competitionCategory.title;
        
        [sectionHeadView addSubview:firstLabel];
        
        sectionHeadView.backgroundColor = [UIColor colorWithCGColor:
                                           UIColorFromRGB(248.0, 248.0, 248.0).CGColor];
        
        return sectionHeadView;
        
    } else  {
        
        
        UIImageView* sectionHeadView = [[UIImageView alloc]initWithFrame:
                                        CGRectMake(0, 72,
                                                   self.view.frame.size.width, 25)];
        
        sectionHeadView.image = [UIImage imageNamed:@"sectionHeadview-.png"];
        
        if (IOS_VERSION_LESS_THAN(@"7.0")) {
            
            sectionHeadView.image = [UIImage imageNamed:@"sectiontitleview-.png"];
            
            
        }
        UILabel* firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 4, 100, 17)];
        
        firstLabel.font = [UIFont systemFontOfSize:12];
        firstLabel.backgroundColor = [UIColor clearColor];
        firstLabel.textColor = [UIColor colorWithCGColor:
                                UIColorFromRGB(49.0, 49.0, 49.0).CGColor];
        
        ActivityCompetitionCategory *competitionCategory = [competionArray objectAtIndex:section];
        
        
        
        firstLabel.text = competitionCategory.title;
        
        
        [sectionHeadView addSubview:firstLabel];
        
        sectionHeadView.backgroundColor = [UIColor colorWithCGColor:
                                           UIColorFromRGB(248.0, 248.0, 248.0).CGColor];
        
        
        return sectionHeadView;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //    if (section == 0 || section == 1) {
    //
    //        return 25.0;
    //    }
    //        return 0.0;
    
    return 25.0;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return competionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ActivityCompetitionCategory* competitionCategory = [competionArray objectAtIndex:section];
    
    return competitionCategory.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString* cellid = @"cell";
    
    ActivityCell* activityCell = (ActivityCell*)[tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (activityCell == nil) {
        
        
        activityCell = [[ActivityCell alloc]initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:cellid];
    }
    
    activityCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ActivityCompetitionCategory* competitionCategory = competionArray[indexPath.section];
    ActivityCompetition* competition = competitionCategory.items[indexPath.row];
    
    grayImage = [UIImage imageNamed:@"graycircleImage.png"];
    activityCell.imageView.frame = CGRectMake(15, 18, grayImage.size.width, grayImage.size.height);
    activityCell.imageView.image = grayImage;
    
    
    
    //        NSLog(@"selectID = %d",itemList.competitionId);
    
    
    
    //        for (ValidateOrderCompetionInfo* orderinfo in validateorderInfo.orderCompetionArray) {
    //
    //            NSLog(@"%d",validateorderInfo.orderCompetionArray.count);
    //
    //
    //            NSLog(@"%d",orderinfo.competitionId);
    //
    //            if (itemList.competitionId == orderinfo.competitionId) {
    //
    //
    //                itemList.quotaCount = orderinfo.quotaCount;
    //                activityCell.isSelected = orderinfo.isSelected;
    //                activityCell.isDisabled = orderinfo.isDisabled;
    //
    //                NSLog(@"%d",activityCell.isSelected);
    //
    //                NSLog(@"%d",activityCell.isDisabled);
    //            }
    //            isRfesh = YES;
    //
    //        }
    
    NSLog(@"%d",activityCell.isSelected);
    
    NSLog(@"%d",activityCell.isDisabled);
    
    
    
    activityCell.titleLable.text = competition.title;
    activityCell.quotanumberLable.text = [NSString stringWithFormat:@"%d个", competition.quota];
    activityCell.priceLable.text = [NSString stringWithFormat:@"￥%0.f", competition.price];

    
    activityCell.titleLable.backgroundColor = [UIColor clearColor];
    activityCell.priceLable.backgroundColor = [UIColor clearColor];
    activityCell.quotanumberLable.backgroundColor = [UIColor clearColor];
    activityCell.priceLable.backgroundColor = [UIColor clearColor];
    
    
    NSArray *orderContestantArray = [[TempOrderContestant sharedTempOrderContestant] orderContestantArrayByActivityID:self.eventID competitionID:competition.activityCompetitionID];
    [activityCell setContestantListArray:orderContestantArray];
    
    
    if (isRfesh) {
        
        
//        if (activityCell.isSelected==1 ) {
//            
//            activityCell.imageView.image = hightImage;
//            
//            
//            
//        }else
//        {
//            activityCell.imageView.image = grayImage;
//            
//        }
        
        
//        if ( activityCell.isDisabled == 1) {
//            
//            activityCell.backgroundColor = [UIColor lightGrayColor];
//            activityCell.userInteractionEnabled = NO;
//            
//        }else
//        {
//            
//            activityCell.backgroundColor = [UIColor clearColor];
//            activityCell.userInteractionEnabled = YES;
//            
//        }
        
        
        
    }
    
    //        if (validateorderInfo.orderCompetionArray.count == 0 ) {
    //
    //            activityCell.imageView.image = grayImage;
    //            activityCell.backgroundColor = [UIColor clearColor];
    //            activityCell.userInteractionEnabled = YES;
    //
    //        }
    if (isChangeCellColor) {

        activityCell.backgroundColor = [UIColor clearColor];
        activityCell.userInteractionEnabled = YES;
        activityCell.imageView.image = grayImage;
        
        
    }
    
    
    
    
    return activityCell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityCompetitionCategory* competitionCategory = competionArray[indexPath.section];
    ActivityCompetition* competition = competitionCategory.items[indexPath.row];
    
    ApplyViewController *applyVC = [[ApplyViewController alloc] init];
    applyVC.currentEventID = self.eventID;
    applyVC.currentCompetitionID = competition.activityCompetitionID;
    [self.navigationController pushViewController:applyVC animated:YES];
    
    //    eventcompetionArray
    //    eventIdArray;
    
//    hasSelectedRow = YES;
//    isChangeCellColor = NO;
//    NSLog(@"eventcount %d",eventcompetionIDArray.count);
    
//    ActivityCell*  activityCell;
    
//    hightImage = [UIImage imageNamed:@"blue.png"];
//    
//    activityCell = (ActivityCell*)[tableView cellForRowAtIndexPath:indexPath];
//    activityCell.imageView.image = hightImage;
    
    
    //    ActivityCompetition* list = competionArray[indexPath.section];
    //
    //    ActivityCompetition* listone= list.competionItemArray[indexPath.row];
    //
    //    NSLog(@"%d",listone.competitionId);
    //
    //
    //    if ([eventcompetionIDArray containsObject:[[NSNumber numberWithInt:listone.competitionId ] stringValue]]) {
    //
    //        [eventcompetionIDArray removeObject:[[NSNumber numberWithInt:listone.competitionId ] stringValue]];
    //        activityCell.imageView.image = grayImage;
    //
    //    }else {
    //
    //
    //         [eventcompetionIDArray addObject:[[NSNumber numberWithInt:listone.competitionId ] stringValue]];
    //
    //    }
    
    
    
//    NSLog(@"%@",eventcompetionIDArray);
//    
//    eventIdArray = (NSArray*)eventcompetionIDArray;
//    
//    
//    
//    idString = [eventcompetionIDArray componentsJoinedByString:@","];
//    NSLog(@"string = %@",idString);
//    
//    ActivityCompetition* listcompetion = competionArray[indexPath.section];
//    
//    ActivityCompetition*  itemList = listcompetion.competionItemArray[indexPath.row];
//    
//    if ([eventcompetionArray containsObject:[[NSNumber numberWithFloat:itemList.competionPrice] stringValue]] || [eventcompetionArray containsObject:itemList.itemTitleString]) {
//        
//        [eventcompetionArray removeObject:[NSNumber numberWithFloat:itemList.competionPrice]];
//        [eventcompetionArray removeObject:itemList.itemTitleString];
//        
//        
//    }else {
//        
//        
//        [eventcompetionArray addObject:itemList.itemTitleString];
//        [eventcompetionArray addObject:[NSNumber numberWithFloat:itemList.competionPrice]];
//        
//    }
//    
//    
//    
//    
//    
//    
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    
//    dispatch_async(queue, ^{
//        
//        
//        
//        
//        //    Result* result = [ValidateOrderCompetionInfo validateOrderCompetionInfo:self.eventID competionIdList:idString];
//        //
//        //
//        //
//        //        dispatch_async(dispatch_get_main_queue(), ^{
//        //
//        //
//        //            if (result.isSuccess) {
//        //
//        //                validateorderInfo = (ValidateOrderCompetionInfo*)result.data;
//        //
//        //                applyLabel.text = [NSString stringWithFormat:@"您的报名费用合计 : ￥%0.f",validateorderInfo.totalPrice];
//        //
//        //                applyLabel.hidden = NO;
//        //                [mainTableView reloadData];
//        //
//        //            }else
//        //            {
//        //
//        //                validateorderInfo.orderCompetionArray = nil;
//        //                applyLabel.hidden = YES;
//        //                [mainTableView reloadData];
//        //
//        //             }
//        //
//        //});
//        //
//    });
    
    
    
}

-(void)backButtonMethod
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

static int count=0;

//为继续报名和下一步按钮添加相应事件方法
-(void)continuejoin:(UITapGestureRecognizer*)tap
{
    
    if (tap==continueApplyTapGesture) {
        
        NSLog(@"继续报名");
        [self.navigationController popViewControllerAnimated:YES];
        
    }else
    {
        if (hasSelectedRow) {
            
            
            
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            
            dispatch_async(queue, ^{
                
                
                //            Result* result = [ValidateOrderCompetionInfo validateOrderCompetionInfo:self.eventID competionIdList:idString];
                //
                //
                //
                //            dispatch_async(dispatch_get_main_queue(), ^{
                //
                //
                //                if (result.isSuccess) {
                //
                //
                //                    NSLog(@"SelectProjectViewController count = %d",count);
                //
                //                    NSString* key = [NSString stringWithFormat:@"key%d",count];
                //                    NSMutableDictionary* dic = [self.personInfomationDic objectForKey:key];
                //
                //
                //
                //                    [dic setObject:eventcompetionArray forKey:@"eventName"];
                //
                //
                //                    [dic setObject:eventIdArray forKey:@"competitionId"];
                //
                //
                //                    count++;
                //
                //
                //                    NSLog(@"%@",self.personInfomationDic);
                //
                //
                //                    //跳转到名单确认视图控制器
                //                    ConfirmViewController* confirmVC = [[ConfirmViewController alloc]init];
                //                    confirmVC.selectCount = eventcompetionArray.count/2;
                //                    confirmVC.toogleClickDelegate = self;
                //                    confirmVC.personInfomationDic = self.personInfomationDic;
                //                    confirmVC.activityID =self.eventID;
                //                    hasSelectedRow = NO;
                //                    
                //                    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                //                        confirmVC.edgesForExtendedLayout = NO;
                //                    }
                //                    [self.navigationController pushViewController:confirmVC animated:YES];
                //                    NSLog(@"下一步");
                //                }else
                //                {
                //                
                //                
                //                    UIAlertView* alertVirew = [[UIAlertView alloc]initWithTitle:[result.error localizedDescription] message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                //                    [alertVirew show];
                //    
                //                }
                //        });
                
                
            });
            
        }else {
            
            UIAlertView* alertVirew = [[UIAlertView alloc]initWithTitle:@"您还没有选择比赛项目？" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alertVirew show];
        }
    }
    
}
-(void)changeTableViewBackGround
{
    isChangeCellColor = YES;
    [mainTableView reloadData];
    
}

-(void)clearCount:(NSNotification*)notification
{
    
    count = 0;
    
}

- (void)toggleClickBackButton:(id)sender
{
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
