//
//  MaterialDetailsViewController.m
//  Materials
//
//  Created by Kaven Feng on 3/5/14.
//  Copyright (c) 2014 Kaven Feng. All rights reserved.
//

#import "MaterialDetailsViewController.h"
#import"MKNetworkKit.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "XMLReader/XMLReader.h"
#import "CellInDetailPage.h"

@interface MaterialDetailsViewController ()
{
    NSDictionary *dict;
}
@end

@implementation MaterialDetailsViewController
@synthesize uuid;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //    http://exchange.services-staging.autodesk.com/Search/restapi/v1/contents?q=contentId:3177e620-51b6-4b1b-b85e-3863c15b4b57&detail=5&access_token=GC---Y0DMq0bzUwoyIAagT6qG1L9kHI
    
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:@"exchange.services-staging.autodesk.com" customHeaderFields:nil];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    [dic setObject:@"contentId:3177e620-51b6-4b1b-b85e-3863c15b4b57" forKey:@"q"];
    [dic setObject: @"5" forKey:@"detail"];
    [dic setObject: @"GC---Y0DMq0bzUwoyIAagT6qG1L9kHI" forKey:@"access_token"];
    
    MKNetworkOperation *op = [engine operationWithPath:@"/Search/restapi/v1/contents" params:dic httpMethod:@"GET" ssl:NO];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        
        NSData* data = [operation responseData];
        NSError *error = nil;
        
        dict = [XMLReader dictionaryForXMLData:data
                                                     options:XMLReaderOptionsProcessNamespaces
                                                       error:&error];
        

    }errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        NSLog(@"MKNetwork request error : %@", [err localizedDescription]);
    }];
    [engine enqueueOperation:op];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellInDetailPage";
    CellInDetailPage *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
 
    
    return cell;
}

@end
