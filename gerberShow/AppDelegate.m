//
//  AppDelegate.m
//  gerberShow
//
//  Created by ciwei luo on 2020/3/5.
//  Copyright © 2020 Louis. All rights reserved.
//

#import "AppDelegate.h"
#import "MainVC.h"

@interface AppDelegate ()

@end


@implementation AppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
//    GerberShowVC *gerberShowVC = [GerberShowVC new];MainVC
//    self.Window.contentViewController = gerberShowVC;
    

    MainVC *mainVC = [MainVC new];
    self.Window.contentViewController = mainVC;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(windowWillClose:)
                                                 name:NSWindowWillCloseNotification
                                               object:nil];
    
}
- (void)windowWillClose:(NSNotification *)notification {
    
    [NSApp terminate:nil];
}


@end
