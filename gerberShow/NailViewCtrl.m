//
//  NailViewCtrl.m
//  gerberShow
//
//  Created by WMH on 7/31/13.
//  Copyright (c) 2013 Louis. All rights reserved.
//

#import "NailViewCtrl.h"

@interface NailViewCtrl ()

@end

@implementation NailViewCtrl
@synthesize mNailNo,mNailNetName,mNailPos_X,mNailPos_Y,mPinColor ;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    mNailNo = nil ;
    mNailPos_X = nil ;
    mNailPos_Y = nil ;
    mNailNetName =nil ;
    mPinColor = [[NSColor redColor] retain] ;
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    if (mPopover)
    {
        [mPopover close] ;
        mPopover.delegate = nil ;
    }
    
    [mNailNetName release] ;
    [mNailNo release] ;
    [mNailPos_X release] ;
    [mNailPos_Y release] ;
    [mPinColor release] ;
    [super dealloc];
}


-(IBAction)btn_ShowPOPView:(id)sender
{
    if (mPopover.isShown==FALSE)
    {
        NSRectEdge prefEdge = CGRectMaxYEdge; //NSMinXEdge ;
        [mPopover showRelativeToRect:self.view.bounds ofView:self.view preferredEdge:prefEdge];
    }
}


#pragma mark-pop view delegated function .
- (BOOL)popoverShouldClose:(NSPopover *)popover
{
    return TRUE ;
}

-(void)popoverWillShow:(NSNotification *)notification
{
    [mTFNailInfo setStringValue:[NSString stringWithFormat
                                 :@"[%@]  %@\nPosition:%@,%@",mNailNo,mNailNetName,mNailPos_X,mNailPos_Y]] ;
    return ;
}

// -------------------------------------------------------------------------------
// Invoked on the delegate when the NSPopoverWillCloseNotification notification is sent.
// This method will also be invoked on the popover.
// -------------------------------------------------------------------------------
- (void)popoverDidClose:(NSNotification *)notification
{
    return ;
}

@end
