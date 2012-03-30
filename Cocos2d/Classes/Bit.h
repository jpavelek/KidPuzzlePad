//
//  Bit.h
//  KidPuzzleCocosPad
//
//  Created by Jakub Pavelek on 3/29/12.
//  Copyright 2012 Afte9. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Bit : CCSprite { //Could be anything, maybe in future a subclass with the bits setup delegated
}

@property (retain) CCSprite* insprite;
@property float inscale; 
@property int trayX;
@property int trayXX;
@property int trayY;
@property int trayYY;
@property int trayW;
@property int trayH;
@property int boardX;
@property int boardY;
@property BOOL locked;

-(id)init: (NSString*)fname;
-(void)pop;
-(void)back;
-(void)snap;
-(void)setData: (int)ptx trayY:(int)pty trayW:(int)ptw trayH:(int)pth boardX:(int)pbx boardY:(int)pby;

@end
