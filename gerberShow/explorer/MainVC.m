//
//  MainTabVC.m
//  SearchPinVC
//
//  Created by ciwei luo on 2019/6/27.
//  Copyright © 2019 ciwei luo. All rights reserved.
//

#import "MainVC.h"
#import "SearchPinVC.h"
#import "GerberShowVC.h"
#define AppWidth 1200
#define AppHeight 700
@interface MainVC ()
@property (nonatomic,strong)SearchPinVC *pinVC;
@property (nonatomic,strong)GerberShowVC *gerberShowVC;
@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame= NSMakeRect(0, 0, AppWidth, AppHeight);
    // Do view setup here.
    SearchPinVC *pinVC=[[SearchPinVC alloc]init];
    pinVC.view.frame = self.view.frame;
    self.pinVC = pinVC;
    [self addChildViewController:pinVC];
//    self.tabStyle =NSTabViewControllerTabStyleUnspecified;
//    
    GerberShowVC *gerberShowVC=[[GerberShowVC alloc]init];
    gerberShowVC.view.frame = self.view.frame;
    self.gerberShowVC = gerberShowVC;
    
    [self addChildViewController:gerberShowVC];

    self.selectedTabViewItemIndex = 0;
    
}

- (void)tabView:(NSTabView *)tabView willSelectTabViewItem:(nullable NSTabViewItem *)tabViewItem{
    [super tabView:tabView willSelectTabViewItem:tabViewItem];
    if ([tabViewItem.label isEqualToString:@"GerberShowVC"]) {
        self.pinVC.isDisAppear = YES;
    }
}

@end
