//
//  TempOrderContestant.h
//  Gocycling
//
//  Created by LaiZhaowu on 14-6-15.
//
//

#import <Foundation/Foundation.h>
#import "OrderContestant.h"


@interface TempOrderContestant : NSObject

+ (TempOrderContestant *)sharedTempOrderContestant;
- (void)addOrderContestant:(OrderContestant *)orderContestant;
- (NSArray *)orderContestantArrayByActivityID:(int)activityID competitionID:(int)competitionID;

@end
