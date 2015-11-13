//
//  ProductComment.h
//  Gocycling
//
//  Created by LaiZhaowu on 14-6-10.
//
//

#import <Foundation/Foundation.h>
#import "Result.h"

@interface ProductComment : NSObject

@property (nonatomic, assign) int productCommentID;
@property (nonatomic, assign) int productID;
@property (nonatomic, strong) NSString* productName;
@property (nonatomic, strong) NSString* dateString;
@property (nonatomic, strong) NSString* message;
@property (nonatomic, strong) NSString* memberName;
@property (nonatomic, assign) float ratingFloat;

+ (Result*)requestListWithOffset:(NSInteger)offset limit:(NSInteger)limit productID:(NSNumber*)productID;

@end
