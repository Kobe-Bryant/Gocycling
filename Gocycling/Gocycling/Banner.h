//
//  Banner.h
//  Gocycling
//
//  Created by LaiZhaowu on 14-6-10.
//
//

#import <Foundation/Foundation.h>
#import "WebAPI.h"
#import "Result.h"

@interface Banner : NSObject

@property (nonatomic, assign) int bannerID;
@property (nonatomic, strong) NSString* imageURLString;
@property (nonatomic, strong) NSString* title;

+ (Result*)requestList;

@end
