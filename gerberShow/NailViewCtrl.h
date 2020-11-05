//
//  NailViewCtrl.h
//  gerberShow
//
//  Created by WMH on 7/31/13.
//  Copyright (c) 2013 Louis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NailViewCtrl : NSViewController<NSPopoverDelegate>
{
    @private
    NSString *mNailNo ;
    NSString *mNailPos_X   ;
    NSString *mNailPos_Y   ;
    NSString *mNailNetName ;
    NSColor  *mPinColor    ;
    
    IBOutlet NSPopover *mPopover ;
    IBOutlet NSTextField *mTFNailInfo ;
}

@property(readwrite,retain) NSString *mNailNo ;
@property(readwrite,retain) NSString *mNailPos_X ;
@property(readwrite,retain) NSString *mNailPos_Y ;
@property(readwrite,retain) NSString *mNailNetName ;
@property(readwrite,retain) NSColor  *mPinColor    ;

-(IBAction)btn_ShowPOPView:(id)sender ;
@end
