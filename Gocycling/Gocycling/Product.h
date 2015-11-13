//
//  Product.h
//  Gocycling
//
//  Created by LaiZhaowu on 14-6-10.
//
//

#import <Foundation/Foundation.h>
#import "WebAPI.h"
#import "Result.h"
#import "ProductImage.h"
#import "ProductComment.h"

@interface Product : NSObject

@property (nonatomic, assign) int productID;
@property (nonatomic, strong) NSString* searchKeyword;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* imageURLString;
@property (nonatomic, assign) float productPrice;
@property (nonatomic, strong) NSString* brandName;
@property (nonatomic, assign) int commentCount;
@property (nonatomic, strong) NSString* intro;
@property (nonatomic, assign) float ratingFloat;
@property (nonatomic, strong) NSString* sybase;
@property (nonatomic, strong) NSMutableArray* productImageArray;

+ (Result*)requestSearchListWithIsRecommend:(NSNumber *)isRecommend productCategoryID:(NSNumber *)productCategoryID productBrandID:(NSNumber *)productBrandID searchKeyword:(NSString*)searchKeyword limit:(NSInteger)limit;
+ (Result*)requestListWithIsRecommend:(NSNumber *)isRecommend productCategoryID:(NSNumber *)productCategoryID productBrandID:(NSNumber *)productBrandID searchKeyword:(NSString*)searchKeyword offset:(NSInteger)offset limit:(NSInteger)limit;
+ (Result*)requestByProductID:(NSNumber*)productID;
+ (Result*)requestCommentListWithOffset:(NSInteger)offset limit:(NSInteger)limit productID:(NSNumber*)productID;

@end
