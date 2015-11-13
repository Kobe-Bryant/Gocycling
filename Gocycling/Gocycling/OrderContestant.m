//
//  OrderContestant.m
//  Gocycling
//
//  Created by LaiZhaowu on 14-6-15.
//
//

#import "OrderContestant.h"

@implementation OrderContestant

#pragma mark - NSCoding
- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.activityID = [[decoder decodeObjectForKey:@"activityID"] intValue];
        self.competitionID = [[decoder decodeObjectForKey:@"competitionID"] intValue];
        self.memberContestant = [decoder decodeObjectForKey:@"memberContestant"];
        
        return self;
    }
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:[NSNumber numberWithInt:self.activityID] forKey:@"activityID"];
    [encoder encodeObject:[NSNumber numberWithInt:self.competitionID] forKey:@"competitionID"];
    [encoder encodeObject:self.memberContestant forKey:@"memberContestant"];
    
}


@end
