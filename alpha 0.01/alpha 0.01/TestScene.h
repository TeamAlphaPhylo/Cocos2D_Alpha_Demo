//
//  TestScene.h
//  alpha 0.01
//
//  Created by Roger Zhao on 2013-06-27.
//  Copyright 2013 Roger Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AppDelegate.h"

@interface TestScene : CCLayer {
    CCSprite *background;
    CCSprite *selectedCard;
    NSMutableArray *movableCards;
}
+(CCScene *) scene;

@end
