//
//  Member.m
//  Gocycling
//
//  Created by LaiZhaowu on 14-6-10.
//
//

#import "Member.h"
#import "CustomMarcos.h"
#import "Brand.h"
#import "Product.h"
#import "Order.h"
#import "OrderContestant.h"
#import "OrderCompetition.h"

@implementation Member

static Member *sharedMemberManager = nil;

+ (Member *)sharedMember
{
    if (sharedMemberManager == nil) {
        sharedMemberManager = [[super allocWithZone:NULL] init];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        sharedMemberManager.memberID = [[userDefaults objectForKey:MEMBER_ID] intValue];
        sharedMemberManager.loginUsername = [userDefaults objectForKey:LOGIN_USER_NAME];
        sharedMemberManager.loginPassword = [userDefaults objectForKey:LOGIN_PASSWORD];
        NSLog(@"sharedMemberManager.loginUsername %@", sharedMemberManager.loginUsername);
    }
    
    return sharedMemberManager;
}


+ (Result *)registerWithLoginUsername:(NSString*)loginUsername loginPassword:(NSString*)loginPassword
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:loginUsername forKey:@"username"];
    [params setObject:loginPassword forKey:@"password"];

    WebAPI* webAPI = [[WebAPI alloc] initWithMethod:@"memberRegister.html" params:params];
    Result* result = [webAPI post:^id(id responseObject) {
        return nil;
    }];
    
    return result;
}

+ (Result *)loginWithLoginUsername:(NSString*)loginUsername loginPassword:(NSString*)loginPassword
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:loginUsername forKey:@"username"];
    [params setObject:loginPassword forKey:@"password"];
    
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"memberLogin.html" params:params];
    Result* result = [webAPI post:^id(id responseObject) {
        
        NSLog(@"login responseObject %@", responseObject);

        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:loginUsername forKey:LOGIN_USER_NAME];
        [userDefaults setObject:loginPassword forKey:LOGIN_PASSWORD];
        [userDefaults synchronize];
        
        return nil;
    }];
    
    return result;
}

- (BOOL)hasLogined
{
    NSLog(@"self.loginUsername %@", self.loginUsername);
    NSLog(@"self.loginPassword %@", self.loginPassword);
    
    if (self.loginUsername.length > 0 && self.loginPassword.length > 0) {
        return YES;
    }
    
    return NO;
}

- (Result *)profile
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:self.loginUsername forKey:@"username"];
    [params setObject:self.loginPassword forKey:@"password"];
    
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"getMemberProfile.html" params:params];
    Result* result = [webAPI postWithCache:^id(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        if ([responseObject objectForKey:@"info"]) {
            
            NSDictionary* dic = [responseObject objectForKey:@"info"];
            
            
            Member* personInfomation = [[Member alloc] init];
            
            if ([dic objectForKey:@"address"]) {
                
                personInfomation.address = [dic objectForKey:@"address"];
                
            }
            if ([dic objectForKey:@"birthday"]) {
                
                personInfomation.birthdayString = [dic objectForKey:@"birthday"];
                
            }
            if ([dic objectForKey:@"credentialNumber"]) {
                
                personInfomation.credentialNumber = [dic objectForKey:@"credentialNumber"];
                
            }
            if ([dic objectForKey:@"credentialType"]) {
                
                personInfomation.credentialType = [dic objectForKey:@"credentialType"];
                
            }
            if ([dic objectForKey:@"email"]) {
                
                personInfomation.email= [dic objectForKey:@"email"];
                
            }
            if ([dic objectForKey:@"address"]) {
                
                personInfomation.gender = [[dic objectForKey:@"gender"] intValue];
                
            }
            if ([dic objectForKey:@"mobile"]) {
                
                personInfomation.mobile = [dic objectForKey:@"mobile"];
                
            }
            if ([dic objectForKey:@"name"]) {
                
                personInfomation.realName = [dic objectForKey:@"name"];
                
            }
            if ([dic objectForKey:@"nickname"]) {
                
                personInfomation.nickname = [dic objectForKey:@"nickname"];
                
            }
            
            return personInfomation;
            
            
        }
        
        
        
        
        return nil;
        
    }];
    
    return result;
    
}

