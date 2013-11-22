//
//  ViewController.m
//  SampleProject
//
//  Created by Hiroyuki Kato on 11/9/13.
//  Copyright (c) 2013 Hiroyuki Kato. All rights reserved.
//

#import "ViewController.h"
#import "TestSDK.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)mButton:(id)sender {
}
- (IBAction)mButtonTouchDown:(id)sender {
//  NSLog(@"Button Touch Down");
  [[TestSDK sharedManager] sendData:[NSDictionary dictionaryWithObjectsAndKeys: @"hello!!!!", @"tocuh", nil]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
