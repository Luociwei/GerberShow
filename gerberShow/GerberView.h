//
//  GerberView.h
//  gerberShow
//
//  suncode.
//  suncode. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RegexKitLite.h"
#import "NailViewCtrl.h"
#import "PinsPartDM.h"
#define kGerberNail_Number      @"GerberNail_Number"
#define kGerberNail_X           @"GerberNail_X"
#define kGerberNail_Y           @"GerberNail_Y"
#define kGerberNail_NetName     @"GerberNail_NetName"


#define kGerberOutLine_X       @"GerberOutLine_X" ;
#define kGerberOutLine_Y       @"GerberOutLine_Y" ;
#define kGerberOutLine_X_Unit  @"GerberOutLine_X_Unit" ;
#define kGerberOutLine_Y_Unit  @"GerberOutLine_Y_Unit" ;

#define K (0.017453292519943295769236907684886l)
typedef enum
{
    Unit_Metric = 0 ,
    Unit_INCH   = 1 ,
} PixelUnit ;


@interface GerberView : NSView
{
    @private
    int mLeftRightShift ;
    int mUpDownShift    ;
    float mChangeShift    ;
    
    PixelUnit mOutlineUnit ;
    float mCenterPointX ;
    float mCenterPointY ;
    BOOL  mReverseX  ;
    BOOL  mReverseY  ;
    BOOL  mTOPBoard  ;
    
    NSMutableArray *mBoardOutlinePoint ;
    NSBezierPath *mGerberBezierPath ;
    NSMutableArray *mNailViewCtrlList ;
    NSMutableArray *mTopPinPoint       ;
    
    NSPoint mMouseDragPointStart ;
    NSPoint mMouseDragPointEnd   ;
    NSTimeInterval mMouseDownTime ;
}
@property(readonly) NSMutableArray *mNailViewCtrlList ;

-(BOOL)initializeOutlinePoint:(NSString*)filePath ;
-(BOOL)initializeNailsPoint:(NSString*)filePath ;
-(BOOL)initializeTopPinsPoint:(NSString*)filePath ;

-(void)zoom ;
-(void)reduce ;
-(void)setHorizontalShift:(int)shift ;
-(int)getHorizontalShift ;
-(void)setVerticalShift:(int)shift ;
-(int)getVerticalShift ;
-(void)setReverseX;
-(void)setReverseY;
-(void)setTopBottom ;

-(NSArray*)getNetNames ;
-(void)inital;
@end
