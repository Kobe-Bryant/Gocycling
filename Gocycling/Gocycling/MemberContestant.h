//
//  MemberContestant.h
//  Gocycling
//
//  Created by LaiZhaowu on 14-6-10.
//
//

#import <Foundation/Foundation.h>
#import "WebAPI.h"
#import "Result.h"

@interface MemberContestant : NSObject<NSCoding>

@property (nonatomic, assign) int memberContestantID;
@property (nonatomic, strong) NSString* birthday;
@property (nonatomic, strong) NSString* credentialNumber;
@property (nonatomic, strong) NSString* credentialType;
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* emergencyContact;
@property (nonatomic, strong) NSString* emergencyName;
@property (nonatomic, strong) NSString* mobile;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, assign) int gender;


@end
