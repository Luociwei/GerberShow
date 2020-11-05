//
//  GerberView.m
//  gerberShow
//
//  suncode.
//  suncode. All rights reserved.
//

#import "GerberView.h"

//rotation x,y
//    float x =rtn.x ;
//    float y =rtn.y ;
//
//    rtn.x = x*cos(K*mRotation)-y*sin(K*mRotation) ;
//    rtn.y = x*sin(K*mRotation)+y*cos(K*mRotation) ;

@implementation GerberView
@synthesize mNailViewCtrlList ;

-(void)inital{
    
        mBoardOutlinePoint = nil ;
        mGerberBezierPath = nil ;
        mNailViewCtrlList = nil ;
        mCenterPointX =0 ;
        mCenterPointY =0 ;
        mReverseX = FALSE ;
        mReverseY = FALSE ;
        mTOPBoard = FALSE ;
        mTopPinPoint = nil ;
        
        mBoardOutlinePoint = [[NSMutableArray alloc] init] ;
        mNailViewCtrlList = [[NSMutableArray alloc] init] ;
        mLeftRightShift =0 ;
        mUpDownShift = 0 ;
        mChangeShift = 1 ;
        mGerberBezierPath = [[NSBezierPath alloc] init] ;
        mTopPinPoint = [[NSMutableArray alloc] init] ;
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector
                                                         :@selector(handleNotification:) name
                                                         :NSViewFrameDidChangeNotification object:self] ;
    
}


- (id)initWithFrame:(NSRect)frame
{
    mBoardOutlinePoint = nil ;
    self = [super initWithFrame:frame];
    mGerberBezierPath = nil ;
    mNailViewCtrlList = nil ;
    mCenterPointX =0 ;
    mCenterPointY =0 ;
    mReverseX = FALSE ;
    mReverseY = FALSE ;
    mTOPBoard = FALSE ;
    mTopPinPoint = nil ;
    if (self) {
        // Initialization code here.
        mBoardOutlinePoint = [[NSMutableArray alloc] init] ;
        mNailViewCtrlList = [[NSMutableArray alloc] init] ;
        mLeftRightShift =0 ;
        mUpDownShift = 0 ;
        mChangeShift = 1 ;
        mGerberBezierPath = [[NSBezierPath alloc] init] ;
        mTopPinPoint = [[NSMutableArray alloc] init] ;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector
                                                     :@selector(handleNotification:) name
                                                     :NSViewFrameDidChangeNotification object:self] ;
    
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
    [mBoardOutlinePoint release] ;
    [mGerberBezierPath release] ;
    [mNailViewCtrlList release] ;
    [mTopPinPoint release] ;
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    [super drawRect:dirtyRect] ;
    [self showBoardOutline];
    
    if (mTOPBoard)
        [self topBoardShow] ;
    else
        [self adjustNailPosition] ;
}


