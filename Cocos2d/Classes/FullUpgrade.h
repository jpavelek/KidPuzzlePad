//
//  FullUpgrade.h
//  KidPuzzleCocosPad
//
//  Created by Jakub Pavelek on 7/8/12.
//  Copyright 2012 Afte9. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface FullUpgrade : CCLayer {
    CCSprite *back;
    CCSprite *sconnect;
    CCSprite *sproducts;
    CCSprite *spurchase;
    CCSprite *sdone;
}

+(CCScene *) scene;

@end
