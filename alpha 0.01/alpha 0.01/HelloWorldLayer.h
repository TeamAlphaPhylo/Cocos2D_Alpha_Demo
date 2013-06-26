//
//  HelloWorldLayer.h
//  alpha 0.01
//
//  Created by Roger Zhao on 2013-06-25.
//  Copyright Roger Zhao 2013. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayerColor
{
    CCSprite *background;
    CCSprite *selectedCard;
    NSMutableArray *movableCards;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
