//
//  Order.m
//  Gocycling
//
//  Created by LaiZhaowu on 14-6-10.
//
//

#import "Order.h"

@implementation Order

+ (Result*)validateContestantWithActivityID:(NSNumber *)activityID competitionID:(NSNumber *)competitionID name:(NSString*)name gender:(int)gender mobile:(NSString*)mobile email:(NSString*)email birthday:(NSString*)birthday credentialType:(NSString*)credentialType credentialNumber:(NSString*)credentialNumber emergencyName:(NSString*)emergencyName emergencyContact:(NSString*)emergencyContact
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setObject:[activityID stringValue] forKey:@"activityId"];
    [dic setObject:[competitionID stringValue] forKey:@"competitionId"];
    [dic setObject:name forKey:@"name"];
    [dic setObject:[[NSNumber numberWithInt:gender] stringValue] forKey:@"gender"];
    [dic setObject:mobile forKey:@"mobile"];
    [dic setObject:email forKey:@"email"];
    [dic setObject:birthday forKey:@"birthday"];
    [dic setObject:credentialType forKey:@"credentialType"];
    [dic setObject:credentialNumber forKey:@"credentialNumber"];
    [dic setObject:emergencyName forKey:@"emergencyName"];
    [dic setObject:emergencyContact forKey:@"emergencyContact"];
    NSLog(@"dic %@", dic);
    
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"validateOrderContestantInfo.html" params:dic];
    Result* result = [webAPI postWithCache:^id(id responseObject) {
        NSLog(@"%@",responseObject);
        return nil;
    }];
    
    return result;
}

@end