#pragma mark--initialize data from file
-(BOOL)initializeOutlinePoint:(NSString*)filePath
{
    if (filePath==nil)
        return  FALSE ;
    
    
    NSString *strTmp = [NSString stringWithContentsOfFile:filePath encoding:NSASCIIStringEncoding error:nil] ;
    if (strTmp==nil || strTmp.length==0)
        return FALSE ;
    
    //get unit info
    NSString *strUnit = [strTmp stringByMatching:@"[A-Z,a-z]+\\sunits"] ;
    if (strUnit==nil)
        return FALSE ;
    
    strUnit = [strUnit stringByMatching:@"[A-Z,a-z]+"] ;
    if ([strUnit.uppercaseString isEqualToString:@"INCH"])
    {
        mOutlineUnit = Unit_INCH ;
        mChangeShift = 96 ;
    }else
    {
        mOutlineUnit = Unit_Metric ;
        mChangeShift = (1.0/25.4)*96 ;
    }
    
    [mBoardOutlinePoint removeAllObjects] ;
    
    float maxY,minY ,maxX,minX ;
    NSArray *arrPoint  = [strTmp componentsMatchedByRegex:@"(-?\\d+\\.{1}\\d+\\s+){3}"] ;
    for (int i=0; i<arrPoint.count; i++)
    {
        NSString *lines = [arrPoint objectAtIndex:i] ;
        NSArray *arrayTmp = [lines componentsMatchedByRegex:@"-?\\d+\\.{1}\\d+"] ;
        if (arrayTmp.count!=3)
            return  FALSE ;
        
        [mBoardOutlinePoint addObject:[NSString stringWithFormat:@"%@,%@",[arrayTmp objectAtIndex:0],[arrayTmp objectAtIndex:1]]] ;
        
        if ([[arrayTmp objectAtIndex:0] floatValue]< mLeftRightShift)
            mLeftRightShift = [[arrayTmp objectAtIndex:0] floatValue] ;
        
        if ([[arrayTmp objectAtIndex:1] floatValue]< mUpDownShift)
            mUpDownShift = [[arrayTmp objectAtIndex:0] floatValue] ;
        
        if (i==0)
        {
            maxX=minX = [[arrayTmp objectAtIndex:0] floatValue] ;
            maxY=minY = [[arrayTmp objectAtIndex:1] floatValue] ;
        }else
        {
            if (maxX<[[arrayTmp objectAtIndex:0] floatValue])
                maxX = [[arrayTmp objectAtIndex:0] floatValue] ;
            
            if (minX>[[arrayTmp objectAtIndex:0] floatValue])
                minX = [[arrayTmp objectAtIndex:0] floatValue] ;
            
            if (maxY<[[arrayTmp objectAtIndex:1] floatValue])
                maxY = [[arrayTmp objectAtIndex:1] floatValue] ;
            
            if (minY>[[arrayTmp objectAtIndex:1] floatValue])
                minY = [[arrayTmp objectAtIndex:1] floatValue] ;
        }
    }
    
    mCenterPointX = (maxX-minX)/2.0 ;
    mCenterPointY = (maxY-minY)/2.0 ;
//    //计算至view 中心点 的shift...
    NSRect frame =  self.bounds ;
    mLeftRightShift = (frame.size.width/2.0)-mCenterPointX ;
    mUpDownShift = (frame.size.height/2.0)-mCenterPointY   ;
    
    return TRUE ;
}

-(void)showBoardOutline
{
    if (mBoardOutlinePoint.count==0)
        return ;
    
    [mGerberBezierPath removeAllPoints] ;
    for (int i=0; i<mBoardOutlinePoint.count; i++)
    {
        NSString *strTmp = [mBoardOutlinePoint objectAtIndex:i] ;
        NSArray *arrTmp = [strTmp componentsSeparatedByString:@","] ;
        if (arrTmp.count!=2)
            return ;
        NSPoint point ;
        point = [self calculateOutlinePoint:NSMakePoint([[arrTmp objectAtIndex:0] floatValue], [[arrTmp objectAtIndex:1] floatValue])] ;
        
        if (i==0)
            [mGerberBezierPath moveToPoint:point] ;
        else
        {
            [mGerberBezierPath lineToPoint:point] ;
        }
    }
    
    [[NSColor blackColor] set] ;
    [mGerberBezierPath fill] ;
    [mGerberBezierPath closePath] ;
}

