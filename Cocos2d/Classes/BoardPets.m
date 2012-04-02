//
//  BoardPets.m
//  KidPuzzleCocosPad
//
//  Created by Jakub Pavelek on 4/2/12.
//  Copyright 2012 Afte9. All rights reserved.
//

#import "BoardPets.h"
#import "Bit.h"


@implementation BoardPets

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	BoardPets *layer = [BoardPets node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	if( (self=[super init:@"pets_board.png"])) {
        Bit *b1 = [[Bit alloc] init:@"pets_bunny.png"];
        [b1 setData:100 trayY:10 trayW:-1 trayH:130 boardX:338 boardY:343 z:0];
        [self addChild:b1.insprite];
        [bits addObject:b1];
        Bit *b2 = [[Bit alloc] init:@"pets_puppy.png"];
        [b2 setData:350 trayY:10 trayW:-1 trayH:130 boardX:737 boardY:628 z:2];
        [self addChild:b2.insprite];
        [bits addObject:b2];
        Bit *b3 = [[Bit alloc] init:@"pets_butterfly.png"];
        [b3 setData:600 trayY:10 trayW:-1 trayH:130 boardX:251 boardY:654 z:3];
        [self addChild:b3.insprite];
        [bits addObject:b3];
        Bit *b4 = [[Bit alloc] init:@"pets_kitten.png"];
        [b4 setData:850 trayY:10 trayW:-1 trayH:130 boardX:822 boardY:326 z:1];
        [self addChild:b4.insprite];
        [bits addObject:b4];
        
        tilecount = 4;
    }
    return self;
}

@end
