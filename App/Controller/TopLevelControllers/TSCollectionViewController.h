//
//  TSCollectionViewController.h
//  EBookplusAC
//
//  Created by Tim Sawtell on 20/05/13.
//
//

#import "TSViewController.h"

@interface TSCollectionViewController : TSViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end