-(BOOL)initializeNailsPoint:(NSString*)filePath
{
    if (filePath==nil)
        return  FALSE ;
    
    
    NSString *strTmp = [NSString stringWithContentsOfFile:filePath encoding:NSASCIIStringEncoding error:nil] ;
    if (strTmp==nil || strTmp.length==0)
        return FALSE ;
    
    [mNailViewCtrlList removeAllObjects] ;
    NSLog(@"%@",[filePath pathExtension]) ;
    if ([[[filePath pathExtension] uppercaseString] isEqualToString:@"ASC"]) //Nail.asc
    {
        NSArray *arrLines  = [strTmp componentsMatchedByRegex:@"\\${1}\\d+[ ]+(-?\\d+\\.{1}\\d+\\s+){2}\.*"];
        for (int i=0; i<arrLines.count; i++)
        {
            NSString *lines = [arrLines objectAtIndex:i] ;
            NSArray *arrayTmp = [lines componentsSeparatedByRegex:@"\\s+"] ;
            if (arrayTmp.count<8)
                return  FALSE ;
            
            NailViewCtrl *nailViewCtrl = [[NailViewCtrl alloc] initWithNibName:@"NailViewCtrl" bundle:nil] ;
            [mNailViewCtrlList addObject:[nailViewCtrl autorelease]] ;
            nailViewCtrl.mNailNo = [arrayTmp objectAtIndex:0] ;
            nailViewCtrl.mNailPos_X = [arrayTmp objectAtIndex:1]   ;
            nailViewCtrl.mNailPos_Y = [arrayTmp objectAtIndex:2]   ;
            nailViewCtrl.mNailNetName = [arrayTmp objectAtIndex:7] ;
            [self addSubview:nailViewCtrl.view] ;
        }
    }else //Nail.txt
    {
        NSArray *arrLines = [strTmp componentsMatchedByRegex:@"([A-Z,a-z,0-9,.,\\-,_]+\\s+){4}[\\n,\\r]{1}"] ;
        for (int i=0; i<arrLines.count; i++)
        {
            NSString *lines = [arrLines objectAtIndex:i] ;
            NSArray *arrayTmp = [lines componentsSeparatedByRegex:@"\\s+"] ;
            if (arrayTmp.count!=4)
                return  FALSE ;
            
            NailViewCtrl *nailViewCtrl = [[NailViewCtrl alloc] initWithNibName:@"NailViewCtrl" bundle:nil] ;
            [mNailViewCtrlList addObject:[nailViewCtrl autorelease]] ;
            nailViewCtrl.mNailNo = [arrayTmp objectAtIndex:0];
            nailViewCtrl.mNailPos_X = [arrayTmp objectAtIndex:1];
            nailViewCtrl.mNailPos_Y = [arrayTmp objectAtIndex:2];
            nailViewCtrl.mNailNetName = [arrayTmp objectAtIndex:3];
            [self addSubview:nailViewCtrl.view] ;
        }

    }
    
    return TRUE ;
}

-(void)adjustNailPosition{
    
    for (int i=0; i<mNailViewCtrlList.count; i++)
    {
        NailViewCtrl *viewCtrl = [mNailViewCtrlList objectAtIndex:i] ;
        ////
        NSRect rect = [self calculateNailRect:NSMakePoint(viewCtrl.mNailPos_X.floatValue, viewCtrl.mNailPos_Y.floatValue)] ;
        NSBezierPath *bPath = [NSBezierPath bezierPathWithOvalInRect:rect] ;
        [viewCtrl.mPinColor set] ;
        [bPath fill] ;
        
        [viewCtrl.view setFrame:rect] ;
    }
    
    return ;
}

