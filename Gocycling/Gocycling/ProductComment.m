//
//  ProductComment.m
//  Gocycling
//
//  Created by LaiZhaowu on 14-6-10.
//
//

#import "ProductComment.h"
#import "WebAPI.h"
#import "Result.h"

@implementation ProductComment

+ (Result*)requestListWithOffset:(NSInteger)offset limit:(NSInteger)limit productID:(NSNumber*)productID
{
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    
    
    [dic setObject:[productID stringValue] forKey:@"productId"];
    
    [dic setObject:[[NSNumber numberWithInt:offset]stringValue] forKey:@"offset"];
    
    [dic setObject:[[NSNumber numberWithInt:limit]stringValue] forKey:@"limit"];
    
    
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"getProductCommentList.html" params:dic];
    
    
    Result* result = [webAPI postWithCache:^id(id responseObject)
                      {
                          
                          
                          NSLog(@"%@",responseObject);
                          
                          if ([responseObject objectForKey:@"list"])
                          {
                              
                              
                              NSDictionary* currentDic = [responseObject objectForKey:@"list"];
                              NSMutableArray* productEvaluateArray = [NSMutableArray array];
                              
                              for (NSDictionary* dic in currentDic)
                                  
                              {
                                  ProductComment* productEvaluate = [[ProductComment alloc] init];
                                  
                                  
                                  if ([dic objectForKey:@"date"])
                                  {
                                      
                                      productEvaluate.dateString = [dic objectForKey:@"date"];
                                  }
                                  
                                  if ([dic objectForKey:@"memberName"])
                                  {
                                      productEvaluate.memberName = [dic objectForKey:@"memberName"];
                                      
                                      
                                  }
                                  
                                  if ([dic objectForKey:@"message"])
                                  {
                                      productEvaluate.message = [dic objectForKey:@"message"];
                                      
                                      
                                  }
                                  
                                  if ([dic objectForKey:@"productCommentId"]) {
                                      
                                      productEvaluate.productCommentID = [[dic objectForKey:@"productCommentId"] intValue];
                                      
                                  }
                                  
                                  if ([dic objectForKey:@"star"])
                                      
                                  {
                                      productEvaluate.ratingFloat = [[dic objectForKey:@"star"] floatValue];
                                      
                                      
                                  }
                                  
                                  
                                  [productEvaluateArray addObject:productEvaluate];
                                  
                                  
                              }
                              
                              NSLog(@"%d",productEvaluateArray.count);
                              
                              
                              
                              return productEvaluateArray;
                              
                          }
                          
                          
                          return nil;
                          
                          
                      }];
    
    
    return result;
}

@end
