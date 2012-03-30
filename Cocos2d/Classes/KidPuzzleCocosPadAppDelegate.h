//
//  KidPuzzleCocosPadAppDelegate.h
//  KidPuzzleCocosPad
//
//  Created by Jakub Pavelek on 3/28/12.
//  Copyright Afte9 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface KidPuzzleCocosPadAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
