//
//  SearchPinVC.m
//  SearchPinVC
//
//  Created by ciwei luo on 2019/6/27.
//  Copyright © 2019 ciwei luo. All rights reserved.
//

#import "SearchPinVC.h"
#import "PinBox.h"
#import "HeardPinBox.h"
#define AppWidth 1200
#define AppHeight 700
#define margin 15
static const CGFloat rowHeight = 20.0;
//static NSString * const ShowRemoteNotificationContentKey = @"ShowRemoteNotificationContentKey";

#import "MyTextLabel.h"
#import "MyEexception.h"
@interface SearchPinVC ()<NSSearchFieldDelegate,NSTableViewDelegate,NSTableViewDataSource>
@property(copy)NSArray *tpNamesList;
@property(copy)NSArray *addTPList;
@property(strong)NSMutableArray *tpPinsArr;
@property(strong)PinBox *showingTpPin;
@property(strong)HeardPinBox *showingHeadPin;
@property(nonatomic, assign)NSSearchField *searchFiled;
@property(strong)HeardPinBox *heardPinBoxJ246;
@property(copy)NSDictionary *headPinsList;
@property(copy)NSDictionary *netNamesList;
@property(strong)NSMutableArray *headPinBoxsArr;
@property(nonatomic, copy)NSArray *headPinGroupNames;
@property(nonatomic, assign)MyTextLabel *textLabel;
//@property(nonatomic, strong)NSScrollView *scrollView;
//@property (nonatomic,strong) NSScrollView *tableViewScrollView;
//@property (nonatomic,weak) NSTableView *tableView;
@property (assign) IBOutlet NSScrollView *tableViewScrollView;
@property (assign) IBOutlet NSTableView *tableView;

@property (nonatomic,strong) NSArray *datas;
@property (assign) IBOutlet NSComboBox *configComboBox;

@end

@implementation SearchPinVC{
    BOOL _isJ4XX;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//     self.datas = @[@"USA",@"China",@"Japan",@"Russia",@"China",@"Japan",@"Russia",@"China",@"Japan",@"Russia",@"China",@"Japan",@"Russia"];
    [self.configComboBox removeAllItems];
    [self.configComboBox addItemsWithObjectValues:@[@"J5XX",@"J4XX"]];
    [self.configComboBox selectItemAtIndex:0];
//
//    [self configClick:nil];
    
    self.view.wantsLayer=YES;
    self.view.layer.backgroundColor=[NSColor gridColor].CGColor;
    // Do view setup here.
    [self dealDatas];
    [self setHeadPins];
    [self setTpPins];
    [self setAllFrames];
    self.tableView.doubleAction=NSSelectorFromString(@"doubleClick:");
    [self.view addSubview:self.tableViewScrollView];
    self.tableView.rowHeight=rowHeight;
    [self.tableView reloadData];
    

}


- (IBAction)configClick:(NSComboBox *)btn {
    NSString *title = btn.stringValue;
    if ([title containsString:@"J4XX"]) {
        _isJ4XX = YES;
    }else{
        _isJ4XX = NO;
    }
    
    self.view.wantsLayer=YES;
    self.view.layer.backgroundColor=[NSColor gridColor].CGColor;
    // Do view setup here.
    [self dealDatas];
    [self setHeadPins];
    [self setTpPins];
    [self setAllFrames];
    self.tableView.doubleAction=NSSelectorFromString(@"doubleClick:");
    [self.view addSubview:self.tableViewScrollView];
    self.tableView.rowHeight=rowHeight;
    [self.tableView reloadData];
}



-(void)setHeadPins{
    int headPinBoxW =AppWidth/4;
    int headPinBoxH =60;
    int col = 4;
    int row = 2;
    int gap = (AppWidth-headPinBoxW*col)/3;
    self.headPinBoxsArr = [NSMutableArray array];
    for (int j=0; j<row; j++) {
        int y = (row-j-1)*(headPinBoxH+margin*2)+(AppHeight*0.68);//(row-j-1)
        for (int i=0; i<col; i++) {
            
            int x =i*(headPinBoxW+gap);
            HeardPinBox *headPinBox = [[HeardPinBox alloc]initWithFrame:NSMakeRect(x, y, headPinBoxW, headPinBoxH)];
            NSInteger index = j*col+i;
            headPinBox.netName=[self.headPinGroupNames objectAtIndex:index];
            [self.view addSubview:headPinBox];
            
            [self.headPinBoxsArr addObject:headPinBox];
        }
    }
}

