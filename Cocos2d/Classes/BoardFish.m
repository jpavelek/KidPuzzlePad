//
//  BoardFish.m
//  KidPuzzleCocosPad
//
//  Created by Jakub Pavelek on 4/2/12.
//  Copyright 2012 Afte9. All rights reserved.
//

#import "BoardFish.h"
#import "BoardFish.h"

@implementation BoardFish

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	BoardFish *layer = [BoardFish node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	if( (self=[super init:@"fish_board.png"])) {
        Bit *b1 = [[Bit alloc] init:@"fish_left.png"];
        [b1 setData:30 trayY:10 trayW:-1 trayH:130 boardX:155 boardY:459 z:0];
        b1.anchorPoint = CGPointMake(0.0, 1.0);
        [self addChild:b1.insprite];
        [bits addObject:b1];
        Bit *b2 = [[Bit alloc] init:@"fish_fin.png"];
        [b2 setData:90 trayY:10 trayW:-1 trayH:130 boardX:786 boardY:458 z:0];
        [self addChild:b2.insprite];
        [bits addObject:b2];
        Bit *b3 = [[Bit alloc] init:@"fish_bottom.png"];
        [b3 setData:230 trayY:10 trayW:-1 trayH:130 boardX:676 boardY:254 z:0];
        [self addChild:b3.insprite];
        [bits addObject:b3];
        Bit *b4 = [[Bit alloc] init:@"fish_head.png"];
        [b4 setData:400 trayY:10 trayW:-1 trayH:130 boardX:310 boardY:613 z:0];
        [self addChild:b4.insprite];
        [bits addObject:b4];
        Bit *b5 = [[Bit alloc] init:@"fish_center.png"];
        [b5 setData:600 trayY:10 trayW:-1 trayH:130 boardX:479 boardY:530 z:0];
        [self addChild:b5.insprite];
        [bits addObject:b5];
        Bit *b6 = [[Bit alloc] init:@"fish_bottom_left.png"];
        [b6 setData:800 trayY:10 trayW:-1 trayH:130 boardX:241 boardY:254 z:0];
        [self addChild:b6.insprite];
        [bits addObject:b6];
        
        tilecount = 6;
    }
    return self;
}

@end
