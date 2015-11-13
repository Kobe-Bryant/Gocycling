//
//  Product.m
//  Gocycling
//
//  Created by LaiZhaowu on 14-6-10.
//
//

#import "Product.h"

@implementation Product

+ (Result*)requestSearchListWithIsRecommend:(NSNumber *)isRecommend productCategoryID:(NSNumber *)productCategoryID productBrandID:(NSNumber *)productBrandID searchKeyword:(NSString*)searchKeyword limit:(NSInteger)limit;
{
    NSMutableDictionary* currentDic = [[NSMutableDictionary alloc]init];
    [currentDic setObject:[isRecommend stringValue] forKey:@"isRecommend"];
    [currentDic setObject:[productCategoryID stringValue] forKey:@"productCategoryId"];
    [currentDic setObject:[productBrandID stringValue] forKey:@"productBrandId"];
    [currentDic setObject:searchKeyword forKey:@"searchKeyword"];
    [currentDic setObject:[[NSNumber numberWithInteger:limit] stringValue] forKey:@"limit"];
    
    WebAPI* webApi = [[WebAPI alloc]initWithMethod:@"getSearchProductList.html" params:currentDic];
    Result* result = [webApi postWithCache:^id(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject objectForKey:@"list"]) {
            NSDictionary* currentDic = [responseObject objectForKey:@"list"];
            NSMutableArray* productArray = [NSMutableArray array];
            for (NSDictionary* dic  in currentDic) {
                Product* product = [[Product alloc] init];
                if ([dic objectForKey:@"productId"]) {
                    product.productID = [[dic objectForKey:@"productId"] intValue];
                }
                if ([dic objectForKey:@"title"]) {
                    product.title = [dic objectForKey:@"title"];
                }
                if ([[UIScreen mainScreen] scale] == 2.0) {
                    product.imageURLString = [dic objectForKey:@"photo2x"];
                } else {
                    product.imageURLString = [dic objectForKey:@"photo"];
                }
                if ([dic objectForKey:@"price"]) {
                    product.productPrice = [[dic objectForKey:@"price"] floatValue];
                }
                
                [productArray addObject:product];
            }
            
            return productArray;
        }
        
        return nil;
    }];
    
    return result;
}

+ (Result*)requestListWithIsRecommend:(NSNumber *)isRecommend productCategoryID:(NSNumber *)productCategoryID productBrandID:(NSNumber *)productBrandID searchKeyword:(NSString *)searchKeyword offset:(NSInteger)offset limit:(NSInteger)limit
{
    NSMutableDictionary* currentDic = [[NSMutableDictionary alloc]init];
    [currentDic setObject:[isRecommend stringValue] forKey:@"isRecommend"];
    [currentDic setObject:[productCategoryID stringValue] forKey:@"productCategoryId"];
    [currentDic setObject:[productBrandID stringValue] forKey:@"productBrandId"];
    [currentDic setObject:searchKeyword forKey:@"searchKeyword"];
    [currentDic setObject:[[NSNumber numberWithInteger:offset] stringValue] forKey:@"offset"];
    [currentDic setObject:[[NSNumber numberWithInteger:limit] stringValue] forKey:@"limit"];
    
    WebAPI* webApi = [[WebAPI alloc]initWithMethod:@"getProductList.html" params:currentDic];
    Result* result = [webApi postWithCache:^id(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject objectForKey:@"list"]) {
            NSDictionary* currentDic = [responseObject objectForKey:@"list"];
            NSMutableArray* productArray = [NSMutableArray array];
            for (NSDictionary* dic  in currentDic) {
                Product* product = [[Product alloc] init];
                if ([dic objectForKey:@"productId"]) {
                    product.productID = [[dic objectForKey:@"productId"] intValue];
                }
                if ([dic objectForKey:@"title"]) {
                    product.title = [dic objectForKey:@"title"];
                }
                if ([[UIScreen mainScreen] scale] == 2.0) {
                    product.imageURLString = [dic objectForKey:@"photo2x"];
                } else {
                    product.imageURLString = [dic objectForKey:@"photo"];
                }
                if ([dic objectForKey:@"price"]) {
                    product.productPrice = [[dic objectForKey:@"price"] floatValue];
                }
                
                [productArray addObject:product];
            }
            
            return productArray;
        }
        
        return nil;
    }];
    
    return result;
}

