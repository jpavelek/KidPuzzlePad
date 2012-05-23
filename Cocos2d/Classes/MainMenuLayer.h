//
//  MainMenuLayer.h
//  KidPuzzleCocosPad
//
//  Created by Jakub Pavelek on 3/31/12.
//  Copyright 2012 Afte9. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MainMenuLayer : CCLayer {
    NSArray* boards;
    Boolean fullgame;
}

+(CCScene *) scene;

@end
