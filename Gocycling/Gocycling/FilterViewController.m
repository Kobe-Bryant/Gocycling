//
//  FilterViewController.m
//  doomcom.Goclaying
//
//  Created by Apple on 14-3-17.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#define MAIN_TAG 21
#define SEARCH_RESULT_TAG 22

#import "FilterViewController.h"
#import "Cell2.h"
#import "Cell1.h"
#import "Macros.h"
#import "ProductCategory.h"
#import "Brand.h"
#import "Product.h"
#import "CustomMarcos.h"



@interface FilterViewController ()
{

}

@property (nonatomic, retain) UITableView *mainTableView;
@property (nonatomic, retain) UITableView *searchTableView;
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) NSArray *productCategoryArray;
@property (nonatomic, retain) NSArray *productBrandArray;
@property (nonatomic, retain) NSArray *searchProductArray;
@property (nonatomic, retain) NSMutableArray *selectedIndexPathArray;
@property (nonatomic) BOOL isPushViewController;
@property (nonatomic) BOOL isRecommend;
@property (nonatomic) int productCategoryID;
@property (nonatomic) int productBrandID;
@property (nonatomic) BOOL isViewWillAppeared;

@end

@implementation FilterViewController

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
    
    self.view.backgroundColor = UIColorFromRGB(49.0, 49.0, 49.0);
    self.isRecommend = NO;
    self.productCategoryID = 0;
    self.productBrandID = 0;
    self.productCategoryArray = [[NSArray alloc] init];
    self.productBrandArray = [[NSArray alloc] init];
    self.selectedIndexPathArray = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pushSettingChanged:)
                                                 name:FILTER_SIDEBAR_PUSH_SETTING_CHANGED_NOTIFICATION
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(optionReseted:)
                                                 name:FILTER_SIDEBAR_OPTION_RESETED_NOTIFICATION
                                               object:nil];

}

-(void)viewWillAppear:(BOOL)animated
{
    //判断是否进入
    if (self.isViewWillAppeared) {
        return;
    } else {
        self.isViewWillAppeared = YES;
    }
    
    
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.searchBar.frame = CGRectMake(self.view.frame.size.width - FILTER_SIDEBAR_WIDTH,
                                          20.0,
                                          FILTER_SIDEBAR_WIDTH,
                                          44.0);

    } else {
        self.searchBar.frame = CGRectMake(self.view.frame.size.width - FILTER_SIDEBAR_WIDTH,
                                          0.0,
                                          FILTER_SIDEBAR_WIDTH,
                                          44.0);
    }
    self.searchBar.backgroundColor = UIColorFromRGB(49.0, 49.0, 49.0);
    if ([self.searchBar respondsToSelector:@selector(setBarTintColor:)]) {
        self.searchBar.barTintColor = UIColorFromRGB(49.0, 49.0, 49.0);
    }

    self.searchBar.tintColor = UIColorFromRGB(49.0, 49.0, 49.0);
    self.searchBar.placeholder = @"搜索";
    
    [self.view addSubview:self.searchBar];

    
    
    self.mainTableView = [[UITableView alloc] init];

    self.mainTableView.frame = CGRectMake(0.0,
                                          CGRectGetMaxY(self.searchBar.frame),
                                          self.view.frame.size.width,
                                          self.view.frame.size.height - CGRectGetMaxY(self.searchBar.frame));
    self.mainTableView.backgroundColor = [UIColor clearColor];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.separatorColor = [UIColor clearColor];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.sectionFooterHeight = 0.0;
    self.mainTableView.sectionHeaderHeight = 0.0;
    self.mainTableView.tag = MAIN_TAG;
    [self.view addSubview:self.mainTableView];
    
    
    self.searchTableView = [[UITableView alloc] init];
    self.searchTableView.frame = CGRectMake(0.0,
                                            CGRectGetMaxY(self.searchBar.frame),
                                            self.view.frame.size.width,
                                            self.view.frame.size.height - CGRectGetMaxY(self.searchBar.frame));
    self.searchTableView.backgroundColor = [UIColor clearColor];
    self.searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.searchTableView.separatorColor = [UIColor clearColor];
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
    self.searchTableView.sectionFooterHeight = 0.0;
    self.searchTableView.sectionHeaderHeight = 0.0;
    self.searchTableView.hidden = YES;
    self.searchTableView.tag = SEARCH_RESULT_TAG;
    [self.view addSubview:self.searchTableView];


    [self getWebServiceData];
}

