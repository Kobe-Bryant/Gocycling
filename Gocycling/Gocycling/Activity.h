//
//  Activity.h
//  Gocycling
//
//  Created by LaiZhaowu on 14-6-10.
//
//

#import <Foundation/Foundation.h>
#import "WebAPI.h"
#import "Result.h"
#import "ActivityCompetitionCategory.h"
#import "ActivityCompetition.h"

@interface Activity : NSObject

@property (nonatomic, assign) int activityID;
@property (nonatomic, strong) NSString* dateString;
@property (nonatomic, strong) NSString* imageURLString;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, assign) BOOL isEnded;
@property (nonatomic, strong) NSString* description;
@property (nonatomic, assign) int signUpCount;

+ (Result*)requestListWithOffset:(NSInteger)offset limit:(NSInteger)limit;
+ (Result*)requestByActivityID:(int)activityID;
+ (Result*)requestActivityCompetitionListByActivityID:(int)activityID;

@end
