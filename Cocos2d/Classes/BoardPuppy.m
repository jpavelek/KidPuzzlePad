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
	if( (self=[super init])) {
        Bit *b = [[Bit alloc] init:@"puppy_head.png"];
        [b setData:10 trayY:10 trayW:-1 trayH:130 boardX:412 boardY:566];
        [self addChild:b.insprite];
        [bits addObject:b];
    }
    return self;
}


@end
