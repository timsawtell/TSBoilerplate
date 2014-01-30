/*
 Copyright (c) 2014 Tim Sawtell
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
 to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
 and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 IN THE SOFTWARE.
 */

#import "iTunesResultsViewController.h"
#import "BookAttributeCell.h"

@interface iTunesResultsViewController ()

@end

@implementation iTunesResultsViewController

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        return 250.0f;
    }
    return 44.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookAttributeCell *cell = [tableView dequeueReusableCellWithIdentifier:kBookCell];
    switch (indexPath.row) {
        case 0:
            cell.lblKey.text = @"Author";
            cell.lblValue.text = self.book.author;
            break;
        case 1:
            cell.lblKey.text = @"Title";
            cell.lblValue.text = self.book.title;
            break;
        case 2:
            cell.lblKey.text = @"Price";
            cell.lblValue.text = self.book.price;
            break;
        case 3:
            cell.lblKey.text = @"Description";
            cell.lblValue.text = self.book.blurb;
            break;
            
        default:
            break;
    }
    return cell;
}

#pragma mark - helper

- (Book *)book
{
    return [Model sharedModel].book;
}

#pragma mark - IBActions

- (IBAction)closeTouched:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


@end
