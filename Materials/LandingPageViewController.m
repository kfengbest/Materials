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

@interface LandingPageViewController ()
{
    NSMutableArray* classifications;
}
@end

@implementation LandingPageViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    classifications = [[NSMutableArray alloc] init];
    
    [self loadMaterials];
}

-(void) loadMaterials{
    
    
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
                        
                        [self.tableView reloadData];

                    }
                }
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [classifications count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellInLandingPage";
    CellInLandingPage *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary* dic = classifications[indexPath.row];
    NSString* name = [dic objectForKey:@"name"];
    NSRange range = [name rangeOfString:@"Autodesk.Material Classifications."];
    if (range.location != NSNotFound) {
        name = [name substringFromIndex:range.length];
    }
    
    NSString* strImageName = [NSString stringWithFormat:@"%@.png",name];
    cell.thumbnail.image = [UIImage imageNamed:strImageName];
    cell.nameLabel.text = name;
    cell.countLabel.text = [dic objectForKey:@"count"];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end