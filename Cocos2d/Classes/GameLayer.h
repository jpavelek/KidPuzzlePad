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
    CCSprite *bg;
    CCSprite *back;
    CCSprite *tray;
    int tilecount;
    int placedTiles;
    NSMutableArray* balloons;
    NSMutableArray* bSpeeds;
}

// returns a CCScene that contains the GameLayer as the only child
+(CCScene *) scene;
-(id)init:(NSString*)boardName;
-(void)popBalloons;

@end
