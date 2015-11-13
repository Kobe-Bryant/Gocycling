//
//  OrderContestant.h
//  Gocycling
//
//  Created by LaiZhaowu on 14-6-15.
//
//

#import <Foundation/Foundation.h>
#import "MemberContestant.h"

@interface OrderContestant : NSObject<NSCoding>

@property (nonatomic) int activityID;
@property (nonatomic) int competitionID;
@property (nonatomic, retain) MemberContestant *memberContestant;

@end
