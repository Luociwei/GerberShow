//
//  PinsPartDM.m
//  gerberShow
//
//

#import "PinsPartDM.h"

@implementation PinsPartDM
@synthesize mChipName,mNailList,mNetName,mPinName,mPinX,mPinY,mLayer;
-(id)init
{
    mChipName = [[NSString alloc] initWithString:@""] ;
    mNailList = [[NSString alloc] initWithString:@""] ;
    mNetName = [[NSString alloc] initWithString:@""] ;
    mPinName = [[NSString alloc] initWithString:@""] ;
    
    mPinX = 0.0f ;
    mPinY = 0.0f ;
    self = [super init] ;
    
    return self ;
}

- (void)dealloc
{
    [mChipName release] ;
    [mNailList release] ;
    [mNetName release]  ;
    [mPinName release]  ;
    
    [super dealloc];
}
@end
