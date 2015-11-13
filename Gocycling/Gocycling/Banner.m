//
//  Banner.m
//  Gocycling
//
//  Created by LaiZhaowu on 14-6-10.
//
//

#import "Banner.h"

@implementation Banner

+ (Result*)requestList
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"getBannerList.html" params:params];
    Result* result = [webAPI postWithCache:^id(id responseObject) {
        if ([responseObject objectForKey:@"list"]) {
            NSDictionary* listDict = [responseObject objectForKey:@"list"];
            NSMutableArray* bannerArray = [NSMutableArray array];
            for (NSDictionary* infoDict in listDict) {
                Banner *banner = [[Banner alloc] init];
                if ([infoDict objectForKey:@"bannerId"]) {
                    banner.bannerID = [[infoDict objectForKey:@"bannerId"] integerValue];
                }
                if ([infoDict objectForKey:@"title"]) {
                    banner.title = [infoDict objectForKey:@"title"];
                }
                if ([[UIScreen mainScreen] scale] == 2.0) {
                    banner.imageURLString = [infoDict objectForKey:@"photo2x"];
                } else {
                    banner.imageURLString = [infoDict objectForKey:@"photo"];
                }
                [bannerArray addObject:banner];
            }
            return bannerArray;
        }
        return nil;
    } errorBlock:^NSError *(NSError *error) {
        return error;
    }];
    
    return result;
    
}

@end
