//
//  BoardSimplePuppy.m
//  KidPuzzleCocosPad
//
//  Created by Jakub Pavelek on 4/2/12.
//  Copyright 2012 Afte9. All rights reserved.
//

#import "BoardSimplePuppy.h"
#import "Bit.h"


@implementation BoardSimplePuppy

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	BoardSimplePuppy *layer = [BoardSimplePuppy node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	if( (self=[super init:@"simplepuppy_board.png"])) {
        Bit *b1 = [[Bit alloc] init:@"simplepuppy_ball.png"];
        [b1 setData:100 trayY:10 trayW:-1 trayH:130 boardX:891 boardY:242 z:0];
        [self addChild:b1.insprite];
        [bits addObject:b1];
        Bit *b2 = [[Bit alloc] init:@"simplepuppy_back.png"];
        [b2 setData:350 trayY:10 trayW:-1 trayH:130 boardX:320 boardY:352 z:2];
        [self addChild:b2.insprite];
        [bits addObject:b2];
        Bit *b3 = [[Bit alloc] init:@"simplepuppy_head.png"];
        [b3 setData:600 trayY:10 trayW:-1 trayH:130 boardX:692 boardY:508 z:3];
        [self addChild:b3.insprite];
        [bits addObject:b3];
        Bit *b4 = [[Bit alloc] init:@"simplepuppy_front.png"];
        [b4 setData:850 trayY:10 trayW:-1 trayH:130 boardX:606 boardY:383 z:1];
        [self addChild:b4.insprite];
        [bits addObject:b4];
        
        tilecount = 4;
    }
    return self;
}


@end
