//
//  Result.h
//  Gocycling
//
//  Created by Apple on 14-4-17.
//
//

#import <Foundation/Foundation.h>

@interface Result : NSObject

@property(nonatomic,assign) BOOL isSuccess;
@property(nonatomic,strong) id data;
@property(nonatomic,strong) NSError* error;

-(id)initWithRequestSuccess:(id)successData;

-(id)initWithrequestError:(NSError*)requestError;


@end



