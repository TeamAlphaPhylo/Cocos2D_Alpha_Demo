//
//  HelloWorldLayer.m
//  alpha 0.01
//
//  Created by Roger Zhao on 2013-06-25.
//  Copyright Roger Zhao 2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "TestScene.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if((self=[super init])) {        
        // (Roger) Add Menu Item
        CCMenuItemImage *item1 = [CCMenuItemImage itemWithNormalImage:@"10.png" selectedImage:@"11.png" target:self selector:@selector(jumpToTestScene:)];
        
        CCMenuItemFont *item2 = [CCMenuItemFont itemWithString:@"Card Scene" target:self selector:@selector(jumpToTestScene:)];
        
        
        CCMenu *menu = [CCMenu menuWithItems:item1, item2, nil];
        
        // (Roger) Change the menu layout
        [menu alignItemsVertically];
        
        // (Roger) Add the menu to the scene (layer)
        [self addChild: menu];
       	}
    

	return self;
}
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

// (Roger) Class designed to switch to another scene
- (void)jumpToTestScene: (CCMenuItem *)item {
    NSLog(@"Button Being hit: jump to card test scene");
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[TestScene scene] ]];
}
@end