- (void)getWebServiceData
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        Result* result = [ProductCategory requestListWithIsRecommend:self.isRecommend
                                                      productBrandID:[NSNumber numberWithInt:self.productBrandID]];
        if (result.isSuccess) {
            self.productCategoryArray = (NSArray *)result.data;
        }
    });
    dispatch_group_async(group, queue, ^{
        Result* result = [Brand requestListWithIsRecommend:self.isRecommend
                                         productCategoryID:[NSNumber numberWithInt:self.productCategoryID]];
        if (result.isSuccess) {
            self.productBrandArray = (NSArray *)result.data;
        }
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.mainTableView reloadData];
    });
}

#pragma mark UITableviewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == MAIN_TAG) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        if ([self.selectedIndexPathArray indexOfObject:indexPath] != NSNotFound) {
            if ([self.productCategoryArray count] > 0 &&  section < [self.productCategoryArray count]) {
                ProductCategory *productCategory = [self.productCategoryArray objectAtIndex:section];
                return [productCategory.items count] + 1;
            } else {
                return [self.productBrandArray count] + 1;
            }
        } else {
            return 1;
        }
    } else if (tableView.tag == SEARCH_RESULT_TAG) {
        return [self.searchProductArray count];
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 0.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    if (tableView.tag == MAIN_TAG) {
        return [self.productCategoryArray count] + 1;
    }
    
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == MAIN_TAG) {
        if (indexPath.row == 0) {
            Cell1* cell = [[Cell1 alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:nil
                                    cellControllerType:0];
            NSLog(@"[self.productCategoryArray count] %i", [self.productCategoryArray count]);
            NSLog(@"indexPath.section %i", indexPath.section);
            if (indexPath.section < [self.productCategoryArray count]) {
                ProductCategory *productCategory = [self.productCategoryArray objectAtIndex:indexPath.section];
                cell.textLabel.text = productCategory.title;
            } else {
                cell.textLabel.text = @"品牌";
            }
            
            NSLog(@"cell.textLabel.text %@", cell.textLabel.text);
            
            return cell;
        } else {
            
            static NSString *cellID = @"Cell2";
            Cell2 *cell = [[Cell2 alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:cellID
                                    cellControllerType:0];
            
            if (indexPath.section < [self.productCategoryArray count]) {
                ProductCategory *productCategory = [self.productCategoryArray objectAtIndex:indexPath.section];
                ProductCategory *productSubcategory = [productCategory.items objectAtIndex:indexPath.row - 1];
                cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@ (%i)", productSubcategory.title, productSubcategory.productCount];
            } else {
                Brand *brand = [self.productBrandArray objectAtIndex:indexPath.row - 1];
                cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@ (%i)", brand.title, brand.productCount];
            }
            
            return cell;
        }
    } else if (tableView.tag == SEARCH_RESULT_TAG) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                       reuseIdentifier:nil];
        cell.backgroundColor = [UIColor clearColor];

        UIView* separatorLineView = [[UIView alloc] init];
        if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            separatorLineView.frame = CGRectMake(0.0,
                                                 [self tableView:tableView heightForRowAtIndexPath:indexPath] - 0.5,
                                                 self.view.frame.size.width,
                                                 0.5);
        } else {
            separatorLineView.frame = CGRectMake(0.0,
                                                 [self tableView:tableView heightForRowAtIndexPath:indexPath] - 1.0,
                                                 self.view.frame.size.width,
                                                 1.0);
        }
        separatorLineView.backgroundColor = UIColorFromRGB(83.0, 83.0, 83.0);
        [cell addSubview:separatorLineView];
        
        Product *product = [self.searchProductArray objectAtIndex:indexPath.row];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.text = product.title;
        
        return cell;
    }
 
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == MAIN_TAG) {
        if (indexPath.row == 0) {
            if ([self.selectedIndexPathArray indexOfObject:indexPath] != NSNotFound) {
                [self.selectedIndexPathArray removeObject:indexPath];
                
                NSMutableArray *indexPathArray = [[NSMutableArray alloc] init];
                if (indexPath.section < [self.productCategoryArray count]) {
                    ProductCategory *productCategory = [self.productCategoryArray objectAtIndex:indexPath.section];
                    for (int i = 1; i <= [productCategory.items count]; i++) {
                        [indexPathArray addObject:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
                    }
                } else {
                    for (int i = 1; i <= [self.productBrandArray count]; i++) {
                        [indexPathArray addObject:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
                    }
                }

                [tableView beginUpdates];
                [tableView reloadRowsAtIndexPaths:@[indexPath]
                                 withRowAnimation:UITableViewRowAnimationNone];
                [tableView deleteRowsAtIndexPaths:indexPathArray
                                 withRowAnimation:UITableViewRowAnimationTop];
                [tableView endUpdates];

            } else {
                [self.selectedIndexPathArray addObject:indexPath];
                
                
                NSMutableArray *indexPathArray = [[NSMutableArray alloc] init];
                if (indexPath.section < [self.productCategoryArray count]) {
                    ProductCategory *productCategory = [self.productCategoryArray objectAtIndex:indexPath.section];
                    for (int i = 1; i <= [productCategory.items count]; i++) {
                        [indexPathArray addObject:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
                    }
                } else {
                    for (int i = 1; i <= [self.productBrandArray count]; i++) {
                        [indexPathArray addObject:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
                    }
                }
                
                
                [tableView beginUpdates];
                [tableView reloadRowsAtIndexPaths:@[indexPath]
                                 withRowAnimation:UITableViewRowAnimationNone];
                [tableView insertRowsAtIndexPaths:indexPathArray
                                 withRowAnimation:UITableViewRowAnimationBottom];
                [tableView endUpdates];
            }
        } else {
            if (indexPath.section < [self.productCategoryArray count]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:TOGGLE_FILTER_SIDEBR_NOTIFICATION
                                                                    object:self];

                ProductCategory *productCategory = [self.productCategoryArray objectAtIndex:indexPath.section];
                ProductCategory *productSubcategory = [productCategory.items objectAtIndex:indexPath.row - 1];
                self.productCategoryID = productSubcategory.productCategoryID;
                if (self.isPushViewController) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:PUSH_PRODUCT_SEARCH_NOTIFICATION
                                                                        object:@{FILTER_SIDEBAR_OPTION_PRODUCT_CATEGORY_ID: [NSNumber numberWithInt:self.productCategoryID]}];
                } else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:FILTER_SIDEBAR_OPTION_UPDATED_NOTIFICATION
                                                                        object:@{FILTER_SIDEBAR_OPTION_PRODUCT_CATEGORY_ID: [NSNumber numberWithInt:self.productCategoryID],
                                                                                 FILTER_SIDEBAR_OPTION_PRODUCT_BRAND_ID: [NSNumber numberWithInt:self.productBrandID],
                                                                                 FILTER_SIDEBAR_OPTION_PRODUCT_SEARCH_KEYWORD: self.searchBar.text}];
                }
                
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:TOGGLE_FILTER_SIDEBR_NOTIFICATION
                                                                    object:self];
                
                Brand *brand = [self.productBrandArray objectAtIndex:indexPath.row - 1];
                self.productBrandID = brand.brandID;
                if (self.isPushViewController) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:PUSH_PRODUCT_SEARCH_NOTIFICATION
                                                                        object:@{FILTER_SIDEBAR_OPTION_PRODUCT_BRAND_ID: [NSNumber numberWithInt:brand.brandID]}];
                } else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:FILTER_SIDEBAR_OPTION_UPDATED_NOTIFICATION
                                                                        object:@{FILTER_SIDEBAR_OPTION_PRODUCT_CATEGORY_ID: [NSNumber numberWithInt:self.productCategoryID],
                                                                                 FILTER_SIDEBAR_OPTION_PRODUCT_BRAND_ID: [NSNumber numberWithInt:self.productBrandID],
                                                                                 FILTER_SIDEBAR_OPTION_PRODUCT_SEARCH_KEYWORD: self.searchBar.text}];
                }

            }
            //        [self dismissViewControllerAnimated:YES completion:nil];
            //
            //        if (self.isBrandProduct) {
            //            BrandList *brand = [self.productBrandArray objectAtIndex:indexPath.row - 1];
            //            [self.delegate didSelectedproductBrandId:[NSNumber numberWithInt:brand.brandListID]];
            //        } else {
            //            ProductCategoryList *productCategory = [self.productCategoryArray objectAtIndex:indexPath.section];
            //            ProductCategoryItem *productCategoryItem = [productCategory.ProductCategoryItemArray objectAtIndex:indexPath.row - 1];
            //            [self.delegate didSelectedproductCategoryID:[NSNumber numberWithInt:productCategoryItem.productCategoryItemID]];
            //        }
        }
        
        
    } else if (tableView.tag == SEARCH_RESULT_TAG) {
        
        [self searchBarCancelButtonClicked:self.searchBar];
        
        Product *product = [self.searchProductArray objectAtIndex:indexPath.row];
        [[NSNotificationCenter defaultCenter] postNotificationName:PUSH_PRODUCT_NOTIFICATION
                                                            object:@{PRODUCT_ID: [NSNumber numberWithInt:product.productID]}];
        

    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
    NSLog(@"searchBar.showsCancelButton = %d",searchBar.showsCancelButton);
    
    
    
    if (searchBar.showsCancelButton == NO) {
        self.searchProductArray = @[];
        [self.searchTableView reloadData];
    }
    
    searchBar.showsCancelButton = YES;
    
    // Set the cancel button title
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        UIView *firstSubview = [searchBar.subviews firstObject];
        
        NSLog(@"firstSubview = %@",[searchBar.subviews firstObject]);
        
        for (UIView *subview in firstSubview.subviews) {
            
            NSLog(@"subview =  %@",subview);
            
            
            
            if ([subview isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
                [(UIButton *)subview setTintColor:[UIColor whiteColor]];
                [(UIButton *)subview setTitle:@"取消" forState:UIControlStateNormal];
            }
        }
    } else {
        for (UIView *subview in searchBar.subviews) {
            if ([subview isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
                [(UIButton *)subview setTitle:@"取消" forState:UIControlStateNormal];
            }
        }
    }
    
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FILTER_SIDEBAR_FULL_SCREEN_CHANGED_NOTIFICATION
                                                        object:self];
    
    
    self.searchTableView.hidden = NO;
    self.searchTableView.alpha = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        searchBar.frame = CGRectMake(0.0,
                                     searchBar.frame.origin.y,
                                     self.view.frame.size.width,
                                     searchBar.frame.size.height);
        self.mainTableView.alpha = 0.0;
        self.searchTableView.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.mainTableView.hidden = YES;
    }];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"searchBarCancelButtonClicked %@", searchBar);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FILTER_SIDEBAR_NORMAL_SCREEN_CHANGED_NOTIFICATION
                                                        object:self];
    
    [searchBar resignFirstResponder];
    self.mainTableView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        searchBar.showsCancelButton = NO;
        searchBar.frame = CGRectMake(self.view.frame.size.width - FILTER_SIDEBAR_WIDTH,
                                     searchBar.frame.origin.y,
                                     FILTER_SIDEBAR_WIDTH,
                                     searchBar.frame.size.height);
        self.mainTableView.alpha = 1.0;
        self.searchTableView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            self.searchTableView.hidden = YES;
        }
    }];

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"textDidChange %@", searchText);
    if (searchText.length > 0) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            Result *result = [Product requestSearchListWithIsRecommend:[NSNumber numberWithBool:self.isRecommend]
                                                     productCategoryID:[NSNumber numberWithInt:self.productCategoryID]
                                                        productBrandID:[NSNumber numberWithInt:self.productBrandID]
                                                         searchKeyword:searchText
                                                                 limit:10];
            if (result.isSuccess) {
                self.searchProductArray = (NSArray *)result.data;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.searchTableView reloadData];
                });
            }
            
        });
    } else {
        self.searchProductArray = @[];
        [self.searchTableView reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchKeyword = searchBar.text;
    
    [self searchBarCancelButtonClicked:self.searchBar];
    [[NSNotificationCenter defaultCenter] postNotificationName:TOGGLE_FILTER_SIDEBR_NOTIFICATION
                                                        object:self];
    
    NSLog(@"searchBar.text %@", self.searchBar.text);
    [[NSNotificationCenter defaultCenter] postNotificationName:PUSH_PRODUCT_SEARCH_NOTIFICATION
                                                        object:@{FILTER_SIDEBAR_OPTION_PRODUCT_SEARCH_KEYWORD: searchKeyword}];

}

- (void)pushSettingChanged:(NSNotification *)notification
{
    NSLog(@"pushSettingChanged %@", notification);
    
    self.isPushViewController = [[[notification userInfo] objectForKey:FILTER_SIDEBAR_PUSH_SETTING_IS_PUSH] boolValue];
}

- (void)optionReseted:(NSNotification *)notification
{
    NSLog(@"optionReseted %@", notification);
    
    self.isRecommend = NO;
    self.productCategoryID = 0;
    self.productBrandID = 0;
    self.selectedIndexPathArray = [[NSMutableArray alloc] init];
    self.searchBar.text = @"";
    [self.mainTableView reloadData];
    
}

@end
