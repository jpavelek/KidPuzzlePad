//
//  Bit.m
//  KidPuzzleCocosPad
//
//  Created by Jakub Pavelek on 3/29/12.
//  Copyright 2012 Afte9. All rights reserved.
//

#import "Bit.h"


@implementation Bit

@synthesize insprite;
@synthesize inscale;
@synthesize trayX;
@synthesize trayXX;
@synthesize trayY;
@synthesize trayYY;
@synthesize trayW;
@synthesize trayH;
@synthesize boardX;
@synthesize boardY;
@synthesize locked;

-(id)init: (NSString*)fname
{
	if( (self=[super init])) {
        insprite = [CCSprite spriteWithFile: fname];
    }
    return self;
}

-(void)setData: (int)ptx trayY:(int)pty trayW:(int)ptw trayH:(int)pth boardX:(int)pbx boardY:(int)pby
{
    trayX = ptx;
    trayY = pty;
    trayW = ptw;
    trayH = pth;
    boardX = pbx;
    boardY = pby;
    if (trayW != -1) {
        inscale = trayW/insprite.boundingBox.size.width;
    } else {
        inscale = trayH/insprite.boundingBox.size.height;
    }
    insprite.scale = inscale;
    trayXX = trayX + insprite.boundingBox.size.width/2;
    trayYY = trayY+insprite.boundingBox.size.height/2;
    insprite.position = ccp(trayXX, trayYY);
    locked = NO;
}


-(void)pop
{
    [insprite stopAllActions];
    id actionPop = [CCScaleTo actionWithDuration: 0.2 scale: 1.0];
    [insprite runAction: [CCEaseInOut actionWithAction: [[actionPop copy] autorelease] rate: 5.0f]];
}
-(void)back
{
    [insprite stopAllActions];
    id actionBackScale = [CCScaleTo actionWithDuration: 0.2 scale: inscale];
    //[insprite runAction: [CCEaseInOut actionWithAction: [[actionBackScale copy] autorelease] rate: 5.0f]];
    CGPoint r = CGPointMake(trayXX, trayYY);
    id actionBackMove = [CCMoveTo actionWithDuration: 0.2 position: r];
    id animSpawn = [CCSpawn actions: actionBackMove, actionBackScale, nil];
    [insprite runAction: animSpawn];
}
-(void)snap
{
    [insprite stopAllActions];
    insprite.position = ccp(boardX, boardY);
    locked = YES;
}


- (void) dealloc
{
	[super dealloc];
}

@end
