//
//  BoardKitten.m
//  KidPuzzleCocosPad
//
//  Created by Jakub Pavelek on 4/2/12.
//  Copyright 2012 Afte9. All rights reserved.
//

#import "BoardKitten.h"
#import "Bit.h"


@implementation BoardKitten

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	BoardKitten *layer = [BoardKitten node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	if( (self=[super init:@"kitten_board.png"])) {
        Bit *b1 = [[Bit alloc] init:@"kitten_bunny.png"];
        [b1 setData:30 trayY:10 trayW:-1 trayH:130 boardX:152 boardY:265 z:0];
        b1.anchorPoint = CGPointMake(0.0, 1.0);
        [self addChild:b1.insprite];
        [bits addObject:b1];
        Bit *b2 = [[Bit alloc] init:@"kitten_grass.png"];
        [b2 setData:220 trayY:10 trayW:-1 trayH:130 boardX:796 boardY:265 z:0];
        [self addChild:b2.insprite];
        [bits addObject:b2];
        Bit *b3 = [[Bit alloc] init:@"kitten_head.png"];
        [b3 setData:490 trayY:10 trayW:-1 trayH:130 boardX:727 boardY:574 z:0];
        [self addChild:b3.insprite];
        [bits addObject:b3];
        Bit *b4 = [[Bit alloc] init:@"kitten_ear.png"];
        [b4 setData:695 trayY:10 trayW:-1 trayH:130 boardX:344 boardY:575 z:0];
        [self addChild:b4.insprite];
        [bits addObject:b4];
        Bit *b5 = [[Bit alloc] init:@"kitten_body.png"];
        [b5 setData:915 trayY:10 trayW:-1 trayH:130 boardX:436 boardY:331 z:0];
        [self addChild:b5.insprite];
        [bits addObject:b5];
        
        tilecount = 5;
    }
    return self;
}
@end
