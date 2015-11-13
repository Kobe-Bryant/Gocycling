//
//  NewGoodsViewController.m
//  domcom.Goclay
//
//  Created by 马峰 on 14-3-12.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import "NewGoodsViewController.h"
#import "Cell1.h"
#import "Cell2.h"
#import "Macros.h"
#import "ProductCategory.h"
#import "Result.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface NewGoodsViewController ()
{
    UITableView* mainTableView;
    NSMutableDictionary* dic;
    BOOL isEnter;
    NSArray* getProductCategoryArray;
}

@property (nonatomic,assign) BOOL isOpen;
@property NSIndexPath* selectIndexPath;
@property (nonatomic,strong) NSMutableArray* productCategoryImageArray;
@property (nonatomic,strong) NSMutableArray* selectedImageArray;
@property (nonatomic,strong) NSMutableArray* titleArray;
@property (nonatomic,strong) NSMutableArray* productIDArray;
@property (nonatomic,strong) NSMutableArray* productCountArray;

@end

@implementation NewGoodsViewController

@synthesize isOpen;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.productCategoryImageArray = [NSMutableArray array];
        self.selectedImageArray = [NSMutableArray array];
        self.titleArray = [NSMutableArray array];
        self.productIDArray = [NSMutableArray array];
        self.productCountArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"ios7navigationbarImage.png"] forBarMetrics:UIBarMetricsDefault];
    } else {
        UIImage* navigationBarImage = [UIImage imageNamed:@"ios6navigationbarImage.png"];
        [self.navigationController.navigationBar setBackgroundImage:navigationBarImage
                                                      forBarMetrics:UIBarMetricsDefault];
    }
    
    
    //navigationItem的titleView
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    label.text = NSLocalizedString(@"产品分类", nil);
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    
    
//    
//    dic = @{@"整车" : @[@"山地自行车",@"折叠自行车",@"公路自行车",
//                      @"通勤自行车",@"儿童自行车",@"其他自行车"],
//            @"装备" : @[@"车头灯",@"折叠自行车",@"公路自行车",
//                      @"通勤自行车",@"儿童自行车",@"其他自行车"],
//            @"配件" : @[@"头盔",@"手套",@"护肘",@"水壶",@"围巾",@"其他"]
//            };
//    
    isOpen = NO;
    isEnter = NO;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    
    if (isEnter) {
        return ;
    } else {
        isEnter = YES;
    }
    
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        Result* result = [ProductCategory requestListWithIsRecommend:NO productBrandID:@-1];
        if (result.isSuccess) {
            dic = [NSMutableDictionary dictionary];
            getProductCategoryArray = (NSArray*)result.data;
            for (ProductCategory* list in getProductCategoryArray) {
                [self.productCategoryImageArray addObject:list.normalImageURLString];
                [self.selectedImageArray addObject:list.selectedImageURLString];
                [self.titleArray addObject:list.title];
                
                NSMutableArray* listArray = [NSMutableArray array];
                NSMutableArray* IDArray = [NSMutableArray array];
                NSMutableArray* productCountArray = [NSMutableArray array];
                
                for (ProductCategory* item in list.items) {
                    [IDArray addObject:[NSNumber numberWithInt:item.productCategoryID]];
                    [listArray addObject:item.title];
                    [productCountArray addObject:[NSNumber numberWithInt:item.productCount]];
                }
                
                [dic setObject:listArray forKey: list.title];
                [self.productIDArray addObject:IDArray];
                [self.productCountArray addObject:productCountArray];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [mainTableView reloadData];
            });
        }
    });
    
    
    //创建TableView
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)
                                                style:UITableViewStylePlain];
    mainTableView.separatorColor = [UIColor clearColor];
    mainTableView.backgroundColor = UIColorFromRGB(249.0, 253.0, 255.0);
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.rowHeight = 140;
    mainTableView.sectionFooterHeight = 0;
    mainTableView.sectionHeaderHeight = 0;
    [self.view addSubview:mainTableView];
}

