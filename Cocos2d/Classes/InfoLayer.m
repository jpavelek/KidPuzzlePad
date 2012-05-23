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


int
downloadPromos(void) 
{
    NSURL *url = [NSURL URLWithString:@"http://www.afte9.com/promo/com.afte9.puzzlefortoddlers/promo.txt"];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if ([urlData length] < 1) {
        NSLog(@"Did not receive any promos");
        return 0;
    } else NSLog(@"Got %d of data", [urlData length]);
    
    NSLog(@"Got promos");
    
    NSData *version = [urlData valueForKey:@"version"];
    NSData *count = [urlData valueForKey:@"count"];
    NSString *vs = [NSString stringWithCString:[version bytes] encoding:NSUTF8StringEncoding];
    NSString *cs = [NSString stringWithCString:[count bytes] encoding:NSUTF8StringEncoding];
    NSLog(@"Got version %@ and count %@", vs, cs);
    
    return 3; //FIXME
}


-(id) init
{
	if( (self=[super init])) {
        promos = [[NSMutableArray alloc] init];
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
        
        int promocount = downloadPromos();
        int promowidth = 167;
        int margin = (1024 - ((promocount +1)*promowidth))/(2+promocount);

        home = [CCSprite spriteWithFile:@"home.png"];
        home.anchorPoint = CGPointMake(0.0, 0.0);
        home.position = ccp(margin, 50);
        [self addChild:home];
        
        CCSprite* p1 = [CCSprite spriteWithFile:@"promo1.png"];
        p1.anchorPoint = CGPointMake(0.0, 0.0);
        p1.position = ccp(2*margin+promowidth,50);
        [self addChild:p1];
        [promos addObject:p1];
        
        CCSprite* p2 = [CCSprite spriteWithFile:@"promo2.png"];
        p2.position = ccp(3*margin+2*promowidth,50);
        p2.anchorPoint = CGPointMake(0.0, 0.0);
        [self addChild:p2];
        [promos addObject:p2];
        
        CCSprite* p3 = [CCSprite spriteWithFile:@"promo3.png"];
        p3.anchorPoint = CGPointMake(0.0, 0.0);
        p3.position = ccp(4*margin+3*promowidth,50);
        [self addChild:p3];
        [promos addObject:p3];
        
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
    } else if (CGRectContainsPoint(home.boundingBox, location)) {
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"http://www.afte9.com"]];
    } else {
        NSLog(@"Test promos");
        for (CCSprite *s in promos) {
            if (CGRectContainsPoint(s.boundingBox, location)) {
                NSLog(@"Clicked promo ");
                break;
            }
        }
    }
    return YES;
}

@end