+ (Result*)requestByProductID:(NSNumber *)productID
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setObject:[productID stringValue] forKey:@"productId"];
    
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"getProductDetail.html" params:dic];
    Result* result = [webAPI postWithCache:^id(id responseObject) {
        if ([responseObject objectForKey:@"info"]) {
            NSDictionary* currentDic =[responseObject objectForKey:@"info"];
            Product* product = [[Product alloc] init];
            if ([currentDic objectForKey:@"productId"]) {
                product.productID = [[currentDic objectForKey:@"productId"] intValue];
            }
            if ([currentDic objectForKey:@"brandName"]) {
                product.brandName = [currentDic objectForKey:@"brandName"];
            }
            if ([currentDic objectForKey:@"commentCount"]) {
                product.commentCount = [[currentDic objectForKey:@"commentCount"] intValue];
            }
            if ([currentDic objectForKey:@"price"]) {
                product.productPrice = [[currentDic objectForKey:@"price"] floatValue];
            }
            if ([currentDic objectForKey:@"intro"]) {
                product.intro = [currentDic objectForKey:@"intro"];
            }
            if ([currentDic objectForKey:@"star"]) {
                product.ratingFloat = [[currentDic objectForKey:@"star"] floatValue];
            }
            if ([currentDic objectForKey:@"title"]) {
                product.title = [currentDic objectForKey:@"title"];
            }
            if ([[UIScreen mainScreen] scale] == 2.0) {
                product.imageURLString = [currentDic objectForKey:@"photo2x"];
            } else {
                product.imageURLString = [currentDic objectForKey:@"photo"];
            }
            if ([currentDic objectForKey:@"spec"]) {
                product.sybase = [currentDic objectForKey:@"spec"];
            }
            product.productImageArray = [NSMutableArray array];
            if ([currentDic objectForKey:@"photoList"]) {
                NSDictionary* subDic = [currentDic objectForKey:@"photoList"];
                for (NSDictionary* smallDic in subDic) {
                    ProductImage* productImage = [[ProductImage alloc] init];
                    if ([smallDic objectForKey:@"productImageId"]) {
                        productImage.productImageID =[[smallDic objectForKey:@"productImageId"] intValue];
                    }
                    if ([smallDic objectForKey:@"title"]) {
                        productImage.title = [smallDic objectForKey:@"title"];
                    }
                    if ([[UIScreen mainScreen] scale] == 2.0) {
                        productImage.imageURLString = [smallDic objectForKey:@"photo2x"];
                    } else {
                        productImage.imageURLString = [smallDic objectForKey:@"photo"];
                    }
                    
                    [product.productImageArray addObject:productImage];
                }
            }
            
            return product;
        }
        
        return nil;
    }];
    
    return result;
}

+ (Result*)requestCommentListWithOffset:(NSInteger)offset limit:(NSInteger)limit productID:(NSNumber *)productID
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setObject:[productID stringValue] forKey:@"productId"];
    [dic setObject:[[NSNumber numberWithInt:offset]stringValue] forKey:@"offset"];
    [dic setObject:[[NSNumber numberWithInt:limit]stringValue] forKey:@"limit"];
    
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"getProductCommentList.html" params:dic];
    Result* result = [webAPI postWithCache:^id(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject objectForKey:@"list"]) {
            NSDictionary* currentDic = [responseObject objectForKey:@"list"];
            NSMutableArray* productCommentArray = [NSMutableArray array];
            for (NSDictionary* dic in currentDic) {
                ProductComment* productComment = [[ProductComment alloc] init];
                if ([dic objectForKey:@"productCommentId"]) {
                    productComment.productCommentID = [[dic objectForKey:@"productCommentId"] intValue];
                }
                if ([dic objectForKey:@"date"]) {
                    productComment.dateString = [dic objectForKey:@"date"];
                }
                if ([dic objectForKey:@"memberName"]) {
                    productComment.memberName = [dic objectForKey:@"memberName"];
                }
                if ([dic objectForKey:@"message"]) {
                    productComment.message = [dic objectForKey:@"message"];
                }
                if ([dic objectForKey:@"star"]) {
                    productComment.ratingFloat = [[dic objectForKey:@"star"] floatValue];
                }
                
                [productCommentArray addObject:productComment];
            }
            
            NSLog(@"%d", productCommentArray.count);
            return productCommentArray;
        }
        
        return nil;
    }];
    
    return result;
}

@end
