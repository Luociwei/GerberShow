//
//  PinsPartDM.h
//  gerberShow
//
//

#import <Foundation/Foundation.h>

@interface PinsPartDM : NSObject
{
    @private
    NSString *mChipName ;
    NSString *mPinName  ;
    NSString *mNetName  ;
    NSString *mNailList ;
    
    int     mLayer      ;
    float   mPinX       ;
    float   mPinY       ;
}

@property(readwrite,retain) NSString *mChipName ;
@property(readwrite,retain) NSString *mPinName ;
@property(readwrite,retain) NSString *mNetName ;
@property(readwrite,retain) NSString *mNailList ;

@property(readwrite,assign) float   mPinX       ;
@property(readwrite,assign) float   mPinY       ;
@property(readwrite,assign) int     mLayer      ;

@end
