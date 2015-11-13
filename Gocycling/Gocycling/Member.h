//
//  Member.h
//  Gocycling
//
//  Created by LaiZhaowu on 14-6-10.
//
//

#import <Foundation/Foundation.h>
#import "WebAPI.h"
#import "Result.h"
#import "MemberContestant.h"

@interface Member : NSObject

@property (nonatomic, assign) int memberID;
@property (nonatomic, retain) NSString *loginUsername;
@property (nonatomic, retain) NSString *loginPassword;
@property (nonatomic, strong) NSString* realName;
@property (nonatomic, strong) NSString* nickname;
@property (nonatomic, assign) BOOL gender;
@property (nonatomic, strong) NSString* mobile;
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* birthdayString;
@property (nonatomic, strong) NSString* address;
@property (nonatomic, strong) NSString* credentialType;
@property (nonatomic, strong) NSString* credentialNumber;

+ (Member *)sharedMember;
+ (Result *)registerWithLoginUsername:(NSString*)loginUsername loginPassword:(NSString*)loginPassword;
+ (Result *)loginWithLoginUsername:(NSString*)loginUsername loginPassword:(NSString*)loginPassword;

// 是否已经登录
- (BOOL)hasLogined;

- (Result *)profile;


//更新会员资料
- (Result *)updateProfileWithName:(NSString*)name nickname:(NSString*)nickname gender:(int)gender mobile:(NSString*)mobile email:(NSString*)email credentialType:(NSString*)credentialType credentialNumber:(NSString*)credentialNumber brithday:(NSString*)brithday address:(NSString*)address;

//更改密码
- (Result *)updatePasswordWithOldpassword:(NSString*)oldpassword newPassword:(NSString*)newPassword;

//询问产品是否存在
- (Result*)isCollectProductExsited:(int)productID;

//会员收藏产品
- (Result*)collectProduct:(int)productID;

//会员收藏产品列表
- (Result*)collectProductListWithOffset:(NSInteger)offset limit:(NSInteger)limit;

//移除会员产品
- (Result*)removeCollectProduct:(NSNumber*)productID;

//询问品牌产品是否存在
- (Result*)isCollectProductBrandExsited:(int)brandProductID;

//会员收藏产品品牌
- (Result*)collectProductBrand:(int)productBrandID;

//会员收藏产品品牌列表
- (Result*)collectProductBrandListWithOffset:(NSInteger)offset limit:(NSInteger)limit;

//移除会员产品品牌
- (Result*)removeCollectProductBrand:(int)productBrandID;

// 会员产品评论
- (Result*)productCommentListWithOffset:(NSInteger)offset limit:(NSInteger)limit;

// 会员名单列表
- (Result*)contestantList;

//更新会员名单内容
- (Result*)updateMemberContestantWithMemberContestantID:(int)memberContestantID name:(NSString*)name gender:(int)gender mobile:(NSString*)mobile email:(NSString*)email birthday:(NSString*)birthday credentialType:(NSString*)credentialType credentialNumber:(NSString*)credentialNumber emergencyName:(NSString*)emergencyName emergencyContact:(NSString*)emergencyContact;

//删除会员名单
- (Result*)removeMemberContestant:(int)memberContestantID;

// 订单列表
- (Result*)orderListWithOffset:(int)offset limit:(int)limit;

// 取消订单
- (Result*)cancelOrder:(int)orderID;

// 查看订单
- (Result*)orderByOrderID:(int)orderID;

// 提交报名
- (Result*)createOrderWithActivityID:(int)activityID contestantJSONString:(NSString*)contestantJSONString;



@end
