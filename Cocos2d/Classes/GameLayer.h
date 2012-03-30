//
//  GameLayer.h
//  KidPuzzleCocosPad
//
//  Created by Jakub Pavelek on 3/28/12.
//  Copyright Afte9 2012. All rights reserved.
//

#import "cocos2d.h"
#import "Bit.h"

@interface GameLayer : CCLayer
{
    NSMutableArray* bits;
    Bit *currentBit;
    CCSprite *back;
}

// returns a CCScene that contains the GameLayer as the only child
+(CCScene *) scene;

@end