-(BOOL)initializeTopPinsPoint:(NSString*)filePath{
    if (filePath==nil)
        return  FALSE ;
    
    NSString *strTmp = [NSString stringWithContentsOfFile:filePath encoding:NSASCIIStringEncoding error:nil] ;
    if (strTmp==nil || strTmp.length==0)
        return FALSE ;
    
    [mTopPinPoint removeAllObjects] ;
    //Part\\s+[A-Z,a-z,0-9]+\\s+\\(\\w\\)[\\s+\\n]+
  //@"Part\\s+[A-Z,a-z,0-9]+\\s+\\(\\w\\)[\\s+\\n]+(([A-Z,a-z,0-9,.,\\-,_,<,>]+\\s+){6}[\\d,\,]*\\s*)+"
    NSArray *arrParts  = [strTmp componentsSeparatedByString:@"Part"] ;
    for (int i=0; i<arrParts.count; i++)
    {
        NSString *strTmp = [arrParts objectAtIndex:i] ;
        NSString *chipName = [strTmp stringByMatching:@"\\s+[A-Z,a-z,0-9]+\\s+"];
        chipName = [chipName stringByMatching:@"[A-Z,a-z,0-9]+"] ;
        
        NSArray *pinLines = [strTmp componentsMatchedByRegex
                             :@"\\d+\\s+[A-Z,a-z,0-9]+\\s+(\\d+.{1}\\d+\\s+){2}\\d+\\s+[A-Z,a-z,0-9,_<,>]+\\s+"] ;
        for (int j=0; j<pinLines.count; j++)
        {
            NSString *strPinLine = [pinLines objectAtIndex:j] ;
            NSArray *arrPins = [strPinLine componentsSeparatedByRegex:@"\\s+"] ;
            
            PinsPartDM *pinDM = [[PinsPartDM alloc] init] ;
            pinDM.mChipName = chipName ;
            pinDM.mPinName = [arrPins objectAtIndex:1] ;
            pinDM.mPinX = [[arrPins objectAtIndex:2] floatValue] ;
            pinDM.mPinY = [[arrPins objectAtIndex:3] floatValue] ;
            pinDM.mLayer = [[arrPins objectAtIndex:4] intValue]  ;
            pinDM.mNetName = [arrPins objectAtIndex:5] ;
            if (arrPins.count==7)
                pinDM.mNailList = [arrPins objectAtIndex:6] ;
            
            [mTopPinPoint addObject:[pinDM autorelease]] ;
        }
    }
    
    return TRUE ;
}

-(void)topBoardShow
{
    for (int i=0; i<mTopPinPoint.count; i++)
    {
        PinsPartDM *pinDM = [mTopPinPoint objectAtIndex:i] ;
        NSRect rect = [self calculateNailRect:NSMakePoint(pinDM.mPinX, pinDM.mPinY)] ;
        NSBezierPath *bPath = [NSBezierPath bezierPathWithOvalInRect:rect] ;
        [[NSColor greenColor] set] ;
        [bPath fill] ;
        
    }
    
    return ;
}

#pragma mark-outline function
-(NSPoint)calculateOutlinePoint:(NSPoint)pixelPoint
{
    NSPoint rtn  ;
    rtn.x = mChangeShift*(pixelPoint.x-mCenterPointX)+mCenterPointX ;
    rtn.y = mChangeShift*(pixelPoint.y-mCenterPointY)+mCenterPointY ;
    
    if (mReverseX) //
        rtn.x = mCenterPointX*2.0-rtn.x ;
    
    if (mReverseY) //
        rtn.y = mCenterPointY*2.0-rtn.y ;

    //move to center ....
    rtn.x +=mLeftRightShift ;
    rtn.y +=mUpDownShift ;
    
    
    return rtn ;
}

-(NSRect)calculateNailRect:(NSPoint)pixelPoint{
    
    NSRect rect ;
    if (mTOPBoard)
        rect.size.height = rect.size.width = 2.0 ;
    else
        rect.size.height = rect.size.width =4.0 ;
    
    rect.origin.x = pixelPoint.x - (rect.size.width/2.0);
    rect.origin.y = pixelPoint.y - (rect.size.height/2.0);
    
    rect.origin.x = mChangeShift*(pixelPoint.x-mCenterPointX)+mCenterPointX ;
    rect.origin.y = mChangeShift*(pixelPoint.y-mCenterPointY)+mCenterPointY ;
    if (mReverseX) //
        rect.origin.x = mCenterPointX*2.0-rect.origin.x ;
    
    if (mReverseY) //
        rect.origin.y = mCenterPointY*2.0-rect.origin.y ;
    
    //move to center ....
    rect.origin.x +=mLeftRightShift ;
    rect.origin.y +=mUpDownShift ;
    
    return rect ;
}

