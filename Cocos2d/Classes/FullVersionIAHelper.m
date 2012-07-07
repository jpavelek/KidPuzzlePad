//
//  FullVersionIAHelper.m
//  KidPuzzleCocosPad
//
//  Created by Jakub Pavelek on 7/6/12.
//  Copyright (c) 2012 Afte9. All rights reserved.
//

#import "FullVersionIAHelper.h"

@implementation FullVersionIAHelper

static FullVersionIAHelper * _sharedHelper;

+ (FullVersionIAHelper *) sharedHelper {
    
    if (_sharedHelper != nil) {
        return _sharedHelper;
    }
    _sharedHelper = [[FullVersionIAHelper alloc] init];
    return _sharedHelper;
    
}

- (id)init {
    
    NSSet *productIdentifiers = [NSSet setWithObjects:
                                 @"com.afte9.puzzlefortoddlersFREEfull",
                                 nil];
    
    if ((self = [super initWithProductIdentifiers:productIdentifiers])) {                
        
    }
    return self;
    
}

@end
