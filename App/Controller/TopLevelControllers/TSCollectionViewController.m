//
//  TSCollectionViewController.m
//  EBookplusAC
//
//  Created by Tim Sawtell on 20/05/13.
//
//

#import "TSCollectionViewController.h"

@interface TSCollectionViewController ()

@end

@implementation TSCollectionViewController

- (void)viewDidLoad
{
    self.collectionView.contentInset = UIEdgeInsetsZero;
	self.scrollViewToResizeOnKeyboardShow = self.collectionView;
    [super viewDidLoad];
}

- (void)reloadData
{
    [self.collectionView reloadData];
    [super reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 0;
}

// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
