//
//  TestSDKTests.m
//  TestSDKTests
//
//  Created by Kato Hiroyuki on 11/5/13.
//  Copyright (c) 2013 Hiroyuki Kato. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TestSDK.h"

@interface TestSDK (Private)

-(NSString *) generateUUID;
-(void) removeUUID;

@end

@interface TestSDKTests : XCTestCase

@end

@implementation TestSDKTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

- (void)testSendData {
  
  TestSDK *sdk = [TestSDK sharedManager];
  NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                        @"1", @"hoge",
                        @"2", @"fuga",
                        nil];
  
  [sdk sendData:dict];
}

- (void)testNestedDictionary {
  
  TestSDK *sdk = [TestSDK sharedManager];
  NSDictionary *sub_dic =[NSDictionary dictionaryWithObjectsAndKeys:
                          @"world", @"hello",
                          nil];

  NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                        @"1", @"hoge",
                        @"2", @"fuga",
                        sub_dic, @"nested",
                        nil];
  
  [sdk sendData:dict];
}

//- (void)testGenerateUUID {
//  TestSDK *sdk = [TestSDK sharedManager];
//  
//  NSString *uuid_1 = [sdk generateUUID];
//  NSLog(@"uuid_1 : %@", uuid_1);
//  
//  [sdk removeUUID];
//  
//  NSString *uuid_2 = [sdk generateUUID];
//  NSLog(@"uuid_2 : %@", uuid_2);
//
//  [sdk removeUUID];
//}

@end