- (Result *)updateProfileWithName:(NSString*)name nickname:(NSString*)nickname gender:(int)gender mobile:(NSString*)mobile email:(NSString*)email credentialType:(NSString*)credentialType credentialNumber:(NSString*)credentialNumber brithday:(NSString*)brithday address:(NSString*)address
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setObject:self.loginUsername forKey:@"username"];
    [dic setObject:self.loginPassword forKey:@"password"];
    [dic setObject:name forKey:@"name"];
    [dic setObject:nickname forKey:@"nickname"];
    [dic setObject:[[NSNumber numberWithInt:gender] stringValue] forKey:@"gender"];
    [dic setObject:mobile forKey:@"mobile"];
    [dic setObject:email forKey:@"email"];
    [dic setObject:credentialType forKey:@"credentialType"];
    [dic setObject:credentialNumber forKey:@"credentialNumber"];
    [dic setObject:brithday forKey:@"birthday"];
    [dic setObject:address forKey:@"address"];
    
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"updateMemberProfile.html" params:dic];
    Result* result = [webAPI post:^id(id responseObject) {
        NSLog(@"%@", responseObject);
        return nil;
    }];
    
    return result;
}

- (Result *)updatePasswordWithOldpassword:(NSString*)oldpassword newPassword:(NSString*)newPassword;
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:self.loginUsername forKey:@"username"];
    [params setObject:oldpassword forKey:@"oldPassword"];
    [params setObject:newPassword forKey:@"newPassword"];
    
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"updateMemberPassword.html" params:params];
    Result* result = [webAPI post:^id(id responseObject) {
        NSLog(@"%@", responseObject);
        return nil;
    }];
    
    return result;
}

- (Result*)isCollectProductExsited:(int)productID;
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:self.loginUsername forKey:@"username"];
    [params setObject:self.loginPassword forKey:@"password"];
    [params setObject:[[NSNumber numberWithInt:productID] stringValue] forKey:@"productId"];
    
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"getIsCollectProductExsited.html" params:params];
    Result* result = [webAPI post:^id(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject objectForKey:@"isExsited"]) {
            NSNumber *isExsited = [responseObject objectForKey:@"isExsited"];
            return isExsited;
        }
        
        return self;
    }];
    
    return result;
}

- (Result*)collectProduct:(int)productID;
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:self.loginUsername forKey:@"username"];
    [params setObject:self.loginPassword forKey:@"password"];
    [params setObject:[[NSNumber numberWithInt:productID]stringValue] forKey:@"productId"];
    
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"collectProduct.html" params:params];
    Result* result = [webAPI post:^id(id responseObject) {
        NSLog(@"%@",responseObject);
        return nil;
    }];
    
    return result;
}

- (Result*)collectProductListWithOffset:(NSInteger)offset limit:(NSInteger)limit;
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:self.loginUsername forKey:@"username"];
    [params setObject:self.loginPassword forKey:@"password"];
    [params setObject:[[NSNumber numberWithInt:offset] stringValue] forKey:@"offset"];
    [params setObject:[[NSNumber numberWithInt:limit] stringValue] forKey:@"limit"];
    
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"getMemberCollectProductList.html" params:params];
    Result* result = [webAPI postWithCache:^id(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject objectForKey:@"list"]) {
            NSDictionary* currentDic = [responseObject objectForKey:@"list"];
            NSMutableArray* productArray = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary* dic in currentDic) {
                Product* product = [[Product alloc] init];
                if ([dic objectForKey:@"price"]) {
                    product.productPrice = [[dic objectForKey:@"price"] floatValue];
                }
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
                
                [productArray addObject:product];
            }
            
            return productArray;
        }
        
        return nil;
    }];
    
    return result;

}

- (Result*)removeCollectProduct:(NSNumber*)productID;
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:self.loginUsername forKey:@"username"];
    [params setObject:self.loginPassword forKey:@"password"];
    [params setObject:[productID stringValue] forKey:@"productId"];
    
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"removeCollectProduct.html" params:params];
    Result* result = [webAPI post:^id(id responseObject) {
        NSLog(@"%@",responseObject);
        return nil;
    }];
    
    return result;
}

