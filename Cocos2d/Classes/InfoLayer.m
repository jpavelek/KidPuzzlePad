//
//  InfoLayer.m
//  KidPuzzleCocosPad
//
//  Created by Jakub Pavelek on 4/4/12.
//  Copyright 2012 Afte9. All rights reserved.
//

#import "InfoLayer.h"
#import "CCTouchDispatcher.h"

@implementation InfoLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	InfoLayer *layer = [InfoLayer node];
	[scene addChild: layer];
	return scene;
}


-(id) init
{
	if( (self=[super init])) {
        bg = [CCSprite spriteWithFile: @"fabric.png"];
        bg.anchorPoint = CGPointMake(0.0, 0.0);
        [self addChild: bg];
        
        back = [CCSprite spriteWithFile: @"back.png"];
        back.position = ccp(1024 - back.contentSize.width/2, 768 - back.contentSize.height/2);
        [self addChild: back];
        [self reorderChild:back z:150];
        
        happy = [CCSprite spriteWithFile:@"smiley_happy.png"];
        happy.position = ccp(700, 430);
        [self addChild:happy];
        
        sad = [CCSprite spriteWithFile:@"smiley_sad.png"];
        sad.position = ccp(300, 430);
        [self addChild:sad];
        
        home = [CCSprite spriteWithFile:@"home.png"];
        home.position = ccp(512, 100);
        [self addChild:home];
        
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
    if (CGRectContainsPoint(back.boundingBox, location)) {
        [[CCDirector sharedDirector] popScene];
    } else if (CGRectContainsPoint(happy.boundingBox, location)) {
        NSString *str = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa";
        str = [NSString stringWithFormat:@"%@/wa/viewContentsUserReviews?", str]; 
        str = [NSString stringWithFormat:@"%@type=Purple+Software&id=", str];
        str = [NSString stringWithFormat:@"%@516942630", str]; 
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    } else if (CGRectContainsPoint(sad.boundingBox, location)) {
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"https://github.com/jpavelek/KidPuzzle/issues"]];
    } else {
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"http://www.afte9.com"]];
    }
    return YES;
}

@end
