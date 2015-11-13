//
//  ProductCategory.h
//  Gocycling
//
//  Created by LaiZhaowu on 14-6-10.
//
//

#import <Foundation/Foundation.h>
#import "WebAPI.h"
#import "Result.h"

@interface ProductCategory : NSObject

@property (nonatomic, assign) int productCategoryID;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* normalImageURLString;
@property (nonatomic, strong) NSString* selectedImageURLString;
@property (nonatomic, strong) NSMutableArray* items;
@property (nonatomic, assign) int productCount;

+ (Result *)requestListWithIsRecommend:(BOOL)isRecommend productBrandID:(NSNumber *)productBrandID;

@end
