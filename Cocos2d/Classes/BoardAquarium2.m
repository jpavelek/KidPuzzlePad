//
//  BoardAquarium.m
//  KidPuzzleCocosPad
//
//  Created by Jakub Pavelek on 4/2/12.
//  Copyright 2012 Afte9. All rights reserved.
//

#import "BoardAquarium2.h"
#import "Bit.h"

@implementation BoardAquarium2

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	BoardAquarium2* layer = [BoardAquarium2 node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	if( (self=[super init:@"aquarium2_board.png"])) {
        Bit *b1 = [[Bit alloc] init:@"a2_fish.png"];
        [b1 setData:50 trayY:10 trayW:-1 trayH:130 boardX:256 boardY:322 z:0];
        b1.anchorPoint = CGPointMake(0.0, 1.0);
        [self addChild:b1.insprite];
        [bits addObject:b1];
        Bit *b2 = [[Bit alloc] init:@"a2_jellyfish.png"];
        [b2 setData:230 trayY:10 trayW:-1 trayH:130 boardX:256 boardY:606 z:0];
        [self addChild:b2.insprite];
        [bits addObject:b2];
        Bit *b3 = [[Bit alloc] init:@"a2_redfish.png"];
        [b3 setData:350 trayY:40 trayW:250 trayH:-1 boardX:644 boardY:658 z:0];
        [self addChild:b3.insprite];
        [bits addObject:b3];
        Bit *b4 = [[Bit alloc] init:@"a2_star.png"];
        [b4 setData:630 trayY:10 trayW:-1 trayH:130 boardX:637 boardY:262 z:0];
        [self addChild:b4.insprite];
        [bits addObject:b4];
        Bit *b5 = [[Bit alloc] init:@"a2_yellow.png"];
        [b5 setData:800 trayY:10 trayW:-1 trayH:130 boardX:836 boardY:497 z:0];
        [self addChild:b5.insprite];
        [bits addObject:b5];
        
        tilecount = 5;
    }
    return self;
}


@end
