//
//  BoardPuppy.m
//  KidPuzzleCocosPad
//
//  Created by Jakub Pavelek on 3/30/12.
//  Copyright 2012 Afte9. All rights reserved.
//

#import "BoardPuppy.h"
#import "Bit.h"


@implementation BoardPuppy

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	BoardPuppy *layer = [BoardPuppy node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	if( (self=[super init:@"puppy_board.png"])) {
        Bit *b1 = [[Bit alloc] init:@"puppy_head.png"];
        [b1 setData:10 trayY:10 trayW:-1 trayH:130 boardX:412 boardY:566 z:5];
        [self addChild:b1.insprite];
        [bits addObject:b1];
        Bit *b2 = [[Bit alloc] init:@"puppy_ball.png"];
        [b2 setData:150 trayY:10 trayW:-1 trayH:130 boardX:236 boardY:304 z:6];
        [self addChild:b2.insprite];
        [bits addObject:b2];
        Bit *b3 = [[Bit alloc] init:@"puppy_legs.png"];
        [b3 setData:290 trayY:10 trayW:-1 trayH:130 boardX:486 boardY:362 z:3];
        [self addChild:b3.insprite];
        [bits addObject:b3];
        Bit *b4 = [[Bit alloc] init:@"puppy_torso.png"];
        [b4 setData:430 trayY:10 trayW:130 trayH:-1 boardX:638 boardY:494 z:2];
        [self addChild:b4.insprite];
        [bits addObject:b4];
        Bit *b5 = [[Bit alloc] init:@"puppy_back_leg.png"];
        [b5 setData:570 trayY:10 trayW:130 trayH:-1 boardX:645 boardY:306 z:0];
        [self addChild:b5.insprite];
        [bits addObject:b5];
        Bit *b6 = [[Bit alloc] init:@"puppy_tail.png"];
        [b6 setData:710 trayY:10 trayW:130 trayH:-1 boardX:898 boardY:484 z:1];
        [self addChild:b6.insprite];
        [bits addObject:b6];
        Bit *b7 = [[Bit alloc] init:@"puppy_leg.png"];
        [b7 setData:850 trayY:10 trayW:-1 trayH:130 boardX:822 boardY:366 z:4];
        [self addChild:b7.insprite];
        [bits addObject:b7];
        tilecount = 7;
    }
    return self;
}


@end
