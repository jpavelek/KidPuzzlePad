//
//  FullUpgrade.m
//  KidPuzzleCocosPad
//
//  Created by Jakub Pavelek on 7/8/12.
//  Copyright 2012 Afte9. All rights reserved.
//

#import "FullUpgrade.h"
#import <StoreKit/StoreKit.h>
#import "FullVersionIAHelper.h"
#import "Reachability.h"

#import "MainMenuLayer.h"

#define kOpacityOff 20
#define kStatusHeight 100

typedef enum {eConnecting, eProducts, ePurchase, eDone} EStates;


@implementation FullUpgrade


+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	FullUpgrade *layer = [FullUpgrade node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
        back = [CCSprite spriteWithFile: @"back.png"];
        back.position = ccp(1024 - back.contentSize.width/2, 768 - back.contentSize.height/2);
        [self addChild: back];
        [self reorderChild:back z:150];
        self.isTouchEnabled = YES;
        
        sconnect = [CCSprite spriteWithFile: @"connect_64x64.png"];
        sconnect.position = ccp(512-3*64-32, kStatusHeight);
        sconnect.opacity = kOpacityOff;
        [self addChild: sconnect];
        
        sproducts = [CCSprite spriteWithFile: @"products_64x64.png"];
        sproducts.position = ccp(512-64-32, kStatusHeight);
        sproducts.opacity = kOpacityOff;
        [self addChild: sproducts];
        
        spurchase = [CCSprite spriteWithFile: @"purchase_64x64.png"];
        spurchase.position = ccp(512+32, kStatusHeight);
        spurchase.opacity = kOpacityOff;
        [self addChild: spurchase];
        
        sdone = [CCSprite spriteWithFile: @"done_64x64.png"];
        sdone.position = ccp(512+2*64+32, kStatusHeight);
        sdone.opacity = kOpacityOff;
        [self addChild: sdone];
          
        //Now, init the purchase right away
        [self setProgress:eConnecting];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsLoaded:) name:kProductsLoadedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:kProductPurchasedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchaseFailed:) name:kProductPurchaseFailedNotification object: nil];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:[FullVersionIAHelper sharedHelper]];
        
        Reachability *reach = [Reachability reachabilityForInternetConnection];	
        NetworkStatus netStatus = [reach currentReachabilityStatus];    
        if (netStatus == NotReachable) {        
            NSLog(@"Abort - No internet connection!");  
            //TODO play unhappy sound, blink, etc.
        } else {
            [self setProgress:eProducts];
            if ([FullVersionIAHelper sharedHelper].products == nil) {
                [[FullVersionIAHelper sharedHelper] requestProducts];
            }  else {
                [self setProgress:ePurchase];
                SKProduct *product = [[FullVersionIAHelper sharedHelper].products objectAtIndex:0];
                [NSObject cancelPreviousPerformRequestsWithTarget:self];
                NSLog(@"Products already loaded - lets buy %@ right away", product.productIdentifier);
                [[FullVersionIAHelper sharedHelper] buyProductIdentifier:product.productIdentifier];
            }
        }
    }
    return self;
}

- (void)productsLoaded:(NSNotification *)notification {
    [self setProgress:ePurchase];
    SKProduct *product = [[FullVersionIAHelper sharedHelper].products objectAtIndex:0];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    NSLog(@"@productsLoaded - lets buy %@ right away", product.productIdentifier);
    [[FullVersionIAHelper sharedHelper] buyProductIdentifier:product.productIdentifier];
}

- (void)productPurchased:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];  
    
    NSString *productIdentifier = (NSString *) notification.object;
    NSLog(@"Purchased: %@", productIdentifier);
    NSLog(@"Saved to setings, turning on the full version");
    //TODO - should we call completeTransaction here?
    
    //Reload the scene - now as FULL version
    [[CCDirector sharedDirector] replaceScene:[MainMenuLayer scene]];
}

- (void)productPurchaseFailed:(NSNotification *)notification {
    NSLog(@"TODO - purchase fail not implemented on UI level yet");
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch) {
        CGPoint location = [self convertTouchToNodeSpace: touch];
        
        if (CGRectContainsPoint(back.boundingBox, location)) {
            NSLog(@"BACK - releasing");
            [[SKPaymentQueue defaultQueue] removeTransactionObserver:[FullVersionIAHelper sharedHelper]];
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            
            [[CCDirector sharedDirector] replaceScene: [MainMenuLayer scene]];  
            return;
        } 
    }
}


//Little helper to animate the progress of IAP
- (void) setProgress: (EStates) p 
{
    [sconnect stopAllActions];
    [sproducts stopAllActions];
    [spurchase stopAllActions];
    [sdone stopAllActions];
    id opacityUp = [CCActionTween actionWithDuration:1.0 key:@"opacity" from:0 to:255];
    id opacityUpEased = [CCEaseInOut actionWithAction:opacityUp rate: 5.0f];
    id opacityDown = [CCActionTween actionWithDuration:0.4 key:@"opacity" from:255 to:0];
    id opacityPulse = [CCSequence actions:opacityUpEased, opacityDown, nil];
    id repeatOpacityPulse = [CCRepeatForever actionWithAction:opacityPulse];
    
    switch (p) {
        case eConnecting:
            [sconnect runAction:repeatOpacityPulse];
            sproducts.opacity = kOpacityOff;
            spurchase.opacity = kOpacityOff;
            sdone.opacity = kOpacityOff;
            break;
        case eProducts:
            [sproducts runAction:repeatOpacityPulse];
            sconnect.opacity = 255;
            spurchase.opacity = kOpacityOff;
            sdone.opacity = kOpacityOff;
            break;
        case ePurchase:
            [spurchase runAction:repeatOpacityPulse];
            sconnect.opacity = 255;
            sproducts.opacity = 255;
            sdone.opacity = kOpacityOff;
            break;
        case eDone:
            [sdone runAction:repeatOpacityPulse];
            sconnect.opacity = 255;
            sproducts.opacity = 255;
            spurchase.opacity = 255;
            break;
            
        default:
            break;
    }
}


- (void) dealloc
{
	[super dealloc];
}


@end
