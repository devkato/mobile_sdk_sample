//
//  TestSDK.m
//  TestSDK
//
//  Created by Kato Hiroyuki on 11/5/13.
//  Copyright (c) 2013 Hiroyuki Kato. All rights reserved.
//

#import "TestSDK.h"

@implementation TestSDK

static TestSDK* shared = nil;

/* --------------------------------------------------------------------------------
 *
 * return singleton-object
 *
 -------------------------------------------------------------------------------- */
+ (id)sharedManager {
  
  @synchronized(self) {
    if (shared == nil) {
      shared = [[self alloc] init];
    }
  }
  
  return shared;
}


/* --------------------------------------------------------------------------------
 *
 * class(instance) initialization
 *
 -------------------------------------------------------------------------------- */
- (id)init {
  if (self = [super init]) {
    //    someProperty = [[NSString alloc] initWithString:@"Default Property Value"];
  }
  
  return self;
}

- (void)sayHello {
  NSLog(@"Hello World!");
}


/* ================================================================================
 *
 * these methods are forbidden if you want to use ARC
 *
 ================================================================================ */
//+ (id)allocWithZone:(NSZone *)zone {
//  return [[self sharedManager] retain];
//}

- (id)copyWithZone:(NSZone *)zone {
  return self;
}

- (id)retain {
  return self;
}

//- (unsigned)retainCount {
//  return UINT_MAX;
//}

- (oneway void)release {
}

- (id)autorelease {
  return self;
}

- (void)dealloc {
  [super dealloc];
}


@end
