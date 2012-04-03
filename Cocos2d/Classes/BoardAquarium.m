//
//  BoardAquarium.m
//  KidPuzzleCocosPad
//
//  Created by Jakub Pavelek on 4/2/12.
//  Copyright 2012 Afte9. All rights reserved.
//

#import "BoardAquarium.h"
#import "Bit.h"

@implementation BoardAquarium

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	BoardAquarium *layer = [BoardAquarium node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	if( (self=[super init:@"aquarium_board.png"])) {
        Bit *b1 = [[Bit alloc] init:@"a_fish.png"];
        [b1 setData:50 trayY:10 trayW:-1 trayH:130 boardX:887 boardY:366 z:0];
        b1.anchorPoint = CGPointMake(0.0, 1.0);
        [self addChild:b1.insprite];
        [bits addObject:b1];
        Bit *b2 = [[Bit alloc] init:@"a_jellyfish.png"];
        [b2 setData:230 trayY:10 trayW:-1 trayH:130 boardX:730 boardY:601 z:0];
        [self addChild:b2.insprite];
        [bits addObject:b2];
        Bit *b3 = [[Bit alloc] init:@"a_redfish.png"];
        [b3 setData:350 trayY:40 trayW:250 trayH:-1 boardX:197 boardY:392 z:0];
        [self addChild:b3.insprite];
        [bits addObject:b3];
        Bit *b4 = [[Bit alloc] init:@"a_star.png"];
        [b4 setData:630 trayY:10 trayW:-1 trayH:130 boardX:517 boardY:272 z:0];
        [self addChild:b4.insprite];
        [bits addObject:b4];
        Bit *b5 = [[Bit alloc] init:@"a_yellow.png"];
        [b5 setData:800 trayY:10 trayW:-1 trayH:130 boardX:312 boardY:661 z:0];
        [self addChild:b5.insprite];
        [bits addObject:b5];
        
        tilecount = 5;
    }
    return self;
}


@end
