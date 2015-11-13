//
//  Brand.m
//  Gocycling
//
//  Created by LaiZhaowu on 14-6-10.
//
//

#import "Brand.h"

@implementation Brand

+ (Result*)requestListWithIsRecommend:(BOOL)isRecommend productCategoryID:(NSNumber *)productCategoryID
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:[[NSNumber numberWithBool:isRecommend] stringValue] forKey:@"isRecommend"];
    [params setObject:[productCategoryID stringValue] forKey:@"productCategoryID"];
    
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"getProductBrandList.html" params:params];
    Result* result = [webAPI postWithCache:^id(id responseObject) {
        NSLog(@"responseObject %@", responseObject);
        if ([responseObject objectForKey:@"list"]) {
            NSDictionary* listDict = [responseObject objectForKey:@"list"];
            NSMutableArray* brandArray = [[NSMutableArray alloc] init];
            for (NSDictionary* infoDict in listDict) {
                Brand* brand = [[Brand alloc] init];
                if ([infoDict objectForKey:@"productBrandId"]) {
                    brand.brandID = [[infoDict objectForKey:@"productBrandId"] integerValue];
                }
                if ([infoDict objectForKey:@"title"]) {
                    brand.title = [infoDict objectForKey:@"title"];
                }
                if ([infoDict objectForKey:@"productCount"]) {
                    brand.productCount = [[infoDict objectForKey:@"productCount"] intValue];
                }
                if ([[UIScreen mainScreen] scale] == 2.0) {
                    brand.imageURLString = [infoDict objectForKey:@"photo2x"];
                } else {
                    brand.imageURLString = [infoDict objectForKey:@"photo"];
                }
                
                [brandArray addObject:brand];
            }
            
            return brandArray;
        }
        
        return nil;
    }];
    
    return result;
}

+ (Result *)requestByBrandID:(int)brandID
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setObject:[[NSString alloc] initWithFormat:@"%i", brandID] forKey:@"productBrandId"];
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"getProductBrandDetail.html" params:dict];
    Result* result = [webAPI postWithCache:^id(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject objectForKey:@"info"]) {
            NSDictionary* infoDict = [responseObject objectForKey:@"info"];
            Brand* brand = [[Brand alloc] init];
            if ([infoDict objectForKey:@"productBrandId"]) {
                brand.brandID = [[infoDict objectForKey:@"productBrandId"] intValue];
            }
            if ([infoDict objectForKey:@"title"]) {
                brand.title = [infoDict objectForKey:@"title"];
            }
            if ([infoDict objectForKey:@"summary"]) {
                brand.summary = [infoDict objectForKey:@"summary"];
            }
            if ([[UIScreen mainScreen] scale] == 2.0) {
                brand.imageURLString = [infoDict objectForKey:@"photo2x"];
            } else {
                brand.imageURLString = [infoDict objectForKey:@"photo"];
            }
            if ([infoDict objectForKey:@"productCount"]) {
                brand.productCount = [[infoDict objectForKey:@"productCount"] intValue];
            }
            
            return brand;
        }
        
        return nil;
    }];
    
    return result;
}

@end
