//
//  ViewController.m
//  Materials
//
//  Created by Kaven Feng on 2/24/14.
//  Copyright (c) 2014 Kaven Feng. All rights reserved.
//

#import "ViewController.h"
#import"MKNetworkKit.h"
#import <SDWebImage/UIImageView+WebCache.h>


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

- (IBAction)loadImage:(id)sender {
    
    NSString* imgUrl = @"http://s1.bdstatic.com/r/www/cache/static/global/img/wsLogo2_0871cb28.png";
    
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imgUrl] options:0 progress:^(NSUInteger receivedSize, long long expectedSize) {
        
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        if (image && finished) {
            self.imageView1.image = image;
        }
    }];
}
@end