-(void)zoom
{
    mChangeShift +=0.5 ;
    [self setNeedsDisplay:YES] ;
    return ;
}
-(void)reduce
{
    mChangeShift -=0.5 ;
    if (mChangeShift<1)
        mChangeShift = 1 ;
    
    [self setNeedsDisplay:YES] ;
    return ;
}

-(void)setHorizontalShift:(int)shift
{
    mLeftRightShift = shift ;
    [self setNeedsDisplay:YES] ;
    return ;
}
-(int)getHorizontalShift
{
    return mLeftRightShift ;
}

-(void)setVerticalShift:(int)shift
{
    mUpDownShift = shift ;
    [self setNeedsDisplay:YES] ;
    return ;
}

-(int)getVerticalShift
{
    return mUpDownShift ;
}

-(void)setReverseX
{
    (mReverseX)?(mReverseX=FALSE):(mReverseX=TRUE) ;
    [self setNeedsDisplay:YES] ;
    return ;
}

-(void)setReverseY
{
    (mReverseY)?(mReverseY=FALSE):(mReverseY=TRUE) ;
    [self setNeedsDisplay:YES] ;
    return ;
}

-(void)setTopBottom
{
    (mTOPBoard)?(mTOPBoard=FALSE):(mTOPBoard=TRUE) ;
    [self setNeedsDisplay:YES] ;
    return ;
}

-(NSArray*)getNetNames
{
    NSMutableArray *rtnNetNames = [[NSMutableArray alloc] init] ;
    for (int i=0; i<mNailViewCtrlList.count; i++)
    {
        NailViewCtrl *viewCtrl = [mNailViewCtrlList objectAtIndex:i] ;
        if ([rtnNetNames containsObject:viewCtrl.mNailNetName]==FALSE)
            [rtnNetNames addObject:viewCtrl.mNailNetName] ;
    }
    
    return [rtnNetNames autorelease] ;
}

#pragma mark--notification
-(void)handleNotification:(NSNotification*)notification
{
    if ([notification.name isEqualToString:NSViewFrameDidChangeNotification])
    {
        NSRect frame =  self.bounds ;
        mLeftRightShift = (frame.size.width/2.0)-mCenterPointX ;
        mUpDownShift = (frame.size.height/2.0)-mCenterPointY   ;
        
    }
    
    return ;
}

#pragma mark--mouse related function
-(void)mouseDown:(NSEvent *)theEvent
{
    mMouseDragPointStart = [theEvent locationInWindow] ;
    mMouseDownTime = [theEvent timestamp] ;
    return ;
}

-(void)rightMouseDown:(NSEvent *)theEvent
{
    mMouseDownTime = [theEvent timestamp] ;
    return ;
}

-(void)mouseDragged:(NSEvent *)theEvent
{
    if (mBoardOutlinePoint.count>0)
    {
        mMouseDragPointEnd = [theEvent locationInWindow] ;
        mLeftRightShift +=mMouseDragPointEnd.x - mMouseDragPointStart.x ;
        mUpDownShift    +=mMouseDragPointEnd.y - mMouseDragPointStart.y ;
        [self setNeedsDisplay:YES] ;
        mMouseDragPointStart = mMouseDragPointEnd ;
    }
    return ;
}

//-(void)mouseUp:(NSEvent *)theEvent
//{
//    if (([theEvent timestamp]-mMouseDownTime)<0.2 && mBoardOutlinePoint.count>0)
//        [self zoom] ;
//    
//    return ;
//}
//
//-(void)rightMouseUp:(NSEvent *)theEvent
//{
//    if (([theEvent timestamp]-mMouseDownTime)<0.2 && mBoardOutlinePoint.count>0)
//        [self reduce] ;
//    
//    return ;
//}

-(void)scrollWheel:(NSEvent *)theEvent
{
    //鼠标滚轴事件
    if (mBoardOutlinePoint.count<=0)
        return ;
    
    if (theEvent.deltaY>0)
        [self zoom] ;
    else
        [self reduce] ;
}

@end
