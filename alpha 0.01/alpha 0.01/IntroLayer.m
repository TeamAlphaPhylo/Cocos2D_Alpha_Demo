//
//  IntroLayer.m
//  alpha 0.01
//
//  Created by Roger Zhao on 2013-06-25.
//  Copyright Roger Zhao 2013. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"
// (Roger) Modified to make it jump to the MainMenu scene
#import "HelloWorldLayer.h"

#pragma mark - IntroLayer

// HelloWorldLayer implementation
@implementation IntroLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
	
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
		
        background = [CCSprite spriteWithFile:@"Default-Landscape~ipad.png"];
		
        background.position = ccp(size.width/2, size.height/2);

		// add the label as a child to this Layer
		[self addChild: background];
	}
	
	return self;
}

-(void) onEnter
{
	[super onEnter];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:3.0 scene:[HelloWorldLayer scene] ]];
}
@end