-(void)setTpPins{
    
    self.tpPinsArr=[NSMutableArray array];
    int pinBoxW=AppWidth/31;
    int pinBoxH =pinBoxW;
    int i =0;
    for (NSArray *arr in self.tpNamesList) {
        int j=0;
        NSMutableArray *mutArr = [NSMutableArray array];
        for (NSString *pinName in arr) {
            int x = j*pinBoxW+margin*2;
            int y=i*pinBoxH+3*margin;
            if (i==0) {
                if (j==0) {
                    x=x+pinBoxW;
                }else if (j==6){
                    x=x+pinBoxW*(2*j+2);
                }else if (j==7){
                    x=x+pinBoxW*(2*j+3);
                }else if (j==8){
                    x=x+pinBoxW*(2*j+4);
                }
                
                else{
                     x=x+pinBoxW*(2*j+1);
                }
            }
            if (i==1&&_isJ4XX) {
                if (j>=8) {
                    x=x+pinBoxW*2;
                }
            }

            int type = j%2;
            if (i==0) {
                type = 1;
            }
            PinBox *pin = [PinBox pinBoxWithType:type frame:NSMakeRect(x,y,pinBoxW,pinBoxH)];
            //PinBox *pin = [[PinBox alloc] initWithFrame:NSMakeRect(x,y,pinBoxW,pinBoxH)];
            
            [pin setTitleStirng:pinName];
            
            [self.view addSubview:pin];
            
            [mutArr addObject:pin];
            j++;
        }
        
        NSArray *array = (NSArray *)mutArr;
        [self.tpPinsArr addObject:array];
        i++;
        
    }
}


#pragma mark lazy load 
- (NSSearchField*)searchFiled
{
    if(!_searchFiled){
        NSSearchField *search =[[NSSearchField alloc] init];
        search.delegate=self;
        search.placeholderString=@"Input then Enter";
        int x = arc4random() % 5;
        NSString *str=x?@"tp9401":@"j42_29";
        search.stringValue = str;//tp93KE
        [search becomeFirstResponder];
        [self.view addSubview:search];
        _searchFiled=search;
    }
    return _searchFiled;
}

//-(NSScrollView *)tableViewScrollView{
//    if (!_tableViewScrollView) {
//        _tableViewScrollView = [[NSScrollView alloc] init];
//        [_tableViewScrollView setHasVerticalScroller:YES];
//        [_tableViewScrollView setHasHorizontalScroller:YES];
//        [_tableViewScrollView setFocusRingType:NSFocusRingTypeNone];
//        [_tableViewScrollView setAutohidesScrollers:YES];
//        [_tableViewScrollView setBorderType:NSBezelBorder];
//        [_tableViewScrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
//        [self.tableViewScrollView setDocumentView:self.tableView];
//        [self.view addSubview:_tableViewScrollView];
//    }
//    return _tableViewScrollView;
//}

//-(NSTableView *)tableView{
//    if (!_tableView) {
//        NSTableView *tabview = [[NSTableView alloc]init];
//
//        tabview.headerView=nil;
//        NSTableColumn *column1=[[NSTableColumn alloc]initWithIdentifier:@"tpName"];
//        column1.title = @"tpName";
//        [tabview addTableColumn:column1];
//        tabview.rowHeight = rowHeight;
//        tabview.delegate = self;
//        tabview.dataSource = self;
//        tabview.target=self;
//        tabview.doubleAction=NSSelectorFromString(@"doubleClick:");
//        _tableView=tabview;
//    }
//    return _tableView;
//}


- (MyTextLabel*)textLabel
{
    if(!_textLabel){
        MyTextLabel *textLabel =[[MyTextLabel alloc] init];
        textLabel.textColor = [NSColor redColor];
        textLabel.stringValue=[NSString stringWithFormat:@"Press Enter or double click to search"];
        [self.view addSubview:textLabel];
        _textLabel=textLabel;
    }
    return _textLabel;
}

- (NSArray*)headPinGroupNames
{
    if(!_headPinGroupNames){
        _headPinGroupNames=[NSArray arrayWithObjects:@"J246", @"J43",@"J108",@"J180",@"J42",@"J109",@"J245",@"J179",nil];
    }
    return _headPinGroupNames;
}


-(void)dealDatas{
    
    self.addTPList = [self getJsonDatasWithFileName:@"ButtomTPListjson.json"];
    self.tpNamesList= [self getJsonDatasWithFileName:@"tpNamesList.json"];
    
    self.headPinsList=[self getJsonDatasWithFileName:@"HeadPinList.json"];
    self.netNamesList=[self handleNetNamesList];
    self.datas=self.netNamesList.allKeys;
}