#pragma mark UITableviewDatasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0) {
        return 44.0;
    }
    
    return 152.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isOpen) {
        if (self.selectIndexPath.section == section) {
            return [[[dic allValues] objectAtIndex:section] count] + 1;
        }
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [dic allKeys].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    
    if (isOpen && self.selectIndexPath.section == section && row != 0) {
        static NSString *CellID = @"Cell2";
        Cell2 *cell = (Cell2*)[tableView dequeueReusableCellWithIdentifier:CellID];
        if (!cell) {
            cell = [[Cell2 alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellID cellControllerType:1];
//            UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(120, 5, 100, 30)];
//            label.tag = 200;
//            [cell.contentView addSubview:label];
        }
        
        cell.textLabel.text = [[[dic allValues] objectAtIndex:self.selectIndexPath.section] objectAtIndex:indexPath.row - 1];
        
        NSArray* array = self.productCountArray[indexPath.section];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"(%@)", array[indexPath.row - 1]];

//        UILabel* label = (UILabel*)[cell.contentView viewWithTag:200];
//        label.frame = CGRectMake(CGRectGetMaxX(cell.textLabel.frame), 5.0, 100.0, 15.0);
//        label.font = [UIFont systemFontOfSize:15];
//        label.backgroundColor = [UIColor clearColor];
//        label.textColor = UIColorFromRGB(149.0, 149.0, 149.0);
//        NSArray* array = self.productCountArray[indexPath.section];
//        label.text = [NSString stringWithFormat:@"(%@)", array[indexPath.row - 1]];
//        [cell.contentView addSubview:label];
        
        return cell;
    } else {
        
        
        Cell1* cell=[[Cell1 alloc]initWithStyle:UITableViewCellStyleDefault
                                reuseIdentifier:nil cellControllerType:1];
        
        if (indexPath.section==0) {
            
            UIImageView* imageView = [[UIImageView alloc]initWithFrame:
                                      CGRectMake(0, 0,320.0,152)];
            
            NSURL* imageURL = [[NSURL alloc]initWithString:self.productCategoryImageArray[0]];
            
            [imageView setImageWithURL:imageURL placeholderImage:nil];
            
            [cell.contentView addSubview:imageView];
            UILabel* lable = [[UILabel alloc]initWithFrame:CGRectMake
                              (10, 20, 40, 25)];
            lable.font = [UIFont systemFontOfSize:18];
            lable.backgroundColor = [UIColor clearColor];
            lable.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                               (27.0, 27.0, 27.0).CGColor];
            lable.text = self.titleArray[indexPath.section];
            [cell.contentView addSubview:lable];
            cell.FirstArrowImageView = [[UIImageView alloc]initWithFrame:
                                        CGRectMake(50,25,15,15)];
            [cell.contentView addSubview:cell.firstArrowImageView];
        }
        
        if (indexPath.section==1) {
            
            UIImageView* imageView = [[UIImageView alloc]initWithFrame:
                                      CGRectMake(0, 0,
                                                 320,149)];
            NSURL* imageURL = [[NSURL alloc]initWithString:self.productCategoryImageArray[1]];
            
            [imageView setImageWithURL:imageURL placeholderImage:nil];
            [cell.contentView addSubview:imageView];
            
            cell.secondArrowImageView =[[UIImageView alloc]initWithFrame:
                                        CGRectMake(280,25,15,15)];
            [cell.contentView addSubview:cell.secondArrowImageView];
            UILabel* lable = [[UILabel alloc]initWithFrame:CGRectMake
                              (240, 20, 40, 25)];
            lable.font = [UIFont systemFontOfSize:18];
            lable.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                               (27.0, 27.0, 27.0).CGColor];
            lable.text = self.titleArray[indexPath.section];
            lable.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:lable];
            
        }
        if (indexPath.section==2) {
            
            
            UIImageView* imageView = [[UIImageView alloc]initWithFrame:
                                      CGRectMake(0, 0,320,152)];
            NSURL* imageURL = [[NSURL alloc]initWithString:self.productCategoryImageArray[2]];
            
            [imageView setImageWithURL:imageURL placeholderImage:nil];
            [cell.contentView addSubview:imageView];
            
            cell.thirdArrowImageView = [[UIImageView alloc]initWithFrame:
                                        CGRectMake(50,25,15,15)];
            
            [cell.contentView addSubview:cell.thirdArrowImageView];
            
            UILabel* lable = [[UILabel alloc]initWithFrame:CGRectMake
                              (10, 20, 40, 25)];
            lable.font = [UIFont systemFontOfSize:18];
            lable.textColor = [UIColor colorWithCGColor:UIColorFromRGB
                               (27.0, 27.0, 27.0).CGColor];
            lable.text = self.titleArray[indexPath.section];
            lable.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:lable];
        }
        
        
        UIView* backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,
                                                                   self.view.frame.size.width,
                                                                   cell.contentView.frame.size.height)];
        backView.backgroundColor = [UIColor colorWithCGColor:UIColorFromRGB
                                    (243.0, 243.0, 243.0).CGColor];
        cell.backgroundView = backView;
        
        
        //改变箭头图片
        [cell changeArrowWithUp:([self.selectIndexPath isEqual:indexPath]?YES:NO)];
        
        return cell;
        
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (self.selectIndexPath.section == 0) {
        
        
        mainTableView.contentSize = CGSizeMake(self.view.frame.size.width,
                                               40.0*6+140.0*3+220.0);
    }
    
    if (indexPath.row == 0) {
        
        
        if ([indexPath isEqual:self.selectIndexPath]) {
            
            isOpen = NO;
            [self didSelectCellRowFirstDo:NO nextDo:NO];
            self.selectIndexPath = nil;
            
        }else {
            
            if (!self.selectIndexPath) {
                
                self.selectIndexPath = indexPath;
                [self didSelectCellRowFirstDo:YES nextDo:NO];
                
            } else {
                
                [self didSelectCellRowFirstDo:NO nextDo:YES];
            }
        }
        
    } else {
        
        
        [self dismissViewControllerAnimated:YES completion:
         nil];
        
    }
    

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

    if (indexPath.row > 0) {
        
     
        NSLog(@"indexPath.section =  %d ,indexPath.row =  %d",indexPath.section,indexPath.row);
        
         ProductCategory* list = getProductCategoryArray[indexPath.section];
        
        NSLog(@"%d",list.items.count);
        
        ProductCategory* item = list.items[indexPath.row-1];
        
        NSLog(@"%d",item.productCategoryID);
        
        
//        BigTwoViewController* goodlistVC = [[BigTwoViewController alloc]init];
//        self.navigationController.navigationBarHidden = YES;
//        goodlistVC.hidesBottomBarWhenPushed = YES;
//        goodlistVC.isBrandProduct = YES;
//        goodlistVC.isRecommend = @0;
//        goodlistVC.productCategoryId = [NSNumber numberWithInt:item.productCategoryItemID];
//        goodlistVC.productBrandId = @-1;
//        goodlistVC.searchKeyword = @"";
//      [self.navigationController pushViewController:goodlistVC animated:YES];
        
  }
    
}

- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert
{
    isOpen= firstDoInsert;
    
    //拿到改行的cell通过indexpath
    Cell1 *cell = (Cell1 *)[mainTableView cellForRowAtIndexPath:self.selectIndexPath];
    
    [cell changeArrowWithUp:firstDoInsert];
    
    //开始更新表示图
    
    [mainTableView beginUpdates];
    
    //拿到是哪一组
    int section = self.selectIndexPath.section;
    
    //确定每一组的个数
    int contentCount = [[[dic allValues] objectAtIndex:section]  count];
    
    
    NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
    
    
    for (NSUInteger i = 1; i < contentCount + 1; i++) {
        
        NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:i
                                                            inSection:section];
        [rowToInsert addObject:indexPathToInsert];
    }
    
    if (firstDoInsert) {
        
        [mainTableView insertRowsAtIndexPaths:rowToInsert withRowAnimation:
         UITableViewRowAnimationTop];
        
        
    } else {
        
        [mainTableView deleteRowsAtIndexPaths:rowToInsert withRowAnimation:
         UITableViewRowAnimationTop];
        
    }
    
    [mainTableView endUpdates];
    
    if (nextDoInsert) {
        
        isOpen = YES;
        self.selectIndexPath = [mainTableView indexPathForSelectedRow];
        [self didSelectCellRowFirstDo:YES nextDo:NO];
        
    }
    
    if (isOpen) {
        
        [mainTableView scrollToNearestSelectedRowAtScrollPosition:
         UITableViewScrollPositionTop animated:YES];
        
    }
    
    
}



- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
