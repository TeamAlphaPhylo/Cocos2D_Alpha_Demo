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

// (Roger) Disabled (For testing and debugging purposes)
//- (void) addCard {
//    // (Roger) The range of this random number must be small, otherwise it will exploit memory and cause exception
//    NSInteger randNum = arc4random() % 40;
//    NSString *postfix = @".png";
//    NSString *randFileName = [NSString stringWithFormat: @"%i%@", randNum, postfix];
//    CCSprite *card2 = [CCSprite spriteWithFile: randFileName];
//    
//    // Determine where to spawn the card2 along the Y-axis
//    CGSize winSize = [CCDirector sharedDirector].winSize;
//    int minY = card2.contentSize.height/2;
//    int maxY = winSize.height - card2.contentSize.height/2;
//    int rangeY = maxY - minY;
//    int actualY = (arc4random() % rangeY) + minY;
//    
//    card2.position = ccp(winSize.width + card2.contentSize.width/2, actualY);
//    [self addChild:card2];
//    
//    // Determine the speed of the card 2
//    int minDuration = 7.0;
//    int maxDuration = 12.0;
//    int rangeDuration = maxDuration - minDuration;
//    int actualDuration = (arc4random() % rangeDuration) + minDuration;
//    
//    // Create the actions
//    CCMoveTo *actionMove = [CCMoveTo actionWithDuration:actualDuration position:ccp(-card2.contentSize.width/2, actualY)];
//    CCCallBlockN *actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
//        [node removeFromParentAndCleanup:YES];
//    }];
//    [card2 runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
//    
//}
// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if((self=[super init])) {
		CGSize winSize = [CCDirector sharedDirector].winSize;
// (Roger) Disabled (For testing and debugging purposes)
//        CCSprite *card = [CCSprite spriteWithFile: @"0.png"];
//        card.position = ccp(card.contentSize.width/2, winSize.height/2);
//        [self addChild:card]
        
        // (Roger) Set the background
        // (Roger) The pixel format is omitted here
//      [CCTexture2D setDefaultAlphaPixelFormat: kCCTexture2DPixelFormat_RGB565];
        background = [CCSprite spriteWithFile: @"waterdroplets.png"];
        background.anchorPoint = ccp(0, 0);
        [self addChild:background];
        
        movableCards = [[NSMutableArray alloc] init];
        NSArray *cardImgs = [NSArray arrayWithObjects:@"0.png", @"1.png", @"2.png", @"3.png", @"4.png", nil];
        
        // (Roger) Add movable cards
        for(int i = 0; i < cardImgs.count; ++i) {
            NSString *card = [cardImgs objectAtIndex:i];
            CCSprite *sprite = [CCSprite spriteWithFile:card];
            float offsetFraction = ((float)(i+1))/(cardImgs.count + 1);
            sprite.position = ccp(winSize.width*offsetFraction, winSize.height/2);
            [self addChild:sprite];
            [movableCards addObject:sprite];
        }
        
        // (Roger) Add Menu Item
        CCMenuItemImage *item1 = [CCMenuItemImage itemWithNormalImage:@"10.png" selectedImage:@"11.png" target:self selector:@selector(jumpToNextScene:)];
        CCMenu *menu = [CCMenu menuWithItems:item1, nil];
        
        [self addChild: menu];
        
        // (Roger) Disabled due to the depreciated functions/methods
        //        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	}
    
// (Roger) Disabled (For testing and debugging purposes)
//    CGSize winSize = [CCDirector sharedDirector].winSize;
//    [self schedule:@selector(gameLogic:) interval:2.0];
	return self;
}

// (Roger) Disabled (For testing and debugging purposes)
//- (void)gameLogic:(ccTime)dt {
//    [self addCard];
//}
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
    [movableCards release];
    movableCards = nil;
}

- (void)jumpToNextScene: (CCMenuItem *)item {
    NSLog(@"Button Being hit");
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[TestScene scene] ]];
}

- (void)selectCardForTouch:(CGPoint)touchLocation {
    CCSprite * newCard = nil;
    for (CCSprite *card in movableCards) {
        if(CGRectContainsPoint(card.boundingBox, touchLocation)) {
            newCard = card;
            break;
        }
    }
    if(newCard != selectedCard) {
        [selectedCard stopAllActions];
        [selectedCard runAction:[CCRotateTo actionWithDuration:0.1 angle:0]];
        CCRotateTo *rotLeft = [CCRotateBy actionWithDuration:0.1 angle:-4.0];
        CCRotateTo *rotCenter = [CCRotateBy actionWithDuration:0.1 angle:0.0];
        CCRotateTo *rotRight = [CCRotateBy actionWithDuration:0.1 angle:4.0];
        CCSequence *rotSeq = [CCSequence actions: rotLeft, rotCenter, rotRight, rotCenter, nil];
        [newCard runAction:[CCRepeatForever actionWithAction:rotSeq]];
        selectedCard = newCard;
    }
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    [self selectCardForTouch:touchLocation];
    return TRUE;
}

- (void)panForTranslation: (CGPoint)translation {
    if(selectedCard) {
        CGPoint newPos = ccpAdd(selectedCard.position, translation);
        selectedCard.position = newPos;
    } else {
        CGPoint newPos = ccpAdd(self.position, translation);
        self.position = newPos;
    }
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
    
    CGPoint translation = ccpSub(touchLocation, oldTouchLocation);
    [self panForTranslation: translation];
    
}

//#pragma mark GameKit delegate
//
//-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
//{
//	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
//	[[app navController] dismissModalViewControllerAnimated:YES];
//}
//
//-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
//{
//	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
//	[[app navController] dismissModalViewControllerAnimated:YES];
//}
@end
