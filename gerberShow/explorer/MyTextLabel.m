//
//  CWTextLable.m
//  SearchPinTool
//
//  Created by ciwei luo on 2019/6/30.
//  Copyright © 2019 macdev. All rights reserved.
//

#import "MyTextLabel.h"

@implementation MyTextLabel

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    
    // Drawing code here.
}
-(instancetype)initWithFrame:(NSRect)frameRect{
    
    if (self = [super initWithFrame:frameRect]) {
        self.bordered = NO;
        self.drawsBackground = NO;
        self.alignment=NSTextAlignmentLeft;

        self.textColor=[NSColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        self.editable = NO;
        
    }
    return self;
    
}

//@property (class, strong, readonly) NSColor *grayColor;         /* 0.5 white */
//@property (class, strong, readonly) NSColor *redColor;          /* 1.0, 0.0, 0.0 RGB */
//@property (class, strong, readonly) NSColor *greenColor;        /* 0.0, 1.0, 0.0 RGB */
@end
