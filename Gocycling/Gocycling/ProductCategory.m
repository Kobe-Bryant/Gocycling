//
//  ProductCategory.m
//  Gocycling
//
//  Created by LaiZhaowu on 14-6-10.
//
//

#import "ProductCategory.h"

@implementation ProductCategory

- (id)init
{
    self = [super init];
    if (self) {
        self.items = [NSMutableArray array];
    }

    return self;
}

+ (Result *)requestListWithIsRecommend:(BOOL)isRecommend productBrandID:(NSNumber *)productBrandID;
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:[[NSNumber numberWithBool:isRecommend] stringValue] forKey:@"isRecommend"];
    [params setObject:[productBrandID stringValue] forKey:@"productBrandID"];
    
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"getProductCategoryList.html" params:params];
    Result* result = [webAPI postWithCache:^id(id responseObject) {
        NSLog(@"requestListWithIsRecommend responseObject %@", responseObject);
        if ([responseObject objectForKey:@"list"]) {
            NSMutableArray* productCategoryArray = [NSMutableArray array];
            NSDictionary* currentDic = [responseObject objectForKey:@"list"];
            for (NSDictionary* productDic in currentDic) {
                ProductCategory *productCategory = [[ProductCategory alloc] init];
                if ([productDic objectForKey:@"productCategoryId"]) {
                    productCategory.productCategoryID = [[productDic objectForKey:@"productCategoryId"] intValue];
                }
                if ([productDic objectForKey:@"title"]) {
                    productCategory.title = [productDic objectForKey:@"title"];
                }
                if ([[UIScreen mainScreen] scale] == 2) {
                    productCategory.normalImageURLString = [productDic objectForKey:@"photo2x"];
                    productCategory.selectedImageURLString = [productDic objectForKey:@"selectedPhoto2x"];
                } else {
                    productCategory.normalImageURLString = [productDic objectForKey:@"photo"];
                    productCategory.selectedImageURLString = [productDic objectForKey:@"selectedPhoto"];
                }
                
                NSDictionary* itemDic = [productDic objectForKey:@"items"];
                NSLog(@"subproductcategory itemDic = %@",itemDic);
                for (NSDictionary* dic in itemDic) {
                    ProductCategory* item = [[ProductCategory alloc] init];
                    if ([dic objectForKey:@"productCategoryId"]) {
                        item.productCategoryID = [[dic objectForKey:@"productCategoryId"] intValue];
                    }
                    if ([dic objectForKey:@"title"]) {
                        item.title = [dic objectForKey:@"title"];
                    }
                    if ([dic objectForKey:@"productCount"]) {
                        item.productCount = [[dic objectForKey:@"productCount"]intValue];
                    }
                    [productCategory.items addObject:item];
                }
                
                [productCategoryArray addObject:productCategory];
            }
            
            return productCategoryArray;
        }
        
        return nil;
    }];
    
    return result;
}

@end
