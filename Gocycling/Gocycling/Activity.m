//
//  Activity.m
//  Gocycling
//
//  Created by LaiZhaowu on 14-6-10.
//
//

#import "Activity.h"

@implementation Activity

+ (Result*)requestListWithOffset:(NSInteger)offset limit:(NSInteger)limit;
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:[[NSNumber numberWithInteger:offset] stringValue] forKey:@"offset"];
    [params setObject:[[NSNumber numberWithInteger:limit] stringValue] forKey:@"limit"];
    
    WebAPI* webAPI = [[WebAPI alloc] initWithMethod:@"getActivityList.html" params:params];
    Result* result = [webAPI postWithCache:^id(id responseObject) {
        if ([responseObject objectForKey:@"list"]) {
            NSDictionary* listDict = [responseObject objectForKey:@"list"];
            NSMutableArray* listArray = [[NSMutableArray alloc] init];
            for (NSDictionary* infoDict  in listDict) {
                Activity* activity = [[Activity alloc] init];
                if ([infoDict objectForKey:@"activityId"]) {
                    activity.activityID = [[infoDict objectForKey:@"activityId"] intValue];
                }
                if ([infoDict objectForKey:@"date"]) {
                    activity.dateString = [infoDict objectForKey:@"date"];
                }
                if ([infoDict objectForKey:@"title"]) {
                    activity.title = [infoDict objectForKey:@"title"];
                }
                if ([[UIScreen mainScreen] scale] == 2.0) {
                    activity.imageURLString = [infoDict objectForKey:@"photo2x"];
                } else {
                    activity.imageURLString = [infoDict objectForKey:@"photo"];
                }
                
                [listArray addObject:activity];
            }
            
            return listArray;
        }
        
        return nil;
    }];
    
    return result;
}

+ (Result*)requestByActivityID:(int)activityID;
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:[[NSNumber numberWithInt:activityID] stringValue] forKey:@"activityId"];
    
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"getActivityDetail.html" params:params];
    Result* result = [webAPI postWithCache:^id(id responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject objectForKey:@"info"]) {
            NSDictionary* infoDict = [responseObject objectForKey:@"info"];
            Activity* activity = [[Activity alloc] init];
            if ([infoDict objectForKey:@"activityId"]) {
                activity.activityID = [[infoDict objectForKey:@"activityId"] intValue];
            }
            if ([infoDict objectForKey:@"title"]) {
                activity.title = [infoDict objectForKey:@"title"];
            }
            if ([infoDict objectForKey:@"signUpCount"]) {
                activity.signUpCount = [[infoDict objectForKey:@"signUpCount"] intValue];
            }
            if ([infoDict objectForKey:@"date"]) {
                activity.dateString = [infoDict objectForKey:@"date"];
            }
            if ([infoDict objectForKey:@"isEnd"]) {
                activity.isEnded = [[infoDict objectForKey:@"isEnd"] intValue];
            }
            if ([infoDict objectForKey:@"description"]) {
                activity.description = [infoDict objectForKey:@"description"];
            }
            
            return activity;
        }
        
        return nil;
    }];
    
    return result;

}

+ (Result*)requestActivityCompetitionListByActivityID:(int)activityID
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:[[NSNumber numberWithInt:activityID] stringValue] forKey:@"activityId"];
    
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"getActivityCompetitionList.html" params:params];
    Result* result = [webAPI postWithCache:^id(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject objectForKey:@"list"]) {
            NSDictionary* listDict = [responseObject objectForKey:@"list"];
            NSMutableArray* competitionCategoryArray = [NSMutableArray array];
            for (NSDictionary* competitionCategoryDict in listDict) {
                ActivityCompetitionCategory* competitionCategory = [[ActivityCompetitionCategory alloc] init];
                if ([competitionCategoryDict objectForKey:@"title"]) {
                    competitionCategory.title = [competitionCategoryDict objectForKey:@"title"];
                }
                
                NSMutableArray *competitionArray = [[NSMutableArray alloc] init];
//                activityCompetition.competionItemArray = [NSMutableArray array];                
                if ([competitionCategoryDict objectForKey:@"items"]) {
                    NSDictionary* itemsDict = [competitionCategoryDict objectForKey:@"items"];
                    for (NSDictionary* competitionDict in itemsDict) {
                        ActivityCompetition *activityCompetition = [[ActivityCompetition alloc] init];
                        if ([competitionDict objectForKey:@"competitionId"]) {
                            activityCompetition.activityCompetitionID = [[competitionDict objectForKey:@"competitionId"]intValue];
                        }
                        if ([competitionDict objectForKey:@"title"]) {
                            activityCompetition.title = [competitionDict objectForKey:@"title"];
                        }
                        if ([competitionDict objectForKey:@"price"]) {
                            activityCompetition.price = [[competitionDict objectForKey:@"price"]floatValue];
                        }
                        if ([competitionDict objectForKey:@"quota"]) {
                            activityCompetition.quota = [[competitionDict objectForKey:@"quota"] intValue];
                        }

                        [competitionArray addObject:activityCompetition];
                    }
                }
                competitionCategory.items = [[NSArray alloc] initWithArray:competitionArray];

                [competitionCategoryArray addObject:competitionCategory];
            }
            
            return competitionCategoryArray;
        }
        
        return nil;
    }];
    
    return result;

}


@end
