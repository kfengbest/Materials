//
//  ListPageViewController.m
//  Materials
//
//  Created by Kaven Feng on 3/13/14.
//  Copyright (c) 2014 Kaven Feng. All rights reserved.
//

#import "ListPageViewController.h"

#import"MKNetworkKit.h"
#import "XMLReader/XMLReader.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CellInListPage.h"

@interface ListPageViewController ()
{
    NSMutableArray* materials;
}

@end

@implementation ListPageViewController
@synthesize classification;

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
    
    materials = [[NSMutableArray alloc] init];
    
    NSString* name = self.classification;
    NSRange range = [name rangeOfString:@"Autodesk.Material Classifications."];
    if (range.location != NSNotFound) {
        name = [name substringFromIndex:range.length];
    }
    self.navigationItem.title = name;

    
    [self loadData];
}

- (void) loadData
{
    /*
    http://exchange.services-staging.autodesk.com/Search/restapi/v1/contents?q=compoCategoryL2:%22Autodesk.Material%20Classifications.Fabric%22&facet=true&facet.field=compoCategoryL2&facet.field=compoCategoryL3&start=0&rows=20&detail=2&sort=name_sort%20asc&fq=%2Bcategory:(adsk.2.1.1%20adsk.2.1.2)&access_token=GC---Y0DMq0bzUwoyIAagT6qG1L9kHI
  
    */
    
    
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:@"exchange.services-staging.autodesk.com" customHeaderFields:nil];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    
    NSString* qValue = [NSString stringWithFormat:@"%@:\"%@\"",@"compoCategoryL2", self.classification];
    
    [dic setObject: qValue forKey:@"q"];
    [dic setObject: @"true" forKey:@"facet"];
    [dic setObject: @"compoCategoryL2" forKey:@"facet.field"];
    [dic setObject: @"0" forKey:@"start"];
    [dic setObject: @"20" forKey:@"rows"];
    [dic setObject: @"2" forKey:@"detail"];
    [dic setObject: @"name_sort asc" forKey:@"sort"];
    [dic setObject: @"GC---Y0DMq0bzUwoyIAagT6qG1L9kHI" forKey:@"access_token"];
    
    MKNetworkOperation *op = [engine operationWithPath:@"/Search/restapi/v1/contents" params:dic httpMethod:@"GET" ssl:NO];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        
        NSData* data = [operation responseData];
        NSError *error = nil;
        
        NSDictionary *dict = [XMLReader dictionaryForXMLData:data
                                                     options:XMLReaderOptionsProcessNamespaces
                                                       error:&error];
        
        if (dict != NULL && [dict count] == 1) {
            NSDictionary* listDic = [dict objectForKey:@"list"];
            if (listDic != NULL) {
                NSArray* contentArray = [listDic objectForKey:@"content"];
                [materials addObjectsFromArray:contentArray];
                
                [self.collectionView reloadData];
            }
        }
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [materials count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* MyCellID = @"CellInListPage";
    CellInListPage* newCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:MyCellID
                                                                                   forIndexPath:indexPath];
    
    NSDictionary* item  = materials[indexPath.row];
    NSString* strTitle = [[item objectForKey:@"title"] objectForKey:@"text"];
    NSString* strImageUri = [[[item objectForKey:@"images"] objectForKey:@"image"] objectForKey:@"uri"];
    NSString* strAuthedUri = [NSString stringWithFormat:@"%@%@", strImageUri, @"?access_token=GC---Y0DMq0bzUwoyIAagT6qG1L9kHI"];
    
    newCell.nameLabel.text = strTitle;

    [newCell.imageView setImageWithURL:[NSURL URLWithString:strAuthedUri] placeholderImage: [UIImage imageNamed:@"Ceramic.png" ]];

   // newCell.imageView.image = [UIImage imageNamed:@"Ceramic.png"];
    return newCell;
}

@end
