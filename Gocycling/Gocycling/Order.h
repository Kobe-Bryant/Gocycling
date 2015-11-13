//
//  Order.h
//  Gocycling
//
//  Created by LaiZhaowu on 14-6-10.
//
//

#import <Foundation/Foundation.h>
#import "Result.h"
#import "WebAPI.h"

@interface Order : NSObject

@property (nonatomic, assign) int orderID;
@property (nonatomic, strong) NSString* orderSn;
@property (nonatomic, strong) NSString* matchTitleString;
@property (nonatomic, strong) NSString* orderNumber;
@property (nonatomic, strong) NSString* status;
@property (nonatomic, assign) float matchPrice;
@property (nonatomic, strong) NSString* singupTime;
@property (nonatomic, assign) int competitionQuantity;
@property (nonatomic, strong) NSString* activityTitle;
@property (nonatomic, assign) float headPrice;
@property (nonatomic, strong) NSString* categoryTitle;
@property (nonatomic, assign) float singlematchPrice;
@property (nonatomic, strong) NSString* subTitle;
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* mobile;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, assign) float subtotalPrice;
@property (nonatomic, strong) NSMutableArray* competionArray;
@property (nonatomic, assign) float totalPrice;

+ (Result*)validateContestantWithActivityID:(NSNumber *)activityID competitionID:(NSNumber *)competitionID name:(NSString*)name gender:(int)gender mobile:(NSString*)mobile email:(NSString*)email birthday:(NSString*)birthday credentialType:(NSString*)credentialType credentialNumber:(NSString*)credentialNumber emergencyName:(NSString*)emergencyName emergencyContact:(NSString*)emergencyContact;


@end
