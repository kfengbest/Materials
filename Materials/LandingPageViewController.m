//
//  LandingPageViewController.m
//  Materials
//
//  Created by Kaven Feng on 3/13/14.
//  Copyright (c) 2014 Kaven Feng. All rights reserved.
//

#import "LandingPageViewController.h"
#import"MKNetworkKit.h"
#import "XMLReader/XMLReader.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CellInLandingPage.h"
#import "ListPageViewController.h"

@interface LandingPageViewController ()
{
    NSMutableArray* classifications;
    UIActivityIndicatorView* indicator;

}
@end

@implementation LandingPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [indicator setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)];
    indicator.backgroundColor = [UIColor grayColor];
    indicator.alpha = 0.9;
    indicator.layer.cornerRadius = 6;
    indicator.layer.masksToBounds = YES;
    [self.view addSubview:indicator];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = @"Autodesk Materials";

    
    classifications = [[NSMutableArray alloc] init];
    
    [self loadMaterials];
}

-(void) loadMaterials{
    
    [indicator startAnimating];
    
    // http://exchange.services-staging.autodesk.com/Search/restapi/v1/contents?facet.field=compoCategoryL2&facet=true&rows=1&facet.mincount=1&access_token=GC---Y0DMq0bzUwoyIAagT6qG1L9kHI
    
    
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
        
        NSDictionary* dict = [XMLReader dictionaryForXMLData:data options:XMLReaderOptionsProcessNamespaces error:&error];
        if ([dict count] == 1) {
            NSDictionary* listDic = [dict objectForKey:@"list"];
            if (listDic!= NULL) {
                NSDictionary* facetsDic = [listDic objectForKey:@"facets"];
                if (facetsDic != NULL) {
                    NSDictionary* facetDic = [facetsDic objectForKey:@"facet"];
                    if (facetDic != NULL) {
                        NSArray* fields = [facetDic objectForKey:@"field"];
                        for (int i = 0; i < [fields count]; i++) {
                            NSDictionary* item = fields[i];
                            NSString* name = [item objectForKey:@"name"];
                            if ([name rangeOfString:@"Autodesk.Material Classifications."].location != NSNotFound) {
                                [classifications addObject:item];
                            }
                        }
                        
                        [self.collectionView reloadData];
                        
                        [indicator stopAnimating];
                    }
                }
            }
            
        }
        
    }errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        NSLog(@"MKNetwork request error : %@", [err localizedDescription]);
        [indicator stopAnimating];
    }];
    [engine enqueueOperation:op];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [classifications count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* MyCellID = @"CellInLandingPage";
    CellInLandingPage* cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:MyCellID
                                                                             forIndexPath:indexPath];
    
    NSDictionary* dic = classifications[indexPath.row];
    NSString* name = [dic objectForKey:@"name"];
    NSRange range = [name rangeOfString:@"Autodesk.Material Classifications."];
    if (range.location != NSNotFound) {
        name = [name substringFromIndex:range.length];
    }
    
    NSString* strImageName = [NSString stringWithFormat:@"%@.png",name];
    cell.imageView.image = [UIImage imageNamed:strImageName];
    NSString* strNum = [dic objectForKey:@"count"];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ (%@)", name, strNum];

    return cell;

}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"LandingPage2ListPage"])
    {
        ListPageViewController *detailViewController = [segue destinationViewController];
        NSIndexPath* indexPath = (NSIndexPath*)[self.collectionView indexPathsForSelectedItems][0];
        NSDictionary* item = classifications[indexPath.row];
        detailViewController.classification = [item objectForKey:@"name"];
        detailViewController.totalSize = [[item objectForKey:@"count"] integerValue];
    }
}

@end
