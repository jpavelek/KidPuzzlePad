//
//  GameLayer.m
//  KidPuzzleCocosPad
//
//  Created by Jakub Pavelek on 3/28/12.
//  Copyright Afte9 2012. All rights reserved.
//


#import "GameLayer.h"
#import "CCTouchDispatcher.h"
#import "SimpleAudioEngine.h"
#import "Bit.h"

@implementation GameLayer

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
        bg.anchorPoint = CGPointMake(0.0, 0.0);
        [self addChild: bg];
        
        tray = [CCSprite spriteWithFile: @"tray.png"];
        tray.anchorPoint =  CGPointMake(0.0, 1.0);
        tray.position = ccp(0 ,150);
        [self addChild: tray];
        
        back = [CCSprite spriteWithFile: @"back.png"];
        back.position = ccp(1024 - back.contentSize.width/2, 768 - back.contentSize.height/2);
        [self addChild: back];
        
        bits = [[NSMutableArray alloc] init];
        balloons = [[NSMutableArray alloc] init];
        
        self.isTouchEnabled = YES;
        placedTiles = 0;
        tilecount = -1;
	}
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
                    [self reorderChild:bit.insprite z:bit.zorder+100];
                    [self ccTouchesMoved:touches withEvent:event];
                } 
            }
        }
        if (CGRectContainsPoint(back.boundingBox, location)) {
            [[CCDirector sharedDirector] popScene];
        }
        for (CCSprite *s in balloons) {
            if (CGRectContainsPoint(s.boundingBox, location)) {
                [[SimpleAudioEngine sharedEngine] playEffect:@"pop.wav"];
                [s removeFromParentAndCleanup:YES];
                [balloons removeObject:s];
                break;
            }
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
            placedTiles++;
            if (placedTiles == tilecount) {
                NSLog(@"END GAME");
                [self popBalloons];
            }
        } else {
            [currentBit back];
        }
    }
    [self reorderChild:currentBit.insprite z:currentBit.zorder];
}

- (void) popBalloons
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"app-6.wav"];
    NSArray* ballColors = [NSArray arrayWithObjects:@"baloon_blue.png",@"baloon_green.png",@"baloon_red.png",@"baloon_yellow.png",nil];
    for (int i=0; i<15; i++) {
        int cIndex = random()%4;
        CCSprite* s = [CCSprite spriteWithFile:[ballColors objectAtIndex:cIndex]];
        int bx = 32 + random()%950;
        s.position = ccp(bx, 1 - s.boundingBox.size.height/2 - random()%300);
        [balloons addObject:s];
        [self addChild:s];
        [self reorderChild:s z:150];
        
        CGPoint r = CGPointMake(bx, 768 + s.boundingBox.size.height);
        id baloonMove = [CCMoveTo actionWithDuration: (7 + random()%15) position: r];
        [s runAction: baloonMove];
    }
    id actionTraySlideout = [CCMoveTo actionWithDuration: 1.0 position: CGPointMake(0, 0)];
    [tray runAction: [CCEaseInOut actionWithAction: [[actionTraySlideout copy] autorelease] rate: 5.0f]];
}


- (void) dealloc
{
	[super dealloc];
}
@end
