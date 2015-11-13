//
//  ActivityCompetition.h
//  Gocycling
//
//  Created by LaiZhaowu on 14-6-10.
//
//

#import <Foundation/Foundation.h>
#import "WebAPI.h"
#import "Result.h"

@interface ActivityCompetition : NSObject

@property (nonatomic, assign) int activityCompetitionID;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, assign) float price;
@property (nonatomic, assign) int quota;


@end
