//
//  Brand.h
//  Gocycling
//
//  Created by LaiZhaowu on 14-6-10.
//
//

#import <Foundation/Foundation.h>
#import "WebAPI.h"
#import "Result.h"

@interface Brand : NSObject

@property (nonatomic, assign) int brandID;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* summary;
@property (nonatomic, strong) NSString* imageURLString;
@property (nonatomic, assign) int productCount;

+ (Result *)requestListWithIsRecommend:(BOOL)isRecommend productCategoryID:(NSNumber *)productCategoryID;
+ (Result *)requestByBrandID:(int)brandID;

@end