- (Result*)isCollectProductBrandExsited:(int)brandProductID;
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:self.loginUsername forKey:@"username"];
    [params setObject:self.loginPassword forKey:@"password"];
    [params setObject:[[NSNumber numberWithInt:brandProductID] stringValue] forKey:@"productBrandId"];
    
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"getIsCollectProductBrandExsited.html" params:params];
    Result* result = [webAPI post:^id(id responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject objectForKey:@"isExsited"]) {
            NSNumber *isExsited = [responseObject objectForKey:@"isExsited"];
            return isExsited;
        }

        return self;
    }];
    
    return result;
}

- (Result*)collectProductBrand:(int)productBrandID;
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:self.loginUsername forKey:@"username"];
    [params setObject:self.loginPassword forKey:@"password"];
    [params setObject:[[NSNumber numberWithInt:productBrandID] stringValue] forKey:@"productBrandId"];
    
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"collectProductBrand.html" params:params];
    Result* result = [webAPI post:^id(id responseObject) {
        NSLog(@"%@",responseObject);
        return nil;
    }];
    
    return result;
}

- (Result*)collectProductBrandListWithOffset:(NSInteger)offset limit:(NSInteger)limit;
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:self.loginUsername forKey:@"username"];
    [params setObject:self.loginPassword forKey:@"password"];
    [params setObject:[[NSNumber numberWithInteger:offset] stringValue] forKey:@"offset"];
    [params setObject:[[NSNumber numberWithInteger:limit] stringValue] forKey:@"limit"];

    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"getMemberCollectProductBrandList.html" params:params];
    Result* result = [webAPI postWithCache:^id(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject objectForKey:@"list"]) {
            NSDictionary* currentDic = [responseObject objectForKey:@"list"];
            NSMutableArray* brandArray = [[NSMutableArray alloc] init];
            for (NSDictionary* dic in currentDic) {
                Brand* brand = [[Brand alloc] init];
                if ([dic objectForKey:@"productBrandId"]) {
                    brand.brandID = [[dic objectForKey:@"productBrandId"] intValue];
                }
                if ([dic objectForKey:@"title"]) {
                    brand.title = [dic objectForKey:@"title"];
                }
                if ([[UIScreen mainScreen] scale] == 2.0) {
                    brand.imageURLString = [dic objectForKey:@"photo2x"];
                } else {
                    brand.imageURLString = [dic objectForKey:@"photo"];
                }
                
                [brandArray addObject:brand];
            }
            
            return brandArray;
        }

        return nil;
    }];
    
    return result;
}

- (Result*)removeCollectProductBrand:(int)productBrandID;
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:self.loginUsername forKey:@"username"];
    [params setObject:self.loginPassword forKey:@"password"];
    [params setObject:[[NSNumber numberWithInt: productBrandID] stringValue] forKey:@"productBrandId"];
    
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"removeCollectProductBrand.html" params:params];
    Result* result = [webAPI post:^id(id responseObject) {
        NSLog(@"%@", responseObject);
        return nil;
    }];
    
    return result;
}

- (Result*)productCommentListWithOffset:(NSInteger)offset limit:(NSInteger)limit
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:self.loginUsername forKey:@"username"];
    [params setObject:self.loginPassword forKey:@"password"];
    [params setObject:[[NSNumber numberWithInt:offset] stringValue] forKey:@"offset"];
    [params setObject:[[NSNumber numberWithInt:limit] stringValue] forKey:@"limit"];
    
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"getMemberProductCommentList.html" params:params];
    Result* result = [webAPI postWithCache:^id(id responseObject)  {
        NSLog(@"%@",responseObject);
        if ([responseObject objectForKey:@"list"]) {
            
            NSDictionary* currentDic = [responseObject objectForKey:@"list"];
            NSMutableArray* array = [NSMutableArray array];
            
            for (NSDictionary* dic in currentDic)
            {
                
                ProductComment* commentList = [[ProductComment alloc]init];
                
                
                if ([dic objectForKey:@"date"]) {
                    
                    commentList.dateString = [dic objectForKey:@"date"];
                    
                    
                }
                if ([dic objectForKey:@"message"]) {
                    
                    commentList.message = [dic objectForKey:@"message"];
                    
                    
                }
                if ([dic objectForKey:@"productCommentId"]) {
                    
                    commentList.productCommentID = [[dic objectForKey:@"productCommentId"] intValue];
                    
                    
                }
                if ([dic objectForKey:@"productId"]) {
                    
                    commentList.productID = [[dic objectForKey:@"productId"] intValue];
                    
                    
                }
                if ([dic objectForKey:@"productTitle"]) {
                    
                    commentList.productName = [dic objectForKey:@"productTitle"];
                    
                    
                    
                }
                if ([dic objectForKey:@"star"]) {
                    
                    commentList.ratingFloat = [[dic objectForKey:@"star"] floatValue];
                    
                    
                }
                
                
                [array addObject:commentList];
                
                
                
            }
            
            
            return array;
            
            
        }
        
        
        return nil;
        
    }];
    
    return result;
}

