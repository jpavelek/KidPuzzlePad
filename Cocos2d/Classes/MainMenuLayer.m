//
//  MainMenuLayer.m
//  KidPuzzleCocosPad
//
//  Created by Jakub Pavelek on 3/31/12.
//  Copyright 2012 Afte9. All rights reserved.
//

#import "CCTouchDispatcher.h"
#import "MainMenuLayer.h"
#import "BoardPuppy.h"


@implementation MainMenuLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	MainMenuLayer *layer = [MainMenuLayer node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
        boards = [NSArray arrayWithObjects:@"puppy_thumb.png",
                  @"kitten_thumb.png",
                  @"puppy_thumb.png",
                  @"kitten_thumb.png",
                  @"puppy_thumb.png",
                  @"kitten_thumb.png",
                  @"puppy_thumb.png",
                  @"kitten_thumb.png",
                  @"puppy_thumb.png",
                  @"kitten_thumb.png",
                  @"puppy_thumb.png",
                  @"kitten_thumb.png",
                  nil];
        CCSprite* bg = [CCSprite spriteWithFile: @"fabric.png"];
        bg.anchorPoint =  CGPointMake(0.0, 0.0);
        bg.position = ccp(0,0);
        [self addChild: bg];
        
        for (int i=0; i<12; i++) {
            int x,y;
            x = (i%4)*256;
            y = (i/4)*256;
            CCSprite* p;
            p = [CCSprite spriteWithFile:[boards objectAtIndex:i]];
            p.anchorPoint = CGPointMake(0.0, 0.0);
            p.position = ccp(x,y);
            p.opacity = 0.0;
            [self addChild:p];
            id opacity = [CCActionTween actionWithDuration:(0.2 + 0.2*(random()%10)) key:@"opacity" from:0.5 to:255];
            [p runAction: opacity];
        }
        self.isTouchEnabled = YES;
    }
    return self;
}

-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [self convertTouchToNodeSpace: touch];
    int index = 4*(((int)location.y)/256) + ((int)location.x)/256;
    NSLog(@"Index %d", index);
    [[CCDirector sharedDirector] pushScene: [BoardPuppy scene]];
    return YES;
}


@end

