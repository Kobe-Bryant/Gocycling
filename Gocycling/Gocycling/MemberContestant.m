//
//  MemberContestant.m
//  Gocycling
//
//  Created by LaiZhaowu on 14-6-10.
//
//

#import "MemberContestant.h"

@implementation MemberContestant

#pragma mark - NSCoding
- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.memberContestantID = [[decoder decodeObjectForKey:@"memberContestantID"] intValue];
        self.birthday = [decoder decodeObjectForKey:@"contents"];
        self.credentialNumber = [decoder decodeObjectForKey:@"credentialNumber"];
        self.credentialType = [decoder decodeObjectForKey:@"credentialType"];
        self.email = [decoder decodeObjectForKey:@"email"];
        self.emergencyContact = [decoder decodeObjectForKey:@"emergencyContact"];
        self.emergencyName = [decoder decodeObjectForKey:@"emergencyName"];
        self.mobile = [decoder decodeObjectForKey:@"mobile"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.gender = [[decoder decodeObjectForKey:@"gender"] integerValue];

        
        return self;
    }
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:[NSNumber numberWithInt:self.memberContestantID] forKey:@"memberContestantID"];
    [encoder encodeObject:self.birthday forKey:@"birthday"];
    [encoder encodeObject:self.credentialNumber forKey:@"credentialNumber"];
    [encoder encodeObject:self.credentialType forKey:@"credentialType"];
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeObject:self.emergencyContact forKey:@"emergencyContact"];
    [encoder encodeObject:self.emergencyName forKey:@"emergencyName"];
    [encoder encodeObject:self.mobile forKey:@"mobile"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:[NSNumber numberWithInt:self.gender] forKey:@"gender"];

}

@end
