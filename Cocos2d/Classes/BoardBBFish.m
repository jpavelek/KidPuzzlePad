//
//  BoardBBFish.m
//  KidPuzzleCocosPad
//
//  Created by Jakub Pavelek on 4/2/12.
//  Copyright 2012 Afte9. All rights reserved.
//

#import "BoardBBFish.h"
#import "Bit.h"

@implementation BoardBBFish

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	BoardBBFish *layer = [BoardBBFish node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	if( (self=[super init:@"bbfish_board.png"])) {
        Bit *b1 = [[Bit alloc] init:@"bbfish_tail.png"];
        [b1 setData:70 trayY:10 trayW:-1 trayH:130 boardX:227 boardY:458 z:0];
        b1.anchorPoint = CGPointMake(0.0, 1.0);
        [self addChild:b1.insprite];
        [bits addObject:b1];
        Bit *b2 = [[Bit alloc] init:@"bbfish_head.png"];
        [b2 setData:160 trayY:10 trayW:-1 trayH:130 boardX:787 boardY:278 z:0];
        [self addChild:b2.insprite];
        [bits addObject:b2];
        Bit *b3 = [[Bit alloc] init:@"bbfish_fin.png"];
        [b3 setData:420 trayY:10 trayW:-1 trayH:130 boardX:275 boardY:539 z:0];
        [self addChild:b3.insprite];
        [bits addObject:b3];
        Bit *b4 = [[Bit alloc] init:@"bbfish_belly.png"];
        [b4 setData:510 trayY:10 trayW:-1 trayH:130 boardX:464 boardY:278 z:0];
        [self addChild:b4.insprite];
        [bits addObject:b4];
        Bit *b5 = [[Bit alloc] init:@"bbfish_forehead.png"];
        [b5 setData:800 trayY:10 trayW:-1 trayH:130 boardX:787 boardY:587 z:0];
        [self addChild:b5.insprite];
        [bits addObject:b5];

        tilecount = 5;
    }
    return self;
}


@end