- (Result*)contestantList
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:self.loginUsername forKey:@"username"];
    [params setObject:self.loginPassword forKey:@"password"];
    
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"getMemberContestantList.html" params:params];
    Result* result = [webAPI postWithCache:^id(id responseObject) {
        if ([responseObject objectForKey:@"list"]) {
            NSDictionary* currentDic = [responseObject objectForKey:@"list"];
            NSMutableArray* memberContestantArray = [[NSMutableArray alloc] init];
            for (NSDictionary* dic in currentDic) {
                MemberContestant* memberContestant = [[MemberContestant alloc] init];
                if ([dic objectForKey:@"memberContestantId"]) {
                    memberContestant.memberContestantID = [[dic objectForKey:@"memberContestantId"] intValue];
                }
                if ([dic objectForKey:@"birthday"]) {
                    memberContestant.birthday = [dic objectForKey:@"birthday"];
                }
                if ([dic objectForKey:@"credentialNumber"]) {
                    memberContestant.credentialNumber = [dic objectForKey:@"credentialNumber"];
                }
                if ([dic objectForKey:@"credentialType"]) {
                    memberContestant.credentialType = [dic objectForKey:@"credentialType"];
                }
                if ([dic objectForKey:@"email"]) {
                    memberContestant.email = [dic objectForKey:@"email"];
                }
                if ([dic objectForKey:@"emergencyContact"]) {
                    memberContestant.emergencyContact = [dic objectForKey:@"emergencyContact"];
                }
                if ([dic objectForKey:@"emergencyName"]) {
                    memberContestant.emergencyName = [dic objectForKey:@"emergencyName"];
                }
                if ([dic objectForKey:@"gender"]) {
                    memberContestant.gender = [[dic objectForKey:@"gender"] intValue];
                }
                if ([dic objectForKey:@"mobile"]) {
                    memberContestant.mobile = [dic objectForKey:@"mobile"];
                }
                if ([dic objectForKey:@"name"]) {
                    memberContestant.name = [dic objectForKey:@"name"];
                }
                [memberContestantArray addObject:memberContestant];
            }
            
            return memberContestantArray;
        }
        
        return nil;
    }];
    
    return result;
}

- (Result*)updateMemberContestantWithMemberContestantID:(int)memberContestantID name:(NSString*)name gender:(int)gender mobile:(NSString*)mobile email:(NSString*)email birthday:(NSString*)birthday credentialType:(NSString*)credentialType credentialNumber:(NSString*)credentialNumber emergencyName:(NSString*)emergencyName emergencyContact:(NSString*)emergencyContact;
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:self.loginUsername forKey:@"username"];
    [params setObject:self.loginPassword forKey:@"password"];
    [params setObject:[[NSNumber numberWithInt:memberContestantID] stringValue] forKey:@"memberContestantId"];
    [params setObject:name forKey:@"name"];
    [params setObject:[[NSNumber numberWithInt:gender] stringValue] forKey:@"gender"];
    [params setObject:mobile forKey:@"mobile"];
    [params setObject:email forKey:@"email"];
    [params setObject:birthday forKey:@"birthday"];
    [params setObject:credentialType forKey:@"credentialType"];
    [params setObject:credentialNumber forKey:@"credentialNumber"];
    [params setObject:emergencyName forKey:@"emergencyName"];
    [params setObject:emergencyContact forKey:@"emergencyContact"];
    NSLog(@"%@", params);
    
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"updateMemberContestant.html" params:params];
    Result* result = [webAPI post:^id(id responseObject) {
        NSLog(@"%@", responseObject);
        return nil;
    }];
    
    return result;
}

