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
#import "XMLReader/XMLReader.h"


@interface ViewController ()

@end

@implementation ViewController

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

- (IBAction)loadImage:(id)sender {
    
//    NSString* imgUrl = @"http://s1.bdstatic.com/r/www/cache/static/global/img/wsLogo2_0871cb28.png";
//    
//    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imgUrl] options:0 progress:^(NSUInteger receivedSize, long long expectedSize) {
//        
//    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
//        if (image && finished) {
//            self.imageView1.image = image;
//        }
//    }];
    
  
    /* works!
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:@"exchange.services-staging.autodesk.com" customHeaderFields:nil];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    [dic setObject:@"compoCategoryL2" forKey:@"facet.field"];
    [dic setObject: @"true" forKey:@"facet"];
    [dic setObject: @"1" forKey:@"rows"];
    [dic setObject: @"1" forKey:@"facet.mincount"];
    [dic setObject: @"GC---Y0DMq0bzUwoyIAagT6qG1L9kHI" forKey:@"access_token"];

    MKNetworkOperation *op = [engine operationWithPath:@"/Search/restapi/v1/contents" params:dic httpMethod:@"GET" ssl:NO];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        
        NSData* data = [operation responseData];
        NSError *error = nil;
        
        NSDictionary *dict = [XMLReader dictionaryForXMLData:data
                                                     options:XMLReaderOptionsProcessNamespaces
                                                       error:&error];
        
        // NSLog(@"[operation responseData]-->>%@", [operation responseData]);
    }errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        NSLog(@"MKNetwork request error : %@", [err localizedDescription]);
    }];
    [engine enqueueOperation:op];
     
     */
    
   
    /*
//http://exchange.services-staging.autodesk.com/Search/restapi/v1/contents?q=category:adsk.2.1.3&detail=3&startIndex=0&rows=100&access_token=GC---Y0DMq0bzUwoyIAagT6qG1L9kHI
    
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:@"exchange.services-staging.autodesk.com" customHeaderFields:nil];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    [dic setObject:@"category:adsk.2.1.3" forKey:@"q"];
    [dic setObject: @"3" forKey:@"detail"];
    [dic setObject: @"0" forKey:@"startIndex"];
    [dic setObject: @"100" forKey:@"rows"];
    [dic setObject: @"GC---Y0DMq0bzUwoyIAagT6qG1L9kHI" forKey:@"access_token"];
    
    MKNetworkOperation *op = [engine operationWithPath:@"/Search/restapi/v1/contents" params:dic httpMethod:@"GET" ssl:NO];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        
        NSData* data = [operation responseData];
        NSError *error = nil;
        
        NSDictionary *dict = [XMLReader dictionaryForXMLData:data
                                                     options:XMLReaderOptionsProcessNamespaces
                                                       error:&error];
        
        // NSLog(@"[operation responseData]-->>%@", [operation responseData]);
    }errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        NSLog(@"MKNetwork request error : %@", [err localizedDescription]);
    }];
    [engine enqueueOperation:op];
    
*/
    

    
}
@end
