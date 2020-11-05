//
//  PinBox.m
//  SearchPinVC
//
//  Created by ciwei luo on 2019/6/27.
//  Copyright © 2019 ciwei luo. All rights reserved.
//

#import "PinBox.h"

@interface PinBox ()

@property NSInteger type;

@end


@implementation PinBox

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
  
  
}

+(instancetype)pinBoxWithType:(int)type frame:(NSRect)frame{
    
    PinBox *pinBox = [[self alloc] init];
    pinBox.type = type;
    pinBox.frame = frame;
    [pinBox layoutSubViews];
    return pinBox;
}

-(void)layoutSubViews{
    // self.boxType = NSBoxCustom;
    // self.borderType=NSNoBorder;
    // self.fillColor=[NSColor greenColor];
    NSRect frameRect = self.frame;
    int pinBoxW = frameRect.size.width;
    
    NSView *btn = [[NSView alloc] initWithFrame:NSMakeRect(pinBoxW/4, pinBoxW/3, pinBoxW/4, pinBoxW/4)];
//    btn.title=@"";
//    [btn setBezelStyle:NSBezelStyleCircular];//NSBezelStyleCircular
//    [btn setButtonType:NSButtonTypeOnOff];
    btn.wantsLayer =YES;
    btn.layer.backgroundColor = [NSColor whiteColor].CGColor;
    [self addSubview:btn];
    self.btn=btn;
    NSRect labelFrame =NSMakeRect(-2, 0, pinBoxW*1.5, pinBoxW/3);
    if (!self.type) {
        labelFrame =NSMakeRect(-2, pinBoxW/1.7, pinBoxW*1.5, pinBoxW/3);
    }
    MyTextLabel *label =[[MyTextLabel alloc] initWithFrame:labelFrame];
    
    float textFont =pinBoxW/3.9;
    label.font = [NSFont systemFontOfSize:textFont];
    // label.wantsLayer=YES;
    // label.layer.backgroundColor=[NSColor redColor].CGColor;
    //label.stringValue = @"TP_GND";
    
    self.label=label;
    
    [self addSubview:label];
}
//-(instancetype)initWithFrame:(NSRect)frameRect{
//    self = [super initWithFrame:frameRect];
//    if (self) {
////        self.boxType = NSBoxCustom;
////        self.borderType=NSNoBorder;
//       // self.fillColor=[NSColor greenColor];
//        int pinBoxW = frameRect.size.width;
//        
//        NSButton *btn = [[NSButton alloc] initWithFrame:NSMakeRect(pinBoxW/4, pinBoxW/3, pinBoxW/4, pinBoxW/4)];
//        btn.title=@"";
//        [btn setBezelStyle:NSBezelStyleCircular];//NSBezelStyleCircular
//        [btn setButtonType:NSButtonTypeOnOff];
//        btn.state =0;
//        [self addSubview:btn];
//        self.btn=btn;
//        NSRect labelFrame =NSMakeRect(-2, 0, pinBoxW*1.5, pinBoxW/3);
//        if (self.type) {
//            labelFrame =NSMakeRect(-2, 15, pinBoxW*1.5, pinBoxW/3);
//        }
//        MyTextLabel *label =[[MyTextLabel alloc] initWithFrame:labelFrame];
//        
//        label.font = [NSFont systemFontOfSize:pinBoxW/4];
////        label.wantsLayer=YES;
////        label.layer.backgroundColor=[NSColor redColor].CGColor;
//       
//       //label.stringValue = @"TP_GND";
//        self.label=label;
//
//        [self addSubview:label];
//    }
//    return self;
//}

-(void)highLight:(BOOL)isLight{
    
    self.btn.wantsLayer=YES;
    self.wantsLayer = YES;
    if (isLight) {
        self.btn.layer.backgroundColor=[NSColor blueColor].CGColor;
        self.layer.backgroundColor=[NSColor redColor].CGColor;
    }else{
        self.btn.layer.backgroundColor=[NSColor whiteColor].CGColor;
        self.layer.backgroundColor=[NSColor clearColor].CGColor;
    }
    
    
}

-(void)setTitleStirng:(NSString *)str{
    [self.label setStringValue:str];
    if ([str containsString:@"M"]||[str containsString:@"N"]||[str containsString:@"G"]||[str containsString:@"H"]) {
        float w = self.frame.size.width;
        self.label.font =[NSFont systemFontOfSize:w/4.1];;
    }
}

@end
