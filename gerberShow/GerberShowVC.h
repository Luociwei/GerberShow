//
//  GerberShowVC.h
//  gerberShow
//
//  Created by ciwei luo on 2020/3/5.
//  Copyright © 2020 Louis. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GerberView.h"
NS_ASSUME_NONNULL_BEGIN

@interface GerberShowVC : NSViewController
{
@private
    
    IBOutlet GerberView *mGerberView;
    IBOutlet NSTextField *mTFGerberPath  ;
    IBOutlet NSComboBox *mCBSearch       ;
    
    NSMutableDictionary *mCfgDict        ;
}

-(IBAction)btn_Zoom:(id)sender ;
-(IBAction)btn_Reduce:(id)sender ;

-(IBAction)btn_Browse:(id)sender ;
-(IBAction)btn_Display:(id)sender ;
-(IBAction)btn_FuzzyMatch:(id)sender ;
-(IBAction)btn_ExactMatch:(id)sender ;
-(IBAction)btn_ReverseX:(id)sender ;
-(IBAction)btn_reverseY:(id)sender ;
-(IBAction)btn_TopBottom:(id)sender;
@end

NS_ASSUME_NONNULL_END
