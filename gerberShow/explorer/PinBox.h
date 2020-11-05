//
//  PinBox.h
//  SearchPinVC
//
//  Created by ciwei luo on 2019/6/27.
//  Copyright © 2019 ciwei luo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
//#define margin 15
#import "MyTextLabel.h"
//#import "MyEexception.h"
NS_ASSUME_NONNULL_BEGIN

@interface PinBox : NSView
@property(nonatomic,strong)NSView *btn;
-(void)highLight:(BOOL)isLight;
-(void)setTitleStirng:(NSString *)str;
@property(nonatomic,strong)MyTextLabel *label;
+(instancetype)pinBoxWithType:(int)type frame:(NSRect)frame;
@end

NS_ASSUME_NONNULL_END
