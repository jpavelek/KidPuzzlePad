//
//  BoardRedfish.m
//  KidPuzzleCocosPad
//
//  Created by Jakub Pavelek on 4/2/12.
//  Copyright 2012 Afte9. All rights reserved.
//

#import "BoardRedfish.h"
#import "Bit.h"

@implementation BoardRedfish

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	BoardRedfish *layer = [BoardRedfish node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	if( (self=[super init:@"redfish_board.png"])) {
        Bit *b1 = [[Bit alloc] init:@"redfish_frontsection.png"];
        [b1 setData:100 trayY:10 trayW:-1 trayH:130 boardX:441 boardY:437 z:0];
        b1.anchorPoint = CGPointMake(0.0, 1.0);
        [self addChild:b1.insprite];
        [bits addObject:b1];
        Bit *b2 = [[Bit alloc] init:@"redfish_tail.png"];
        [b2 setData:250 trayY:10 trayW:-1 trayH:130 boardX:833 boardY:430 z:0];
        [self addChild:b2.insprite];
        [bits addObject:b2];
        Bit *b3 = [[Bit alloc] init:@"redfish_head.png"];
        [b3 setData:450 trayY:10 trayW:-1 trayH:130 boardX:264 boardY:431 z:0];
        [self addChild:b3.insprite];
        [bits addObject:b3];
        Bit *b4 = [[Bit alloc] init:@"redfish_tailsection.png"];
        [b4 setData:650 trayY:10 trayW:-1 trayH:130 boardX:623 boardY:446 z:0];
        [self addChild:b4.insprite];
        [bits addObject:b4];
        Bit *b5 = [[Bit alloc] init:@"redfish_fin.png"];
        [b5 setData:800 trayY:40 trayW:-1 trayH: 50 boardX:621 boardY:349 z:0];
        [self addChild:b5.insprite];
        [bits addObject:b5];
        
        tilecount = 5;
    }
    return self;
}

@end
