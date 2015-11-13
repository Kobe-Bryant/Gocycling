//
//  FilterViewController.h
//  doomcom.Goclaying
//
//  Created by Apple on 14-3-17.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol FilterViewControllerDelegate <NSObject>
//
//- (void)didSelectedProductCategoryID:(NSNumber *)productCategoryID;
//- (void)didSelectedProductBrandID:(NSNumber *)productBrandID;
//
//@end


@interface FilterViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

//@property (nonatomic, assign) id<FilterViewControllerDelegate>delegate;
//@property NSIndexPath* selectIndexPath;
//@property(nonatomic, assign) BOOL isBrandProduct;
//@property(nonatomic) BOOL isRecommend;
//@property(nonatomic, strong) NSNumber* productCategoryID;
//@property(nonatomic, strong) NSNumber* productBrandID;

@end
