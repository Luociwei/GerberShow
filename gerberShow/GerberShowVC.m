//
//  GerberShowCtrl.m
//  gerberShow
//
//  Created by WMH on 7/31/13.
//  Copyright (c) 2013 Louis. All rights reserved.
//

#import "GerberShowVC.h"
#define  kGerberPath        @"GerberPath"

@implementation GerberShowVC
-(id)init
{
    mCfgDict = nil ;
    self = [super init] ;
    if (self)
    {
        mCfgDict = [[NSMutableDictionary alloc] init] ;
        NSString *strTmp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"config.plist"] ;
        NSDictionary *config = [NSDictionary dictionaryWithContentsOfFile:strTmp] ;
        if (config)
            [mCfgDict addEntriesFromDictionary:config] ;
        
        
    }
    
    return self ;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    if ([mCfgDict objectForKey:kGerberPath]){
        [mTFGerberPath setStringValue:[mCfgDict objectForKey:kGerberPath]] ;
    }else{
        [mTFGerberPath setStringValue:@""] ;
    }
    [mGerberView inital];
}


- (void)dealloc
{
    [mCfgDict release] ;
    [super dealloc];
}


#pragma mark--UI Action function
-(IBAction)btn_Zoom:(id)sender
{
    [mGerberView zoom] ;
    return ;
} ;

-(IBAction)btn_Reduce:(id)sender
{
    [mGerberView reduce] ;
    return ;
};


-(IBAction)btn_Browse:(id)sender
{
    NSOpenPanel *openPanel=[NSOpenPanel openPanel];
    //NSString *openPath =[[NSBundle mainBundle] resourcePath];
    NSString *openPath = [NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES)lastObject];
    [openPanel setDirectoryURL:[NSURL fileURLWithPath:openPath]];
    
    [openPanel setCanChooseDirectories:YES] ;
    [openPanel setCanChooseFiles:NO] ;
    [openPanel setPrompt:@"Choose"];
    
    [openPanel beginSheetModalForWindow:[[NSApplication sharedApplication] mainWindow] completionHandler:^(NSInteger result){
        if (result==NSFileHandlingPanelOKButton)
        {
            [mTFGerberPath setStringValue:openPanel.URL.path] ;
            [mCfgDict setObject:[NSString stringWithString:openPanel.URL.path] forKey:kGerberPath] ;
            [mCfgDict writeToFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"config.plist"] atomically:YES] ;
     
        }
    }];
}

-(IBAction)btn_Display:(id)sender{
    
    if (mTFGerberPath.stringValue.length==0)
        return ;
    
    NSString *path = mTFGerberPath.stringValue ;
    NSFileManager *fileManager = [NSFileManager defaultManager] ;
    if ([fileManager fileExistsAtPath:[path stringByAppendingPathComponent:@"Format.asc"]])
        [mGerberView initializeOutlinePoint:[path stringByAppendingPathComponent:@"Format.asc"]] ;
    
    if ([fileManager fileExistsAtPath:[path stringByAppendingPathComponent:@"Nails.txt"]])
        [mGerberView initializeNailsPoint:[path stringByAppendingPathComponent:@"Nails.txt"]] ;
    else
        [mGerberView initializeNailsPoint:[path stringByAppendingPathComponent:@"Nails.asc"]] ;
    
    if ([fileManager fileExistsAtPath:[path stringByAppendingPathComponent:@"pins.asc"]])
        [mGerberView initializeTopPinsPoint:[path stringByAppendingPathComponent:@"pins.asc"]] ;
    
    [mCBSearch removeAllItems] ;
    [mCBSearch addItemsWithObjectValues:[mGerberView getNetNames]] ;
    [mGerberView setNeedsDisplay:YES] ;
    return ;
}

-(IBAction)btn_ExactMatch:(id)sender
{
    NSString *strTmp = mCBSearch.stringValue ;
    if (strTmp.length==0)
        return ;
    
    
    for (int i=0; i<mGerberView.mNailViewCtrlList.count; i++)
    {
        NailViewCtrl *nailViewCtrl = [mGerberView.mNailViewCtrlList objectAtIndex:i] ;
        
        if ([nailViewCtrl.mNailNo isEqualToString:strTmp] ||
            [nailViewCtrl.mNailNetName isEqualToString:strTmp])
        {
            nailViewCtrl.mPinColor = [NSColor whiteColor] ;
            [nailViewCtrl btn_ShowPOPView:sender] ;
            return ;
        }else
            nailViewCtrl.mPinColor = [NSColor redColor] ;
    }
    [mGerberView setNeedsDisplay:YES] ;
    return ;
}

-(IBAction)btn_FuzzyMatch:(id)sender
{
    NSString *strTmp = mCBSearch.stringValue ;
    if (strTmp.length==0)
        return ;
    
    
    NailViewCtrl *firstViewCtrl = nil ;
    for (int i=0; i<mGerberView.mNailViewCtrlList.count; i++)
    {
        NailViewCtrl *nailViewCtrl = [mGerberView.mNailViewCtrlList objectAtIndex:i] ;
        NSRange range1 = [nailViewCtrl.mNailNo rangeOfString:strTmp] ;
        NSRange range2 = [nailViewCtrl.mNailNetName rangeOfString:strTmp] ;
        
        if (range1.location!=NSNotFound || range2.location!=NSNotFound)
        {
            nailViewCtrl.mPinColor = [NSColor whiteColor] ;
            if (firstViewCtrl==nil)
                firstViewCtrl = nailViewCtrl ;
        }else
            nailViewCtrl.mPinColor = [NSColor redColor] ;
    }
    
    [firstViewCtrl btn_ShowPOPView:sender] ;
    [mGerberView setNeedsDisplay:YES] ;
    return ;
}

-(IBAction)btn_ReverseX:(id)sender
{
    [mGerberView setReverseX] ;
    return ;
}

-(IBAction)btn_reverseY:(id)sender
{
    [mGerberView setReverseY] ;
    return ;
}

-(IBAction)btn_TopBottom:(id)sender
{
    [mGerberView setTopBottom] ;
    return ;
}

@end
