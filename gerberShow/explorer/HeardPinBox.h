//
//  HeardPinBox.h
//  SearchPinTool
//
//  Created by ciwei luo on 2019/6/29.
//  Copyright © 2019 macdev. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface HeardPinBox : NSBox

@property (nonatomic,copy)NSString *netName;
-(void)resetShowingPin;
-(void)highLightWithPinPosition:(int)pinPosition;

@end

NS_ASSUME_NONNULL_END
