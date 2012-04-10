//
//  InfoLayer.h
//  KidPuzzleCocosPad
//
//  Created by Jakub Pavelek on 4/4/12.
//  Copyright 2012 Afte9. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface InfoLayer : CCLayer {
    CCSprite *bg;
    CCSprite *back;
    CCSprite *happy;
    CCSprite *sad;
    CCSprite *home;
}

// returns a CCScene that contains the GameLayer as the only child
+(CCScene *) scene;

@end
