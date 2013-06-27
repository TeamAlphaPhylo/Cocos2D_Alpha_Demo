//
//  TestScene.m
//  alpha 0.01
//
//  Created by Roger Zhao on 2013-06-27.
//  Copyright 2013 Roger Zhao. All rights reserved.
//

#import "TestScene.h"


@implementation TestScene

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	TestScene *layer = [TestScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

//
-(id) init
{
	if( (self=[super init])) {
        
		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
		CCSprite *background;
		
		if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
			background = [CCSprite spriteWithFile:@"Default.png"];
			background.rotation = 90;
		} else {
			background = [CCSprite spriteWithFile:@"Default-Landscape~ipad.png"];
		}
		background.position = ccp(size.width/2, size.height/2);
        
		// add the label as a child to this Layer
		[self addChild: background];
	}
	
	return self;
}

@end