//删除会员名单
- (Result*)removeMemberContestant:(int)memberContestantID;
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:self.loginUsername forKey:@"username"];
    [params setObject:self.loginPassword forKey:@"password"];
    [params setObject:[[NSNumber numberWithInt:memberContestantID] stringValue] forKey:@"memberContestantId"];
    
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"removeMemberContestant.html" params:params];
    Result* result = [webAPI post:^id(id responseObject) {
        NSLog(@"%@",responseObject);
        return nil;
    }];
    
    return result;
}

- (Result*)orderListWithOffset:(int)offset limit:(int)limit;
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:self.loginUsername forKey:@"username"];
    [params setObject:self.loginPassword forKey:@"password"];
    [params setObject:[[NSNumber numberWithInt:offset] stringValue] forKey:@"offset"];
    [params setObject:[[NSNumber numberWithInt:limit] stringValue] forKey:@"limit"];
    WebAPI* webApI = [[WebAPI alloc]initWithMethod:@"getOrderList.html" params:params];
    
    Result* result = [webApI postWithCache:^id(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject objectForKey:@"list"]) {
            NSDictionary* currentDic = [responseObject objectForKey:@"list"];
            NSMutableArray* array = [NSMutableArray array];
            for (NSDictionary* dic in currentDic) {
                Order* list = [[Order alloc] init];
                if ([dic objectForKey:@"orderId"]) {
                    list.orderID = [[dic objectForKey:@"orderId"] intValue];
                }
                if ([dic objectForKey:@"activityTitle"]) {
                    list.matchTitleString = [dic objectForKey:@"activityTitle"];
                }
                if ([dic objectForKey:@"competitionQuantity"]) {
                    list.competitionQuantity = [[dic objectForKey:@"competitionQuantity"] intValue];
                }
                if ([dic objectForKey:@"orderSn"]) {
                    list.orderNumber = [dic objectForKey:@"orderSn"];
                }
                if ([dic objectForKey:@"price"]) {
                    list.matchPrice = [[dic objectForKey:@"price"] floatValue];
                }
                if ([dic objectForKey:@"signUpTime"]) {
                    list.singupTime = [dic objectForKey:@"signUpTime"];
                }
                if ([dic objectForKey:@"status"]) {
                    list.status = [dic objectForKey:@"status"];
                }
                [array addObject:list];
            }
            
            return array;
        }
        
        return nil;
    }];
    
    return result;
}

// 取消订单
- (Result*)cancelOrder:(int)orderID;
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:self.loginUsername forKey:@"username"];
    [params setObject:self.loginPassword forKey:@"password"];
    [params setObject:[[NSNumber numberWithInt:orderID] stringValue] forKey:@"orderId"];
    
    WebAPI* webApI = [[WebAPI alloc]initWithMethod:@"cancelOrder.html" params:params];
    Result* result = [webApI post:^id(id responseObject) {
        NSLog(@"%@", responseObject);
        return nil;
    }];
    
    return result;
}

