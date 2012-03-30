//
//  GameLayer.m
//  KidPuzzleCocosPad
//
//  Created by Jakub Pavelek on 3/28/12.
//  Copyright Afte9 2012. All rights reserved.
//


#import "GameLayer.h"
#import "CCTouchDispatcher.h"
#import "Bit.h"

@implementation GameLayer

NSMutableArray* bits;
Bit *currentBit;
CCSprite *back;

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	GameLayer *layer = [GameLayer node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
        CCSprite *bg;
        bg = [CCSprite spriteWithFile: @"puppy_board.png"];
        bg.anchorPoint = CGPointMake(0, 0);
        [self addChild: bg];
        
        CCSprite *tray;
        tray = [CCSprite spriteWithFile: @"tray.png"];
        tray.anchorPoint =  CGPointMake(0, 0);
        [self addChild: tray];
        
        back = [CCSprite spriteWithFile: @"back.png"];
        back.position = ccp(1024 - back.contentSize.width/2, 768 - back.contentSize.height/2);
        [self addChild: back];
        
        bits = [[NSMutableArray alloc] init];
        /*
         * Here, setup the gameboard for real
         */
        
        self.isTouchEnabled = YES;
	}
    NSLog(@"Done with GameLayer");
	return self;
}


- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch) {
        CGPoint location = [self convertTouchToNodeSpace: touch];
        currentBit = nil;
        for (Bit *bit in bits) {
            if (CGRectContainsPoint(bit.insprite.boundingBox, location)) {
                currentBit = bit;
                if (bit.locked == NO) {
                    [bit pop];
                    [self ccTouchesMoved:touches withEvent:event];
                } else {
                    NSLog(@"This bit is already locked");
                }

            }
        }
        if (CGRectContainsPoint(back.boundingBox, location)) {
            NSLog(@"Back pressed");
        }
    }
}


- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (currentBit.locked == YES) return;
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView: [touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
    [currentBit.insprite setPosition: touchLocation];

}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ((currentBit == nil) || (currentBit.locked == YES)) return;
    for( UITouch *touch in touches ) {
        CGPoint location = [touch locationInView: [touch view]];
        NSLog(@"%d %d vs %d %d", (int)currentBit.insprite.positionInPixels.x, (int)currentBit.insprite.positionInPixels.y, (int)currentBit.boardX, (int)currentBit.boardY);
        location = [[CCDirector sharedDirector] convertToGL: location];
        if ((abs(currentBit.insprite.positionInPixels.x - currentBit.boardX) + abs(currentBit.insprite.positionInPixels.y - currentBit.boardY)) <= 150) {
            [currentBit snap];
        } else {
            NSLog(@"Too far");
            [currentBit back];
        }
    }
}

- (void) dealloc
{
	[super dealloc];
}
@end
