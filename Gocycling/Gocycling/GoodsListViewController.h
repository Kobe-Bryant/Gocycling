//
//  GoodsListViewController.h
//  domcom.Goclay
//
//  Created by Apple on 14-3-14.
//  Copyright (c) 2014年 马峰. All rights reserved.
//

#import <UIKit/UIKit.h>



//@protocol GoodsListViewControllerDelegate <NSObject>
//
//- (void)toggleClickButton:(id)sender;
//
//@end

//signature: 签名
//isRecommend: 是否为推荐产品(0:不区分, 1:是)
//productCategoryId: 产品分类ID(无指定分类值为-1)
//productBrandId: 产品品牌ID(无指定品牌值为-1)
//searchKeyword: 搜索关键词(无指定搜索关键词值为空字符)
//offset: 分页起始数
//limit: 分页页面显示最大数
//+(Result*)requestResult:(NSNumber *)isRecommend productCategoryId:(NSNumber *)productCategoryId
//productBrandId:(NSNumber *)productBrandId searchKeyword:(NSString*)searchKeyword
//offset:(NSInteger)offset limit:(NSInteger)limit

@interface GoodsListViewController : UIViewController


//@property (nonatomic, assign) id<GoodsListViewControllerDelegate>toogleClickDelegate;

//@property NSIndexPath* selectIndexPath;
//@property (nonatomic, strong) NSNumber* isRecommend;
//@property (nonatomic, strong) NSNumber* productCategoryId;
//@property (nonatomic, strong) NSNumber* productBrandId;
//@property (nonatomic, strong) NSString* searchKeyword;

- (id)initWithIsRecommend:(NSNumber *)isRecommend productCategoryID:(NSNumber *)productCategoryID productBrandID:(NSNumber *)productBrandID searchKeyword:(NSString *)searchKeyword;
//- (void)reloadData;

@end
