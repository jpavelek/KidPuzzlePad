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
#import "BoardBBFish.h"


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
        boards = [NSArray arrayWithObjects:@"aquarium_thumb.png",
                  @"aquarium2_thumb.png",
                  @"nothing_thumb.png",
                  @"info_thumb.png",
                  @"redfish_thumb.png",
                  @"simple_puppy_thumb.png",
                  @"butterfly_thumb.png",
                  @"pets_thumb.png",
                  @"puppy_thumb.png",
                  @"bbfish_thumb.png",
                  @"kitten_thumb.png",
                  @"fish_thumb.png",
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
    switch (index) {
        case 0:
            [[CCDirector sharedDirector] pushScene: [BoardPuppy scene]];
            break;
        case 1:
            [[CCDirector sharedDirector] pushScene: [BoardPuppy scene]];
            break;
        case 2:
            NSLog(@"Do nothing");
            //[[CCDirector sharedDirector] pushScene: [BoardPuppy scene]];
            break;
        case 3:
            NSLog(@"INFO");
            //[[CCDirector sharedDirector] pushScene: [BoardPuppy scene]];
            break;
        case 4:
            [[CCDirector sharedDirector] pushScene: [BoardPuppy scene]];
            break;
        case 5:
            [[CCDirector sharedDirector] pushScene: [BoardPuppy scene]];
            break;
        case 6:
            [[CCDirector sharedDirector] pushScene: [BoardPuppy scene]];
            break;
        case 7:
            [[CCDirector sharedDirector] pushScene: [BoardPuppy scene]];
            break;
        case 8:
            [[CCDirector sharedDirector] pushScene: [BoardPuppy scene]];
            break;
        case 9:
            [[CCDirector sharedDirector] pushScene: [BoardBBFish scene]];
            break;
        case 10:
            [[CCDirector sharedDirector] pushScene: [BoardPuppy scene]];
            break;
        case 11:
            [[CCDirector sharedDirector] pushScene: [BoardPuppy scene]];
            break;
        default:
            break;
    }
    return YES;
}


@end

