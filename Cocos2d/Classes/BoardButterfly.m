//
//  BoardButterfly.m
//  KidPuzzleCocosPad
//
//  Created by Jakub Pavelek on 4/2/12.
//  Copyright 2012 Afte9. All rights reserved.
//

#import "BoardButterfly.h"
#import "Bit.h"

@implementation BoardButterfly

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	BoardButterfly *layer = [BoardButterfly node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	if( (self=[super init:@"butterfly_board.png"])) {
        Bit *b1 = [[Bit alloc] init:@"butterfly_right_bottom.png"];
        [b1 setData:100 trayY:10 trayW:-1 trayH:130 boardX:627 boardY:370 z:0];
        [self addChild:b1.insprite];
        [bits addObject:b1];
        Bit *b2 = [[Bit alloc] init:@"butterfly_left_bottom.png"];
        [b2 setData:350 trayY:10 trayW:-1 trayH:130 boardX:507 boardY:305 z:2];
        [self addChild:b2.insprite];
        [bits addObject:b2];
        Bit *b3 = [[Bit alloc] init:@"butterfly_left_top.png"];
        [b3 setData:600 trayY:10 trayW:-1 trayH:130 boardX:303 boardY:326 z:3];
        [self addChild:b3.insprite];
        [bits addObject:b3];
        Bit *b4 = [[Bit alloc] init:@"butterfly_right_top.png"];
        [b4 setData:850 trayY:10 trayW:-1 trayH:130 boardX:662 boardY:617 z:1];
        [self addChild:b4.insprite];
        [bits addObject:b4];
        
        tilecount = 4;
    }
    return self;
}

@end
