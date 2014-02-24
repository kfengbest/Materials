//
//  ViewController.m
//  Materials
//
//  Created by Kaven Feng on 2/24/14.
//  Copyright (c) 2014 Kaven Feng. All rights reserved.
//

#import "ViewController.h"
#import"MKNetworkKit.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
//    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:@"www.baidu.com" customHeaderFields:nil];
//    MKNetworkOperation *op = [engine operationWithPath:@"" params:nil httpMethod:@"GET" ssl:NO];
//    [op addCompletionHandler:^(MKNetworkOperation *operation) {
//        NSLog(@"[operation responseData]-->>%@", [operation responseString]);
//    }errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
//        NSLog(@"MKNetwork request error : %@", [err localizedDescription]);
//    }];
//    [engine enqueueOperation:op];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