-(NSDictionary *)handleNetNamesList{
    NSDictionary *dic =[self getJsonDatasWithFileName:@"NetNameList.json"];
    NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] init];
    for (NSString *key in dic) {
        NSString *vaule = dic[key];
        [mutDic setObject:key forKey:vaule];
    }
    return (NSDictionary *)mutDic;
}

-(void)viewDidAppear{
    [super viewDidAppear];
  
    [MyEexception checkInstancesNum];
}


-(id)getJsonDatasWithFileName:(NSString *)file{
    
    
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *pathName = [NSString stringWithFormat:@"%@/%@",self.configComboBox.stringValue,file];
    NSString *configfile = [resourcePath stringByAppendingPathComponent:pathName];;
    
//    NSString *configfile = [[NSBundle mainBundle] pathForResource:file ofType:nil];
    // NSString *configfile = [[NSBundle mainBundle] pathForResource:@"Property List.plist" ofType:nil];
    
    //    NSString *desktopPath = [NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES)lastObject];
    //    NSString *eCodePath=[desktopPath stringByDeletingLastPathComponent];
    //    NSString *configfile=[eCodePath stringByAppendingPathComponent:@"pinList.json"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:configfile]) {
        
        return nil;
    }
    NSString* items = [NSString stringWithContentsOfFile:configfile encoding:NSUTF8StringEncoding error:nil];
    if (items.length<10) {
        return nil;
    }
    NSData *data= [items dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    return jsonObject;
}

- (void) doubleClick:(id)sender
{
    NSInteger rowNumber = [_tableView clickedRow];
    NSString *string = [self.datas objectAtIndex:rowNumber];
    self.searchFiled.stringValue = string;
  
    self.tableViewScrollView.hidden=YES;
    NSString *pinName = [self.netNamesList objectForKey:string];
    [self searchWithPinName:pinName];
}

- (void)controlTextDidChange:(NSNotification *)obj{
    NSTextField *textF=obj.object;
    if (textF==self.searchFiled) {
        self.datas =[self createListWithSearchWord:textF.stringValue list:self.netNamesList.allKeys];
        self.tableViewScrollView.hidden = NO;
        [self changeTableviewFrame];
        [self.tableView reloadData];
    }
}

- (NSArray *)createListWithSearchWord:(NSString *)word list:(NSArray<NSString *> *)oldList {
    NSString *searchWord = [word stringByApplyingTransform:NSStringTransformHiraganaToKatakana reverse:NO];
    searchWord = [searchWord uppercaseString];
    if (searchWord.length == 0) {
        return oldList;
    }
    NSMutableArray *newList = [NSMutableArray array];
    [oldList enumerateObjectsUsingBlock:^(NSString *element, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *fixedElement = [element stringByApplyingTransform:NSStringTransformHiraganaToKatakana reverse:NO];
        fixedElement = [fixedElement uppercaseString];
        
        NSRange searchResult = [fixedElement rangeOfString:searchWord];
        if (searchResult.location != NSNotFound) {
            [newList addObject:element];
        }
    }];
    return newList;
}


- (void)controlTextDidEndEditing:(NSNotification *)obj{
    NSLog(@"2-SearchPinVC frame %@",NSStringFromRect(self.view.frame));
    NSTextField *textF=obj.object;
    NSLog(@"%s--%@",__func__,textF.stringValue);
//textF.stringValue
    if (_isDisAppear) {
        return;
    }
    if (textF==self.searchFiled) {
        [self searchWithPinName:textF.stringValue];
    }
}

