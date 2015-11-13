//
//  TempOrderContestant.m
//  Gocycling
//
//  Created by LaiZhaowu on 14-6-15.
//
//

#import "TempOrderContestant.h"
#import "CustomMarcos.h"

@interface TempOrderContestant ()

//@property (nonatomic, retain) NSMutableArray *orderContestantArray;

@end


@implementation TempOrderContestant

static TempOrderContestant *sharedTempOrderContestantManager = nil;

+ (TempOrderContestant *)sharedTempOrderContestant
{
    if (sharedTempOrderContestantManager == nil) {
        sharedTempOrderContestantManager = [[super allocWithZone:NULL] init];
        
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        sharedTempOrderContestantManager.orderContestantArray = [userDefaults objectForKey:TEMP_ORDER_CONTESTANT_LIST];
    }
    
    return sharedTempOrderContestantManager;
}

- (void)addOrderContestant:(OrderContestant *)orderContestant;
{
    NSArray *oldOrderContestantArray = [self loadData];
    NSMutableArray *currentOrderContestantArray = [[NSMutableArray alloc] init];
    if ([oldOrderContestantArray count] > 0) {
        [currentOrderContestantArray addObjectsFromArray:oldOrderContestantArray];
    }
    [currentOrderContestantArray addObject:orderContestant];
    [self saveDataByOrderContestantArray:currentOrderContestantArray];
}

- (NSArray *)loadData
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:TEMP_ORDER_CONTESTANT_LIST];
    NSArray *orderContestantArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return orderContestantArray;
}

- (void)saveDataByOrderContestantArray:(NSArray *)orderContestantArray
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:orderContestantArray];
    [[NSUserDefaults standardUserDefaults] setValue:data forKey:TEMP_ORDER_CONTESTANT_LIST];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)orderContestantArrayByActivityID:(int)activityID competitionID:(int)competitionID
{
    NSArray *oldOrderContestantArray = [self loadData];
    NSMutableArray *updateOrderContestantArray = [[NSMutableArray alloc] init];
    for (OrderContestant *orderContestant in oldOrderContestantArray) {
        if (orderContestant.activityID == activityID && orderContestant.competitionID == competitionID) {
            [updateOrderContestantArray addObject:orderContestant];
        }
    }

    return [[NSArray alloc] initWithArray:updateOrderContestantArray];
}

@end
