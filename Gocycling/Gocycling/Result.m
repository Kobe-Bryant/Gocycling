//
//  Result.m
//  Gocycling
//
//  Created by Apple on 14-4-17.
//
//

#import "Result.h"

@implementation Result

-(id)initWithRequestSuccess:(id)successData
{
    self = [super init];
    
    if (self) {
       
        self.isSuccess = YES;
        self.data = successData;
        self.error = nil;
    }
  
    return self;
    
}

-(id)initWithrequestError:(NSError*)requestError
{
    self = [super init];
    
    if (self) {
        
        self.isSuccess = NO;
        self.data = nil;
        self.error =  requestError;
    }
    
    return self;
    
}


@end