-(void)searchWithPinName:(NSString *)pinName{
    NSString *searchStr=[self checkPinName:pinName];
    self.textLabel.stringValue=@"";
    //        self.showingTpPin.layer.backgroundColor=[NSColor clearColor].CGColor;
    //        self.showingTpPin.btn.layer.backgroundColor=[NSColor blueColor].CGColor;
    [self.showingTpPin highLight:NO];
    [self.showingHeadPin resetShowingPin];
    if ([_addTPList containsObject:searchStr]) {
        self.textLabel.stringValue=@"Please find TP at buttom side of Translation Board";
        return;
    }
    NSArray *searchArr = [self searchIndexsWithPinName:searchStr];
    
    if (searchArr.count) {
        NSInteger row = [searchArr[0] integerValue];
        NSInteger index = [searchArr[1] integerValue];
        NSMutableString *mutStr = [NSMutableString stringWithFormat:@"TP:row=%ld,col=%ld",(long)row,(long)index];//Please find TP at buttom side of Translation Board
        PinBox *pinB = self.tpPinsArr[row][index];
        [pinB highLight:YES];
        self.showingTpPin=pinB;
        
        for (NSString *key in self.headPinsList.allKeys) {
            NSDictionary *dict = self.headPinsList[key];
            for (NSString *name in dict.allKeys) {
                if ([name isEqualToString:searchStr]) {
                    NSString *pinPos=dict[name];
                    for (HeardPinBox *headPinBox in _headPinBoxsArr) {
                        if ([headPinBox.netName isEqualToString:key]) {
                            self.showingHeadPin=headPinBox;
                            [headPinBox highLightWithPinPosition:pinPos.intValue];
                            [mutStr appendFormat:@"%@", [NSString stringWithFormat:@" HeadPin:%@_%@",key,pinPos]];
                        }
                    }
                    
                }
            }
        }
        
        self.textLabel.stringValue=mutStr;
    }
    
    //self.tableViewScrollView.hidden=YES;
}

-(NSString *)checkPinName:(NSString *)pinName{
    if ([pinName containsString:@"_"]) {
        NSArray *arr = [pinName componentsSeparatedByString:@"_"];
        if (arr.count==2) {
            NSString *name =[arr[0] uppercaseString];
            NSString *pos=arr[1];
            NSDictionary *dict = _headPinsList[name];
            
            for (NSString *key in dict) {
                if ([dict[key] isEqualToString:pos]) {
                    pinName=key;
                }
            }
        }
        
    }
    return [pinName uppercaseString];
}


-(NSArray *)searchIndexsWithPinName:(NSString *)pinName{

    NSInteger row=0;
    NSInteger index=0;
    if (!(pinName.length==5 || pinName.length==6)) {
        if ([pinName isEqualToString:@"TP78"]) {
            return @[@5,@7];
        }else{
            return nil;
        }
    }
    
    for (NSArray *rowArr in self.tpNamesList) {
        
        for (NSString *name in rowArr) {
            if ([name isEqualToString:pinName]) {
                row = [self.tpNamesList indexOfObject:rowArr];
                index=[rowArr indexOfObject:pinName];
                NSArray *arr = [NSArray arrayWithObjects:[NSNumber numberWithInteger:row],[NSNumber numberWithInteger:index], nil];
                return arr;
            }
        }
    }
    
    return nil;
}

-(void)setAllFrames{
    
    self.searchFiled.frame = NSMakeRect(rowHeight/2, AppHeight-3*rowHeight, 13.5*rowHeight, rowHeight);
    self.textLabel.frame = NSMakeRect(15*rowHeight, AppHeight-3*rowHeight, 30*rowHeight, rowHeight);
//    self.tableViewScrollView.frame =NSMakeRect(rowHeight/2, AppHeight-12*rowHeight, 13.5*rowHeight, rowHeight*10);
    self.tableViewScrollView.frame =NSMakeRect(rowHeight/2, self.searchFiled.frame.origin.y-rowHeight*10, 13.5*rowHeight, rowHeight*10);
    NSLog(@"1");
}
-(void)changeTableviewFrame{
    if (self.datas.count<9) {
        NSRect frame =self.tableViewScrollView.frame;
        frame.size.height = rowHeight*(self.datas.count+1);
        frame.origin.y =self.searchFiled.frame.origin.y-rowHeight*10-frame.size.height;
        self.tableViewScrollView.frame = frame;
    }else{
        self.tableViewScrollView.frame = NSMakeRect(rowHeight/2, self.searchFiled.frame.origin.y-rowHeight*10, 13.5*rowHeight, rowHeight*10);
    }
}


#pragma mark-  NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    //返回表格共有多少行数据
    return [self.datas count];
}
//- (nullable id)tableView:(NSTableView *)tableView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row{
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    
    NSString *identifier = tableColumn.identifier;
    
    //单元格数据
    NSString *value = self.datas[row];
    
    //根据表格列的标识,创建单元视图
    NSView *view = [tableView makeViewWithIdentifier:identifier owner:self];
    
    NSArray *subviews = [view subviews];
    NSTextField *textField = subviews[0];
    if ([tableColumn.identifier isEqualToString:@"NetName"])
    {
        
        textField.stringValue = value;
    }

    
    return view;
}




@end
