//
//  TestSDK.h
//  TestSDK
//
//  Created by Kato Hiroyuki on 11/5/13.
//  Copyright (c) 2013 Hiroyuki Kato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface TestSDK : NSObject

+ (id)sharedManager;
- (void)sendData:(NSDictionary *)json;

@end