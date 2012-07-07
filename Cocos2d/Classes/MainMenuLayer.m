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
#import "BoardKitten.h"
#import "BoardFish.h"
#import "BoardRedfish.h"
#import "BoardSimplePuppy.h"
#import "BoardButterfly.h"
#import "BoardPets.h"
#import "BoardAquarium.h"
#import "BoardAquarium2.h"
#import "InfoLayer.h"
#if defined (FREE_VERSION)
#import <StoreKit/StoreKit.h>
#import "FullVersionIAHelper.h"
#import "Reachability.h"
#endif

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
#if defined(FREE_VERSION)
        NSLog(@"FREE");
        fullgame = NO;
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"com.afte9.puzzlefortoddlersFREEfull"] == YES) {
            NSLog(@"The key is set to TRUE in settings - FULL version");
        } else {
            NSLog(@"The key is set to FALSE in settings - FREE version");
        }

#else
#if defined(FULL_VERSION)
        NSLog(@"FULL version");
        fullgame = YES;
#else
        NSLog(@"ERROR - not sure what version this is!");
        fullgame = NO;
#endif
#endif
        boards = [NSArray arrayWithObjects:@"aquarium_thumb.png",
                  @"bbfish_thumb.png",
                  @"nothing_thumb.png",
                  @"info_thumb.png",
                  @"redfish_thumb.png",
                  @"simple_puppy_thumb.png",
                  @"butterfly_thumb.png",
                  @"pets_thumb.png",
                  @"puppy_thumb.png",
                  @"aquarium2_thumb.png",
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
            if (fullgame == NO) {
                if ((i%4 != 0) && (i!=2) && (i!=3)) { 
                    CCSprite* o = [CCSprite spriteWithFile:@"lock_overlay_thumb.png"];
                    o.anchorPoint =  CGPointMake(0.0, 0.0);
                    o.position = p.positionInPixels;
                    [self addChild: o];
                }
            }
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
    switch (index) {
        case 0:
            [[CCDirector sharedDirector] pushScene: [BoardAquarium scene]];
            break;
        case 1:
            if (fullgame == YES) [[CCDirector sharedDirector] pushScene: [BoardBBFish scene]]; else [self goPurchase];
            break;
        case 2:
            NSLog(@"Do nothing");
            break;
        case 3:
            [[CCDirector sharedDirector] pushScene: [InfoLayer scene]];
            break;
        case 4:
            [[CCDirector sharedDirector] pushScene: [BoardRedfish scene]];
            break;
        case 5:
            if (fullgame == YES) [[CCDirector sharedDirector] pushScene: [BoardSimplePuppy scene]]; else [self goPurchase];
            break;
        case 6:
            if (fullgame == YES) [[CCDirector sharedDirector] pushScene: [BoardButterfly scene]]; else [self goPurchase];
            break;
        case 7:
            if (fullgame == YES) [[CCDirector sharedDirector] pushScene: [BoardPets scene]]; else [self goPurchase];
            break;
        case 8:
            [[CCDirector sharedDirector] pushScene: [BoardPuppy scene]];
            break;
        case 9:
            if (fullgame == YES) [[CCDirector sharedDirector] pushScene: [BoardAquarium2 scene]]; else [self goPurchase];
            break;
        case 10:
            if (fullgame == YES) [[CCDirector sharedDirector] pushScene: [BoardKitten scene]]; else [self goPurchase];
            break;
        case 11:
            if (fullgame == YES) [[CCDirector sharedDirector] pushScene: [BoardFish scene]]; else [self goPurchase];
            break;
        default:
            break;
    }
    return YES;
}

-(void) goPurchase {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsLoaded:) name:kProductsLoadedNotification object:nil];
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];	
    NetworkStatus netStatus = [reach currentReachabilityStatus];    
    if (netStatus == NotReachable) {        
        NSLog(@"Abort - No internet connection!");        
    } else {
        NSLog(@"Internet connection available");
        if ([FullVersionIAHelper sharedHelper].products == nil) {
            [[FullVersionIAHelper sharedHelper] requestProducts];
        }  else {
            SKProduct *product = [[FullVersionIAHelper sharedHelper].products objectAtIndex:0];
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            NSLog(@"Products already loaded - lets buy %@", product.productIdentifier);
            [[FullVersionIAHelper sharedHelper] buyProductIdentifier:product.productIdentifier];
        }
    }
}


- (void)productsLoaded:(NSNotification *)notification {
    SKProduct *product = [[FullVersionIAHelper sharedHelper].products objectAtIndex:0];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    NSLog(@"@productsLoaded - lets buy %@", product.productIdentifier);
    [[FullVersionIAHelper sharedHelper] buyProductIdentifier:product.productIdentifier];
    
}


- (void)productPurchased:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];  
    
    NSString *productIdentifier = (NSString *) notification.object;
    NSLog(@"Purchased: %@", productIdentifier);
    NSLog(@"Saved to setings, turning on the full version");
    fullgame = true;
    //TODO call completeTransaction
    
    //Reload the scene - now as FULL version
    [[CCDirector sharedDirector] replaceScene:[MainMenuLayer scene]];
}

@end

