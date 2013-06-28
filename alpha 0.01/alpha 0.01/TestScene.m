//
//  TestScene.m
//  alpha 0.01
//
//  Created by Roger Zhao on 2013-06-27.
//  Copyright 2013 Roger Zhao. All rights reserved.
//

#import "TestScene.h"
#import "HelloWorldLayer.h"
#import "CCLabelTTF.h"


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


// init
-(id) init
{
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
        
        // (Roger) Disabled due to the depreciated functions/methods
        //        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Card Functions Testing" fontName:@"Marker Felt" fontSize:48 dimensions:CGSizeMake(480, 50) hAlignment: UITextAlignmentLeft];
        [label setPosition:ccp(500.0, 700.0)];
        [self addChild: label];
        
        CCMenuItemImage *backBtn = [CCMenuItemImage itemWithNormalImage:@"Icon-72.png" selectedImage:@"Icon-72.png" target:self selector:@selector(jumpToMainScene:)];
        
        CCMenu *backMenu = [CCMenu menuWithItems:backBtn, nil];
        [backMenu alignItemsVertically];

        backMenu.position = ccp(winSize.width - 40, 10);
        [self addChild:backMenu];
        
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	}
	// (Roger) Disabled (For testing and debugging purposes)
    //    CGSize winSize = [CCDirector sharedDirector].winSize;
    //    [self schedule:@selector(gameLogic:) interval:2.0];
    
	return self;
}

-(void) dealloc {
    [super dealloc];
    [movableCards release];
    movableCards = nil;
}


// (Roger) Disabled (For testing and debugging purposes)
//- (void)gameLogic:(ccTime)dt {
//    [self addCard];
//}

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

// (Roger) Adding a return to main scene method
- (void)jumpToMainScene: (CCMenuItem *)item {
    NSLog(@"Button Being hit: Jump back to main scene");
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[HelloWorldLayer scene] ]];
}


@end