- (Result*)orderByOrderID:(int)orderID;
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:self.loginUsername forKey:@"username"];
    [params setObject:self.loginPassword forKey:@"password"];
    [params setObject:[[NSNumber numberWithInt:orderID] stringValue] forKey:@"orderId"];
    
    WebAPI* webApI = [[WebAPI alloc]initWithMethod:@"getOrderDetail.html" params:params];
    Result* result = [webApI postWithCache:^id(id responseObject) {
        if ([responseObject objectForKey:@"info"]) {
            NSDictionary* currentDic = [responseObject objectForKey:@"info"];
            Order* order = [[Order alloc] init];
            if ([currentDic objectForKey:@"activityTitle"]) {
                order.activityTitle = [currentDic objectForKey:@"activityTitle"];
            }
            if ([currentDic objectForKey:@"competitionQuantity"]) {
                order.competitionQuantity = [[currentDic objectForKey:@"competitionQuantity"] intValue];
            }
            if ([currentDic objectForKey:@"orderId"]) {
                order.orderID = [[currentDic objectForKey:@"orderId"] intValue];
            }
            if ([currentDic objectForKey:@"orderSn"]) {
                order.orderNumber = [currentDic objectForKey:@"orderSn"];
            }
            if ([currentDic objectForKey:@"price"]) {
                order.headPrice = [[currentDic objectForKey:@"price"] floatValue];
            }
            if ([currentDic objectForKey:@"signUpTime"]) {
                order.singupTime = [currentDic objectForKey:@"signUpTime"];
            }
            if ([currentDic objectForKey:@"status"]) {
                order.status = [currentDic objectForKey:@"status"];
            }
            if ([currentDic objectForKey:@"contestantList"]) {
//                NSDictionary* dic = [currentDic objectForKey:@"contestantList"];
//                order.competionArray = [NSMutableArray array];
//                for (NSDictionary* subDic in dic) {
//                    if ([subDic objectForKey:@"competitionList"]) {
//                        NSArray* array = [subDic objectForKey:@"competitionList"];
//                        for (NSDictionary* dic in array) {
//                            if ([dic objectForKey:@"categoryTitle"]) {
//                                orderCompetition.categoryTitle = [dic objectForKey:@"categoryTitle"];
//                            }
//                            if ([dic objectForKey:@"price"]) {
//                                orderCompetition.singlematchPrice = [[dic objectForKey:@"price"] floatValue];
//                            }
//                            if ([dic objectForKey:@"title"]) {
//                                orderCompetition.subTitle = [dic objectForKey:@"title"];
//                            }
//                        }
//                        if ([subDic objectForKey:@"email"])
//                        {
//                            detail.email = [subDic objectForKey:@"email"];
//                            
//                            
//                        }
//                        if ([subDic objectForKey:@"mobile"])
//                        {
//                            
//                            detail.mobile = [subDic objectForKey:@"mobile"];
//                            
//                            
//                            
//                        }
//                        if ([subDic objectForKey:@"name"])
//                        {
//                            
//                            detail.name = [subDic objectForKey:@"name"];
//                            
//                            
//                            
//                        }
//                        if ([subDic objectForKey:@"subtotalPrice"])
//                        {
//                            
//                            detail.subtotalPrice = [[subDic objectForKey:@"subtotalPrice"] floatValue];
//                            
//                            
//                            
//                        }
//                        
//                        [orderDetail.competionArray addObject:detail];
//                        
//                        
//                    }
//                    
//                    
//                    
//                }
                
                
            }
            return order;
        }
        
        return nil;
    }];
    
    return result;
}

- (Result*)createOrderWithActivityID:(int)activityID contestantJSONString:(NSString*)contestantJSONString
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:self.loginUsername forKey:@"username"];
    [params setObject:self.loginPassword forKey:@"password"];
    [params setObject:[[NSNumber numberWithInt:activityID] stringValue] forKey:@"activityId"];
    [params setObject:contestantJSONString forKey:@"contestantJsonString"];
    
    
    
    
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"createOrder.html" params:params];
    
    
    Result* result = [webAPI postWithCache:^id(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        if ([responseObject objectForKey:@"info"]) {
            
            NSDictionary* currentDic =[responseObject objectForKey:@"info"];
            
            Order* submitList = [[Order alloc]init];
            
            
            if ([currentDic objectForKey:@"orderId"]) {
                
                submitList.orderID = [[currentDic objectForKey:@"orderId"]intValue];
                
                
            }
            if ([currentDic objectForKey:@"orderSn"]) {
                
                submitList.orderSn = [currentDic objectForKey:@"orderSn"];
                
                
            }
            if ([currentDic objectForKey:@"price"]) {
                
                submitList.totalPrice = [[currentDic objectForKey:@"price"]floatValue];
                
                
            }
            
            return submitList;
            
            
        }
        
        
        return nil;
        
    }];
    
    return result;

}

@end
