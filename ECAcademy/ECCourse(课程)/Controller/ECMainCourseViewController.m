//
//  ECMainCourseViewController.m
//  ECAcademy
//
//  Created by Sophist on 2017/3/24.
//  Copyright © 2017年 dentalink. All rights reserved.
//

//controllers
#import "ECMainCourseViewController.h"
#import "ECCourseListViewController.h"
#import "ECBaseWebViewController.h"

//Views
#import "ECBaseTableView.h"
#import "ECMainCourseCell.h"
#import "ECCourseCollectCell.h"
#import "ECCourseHeadView.h"
//Models

//Tools
#import "ECPlatformShareManager.h"

static NSString *cellid1 = @"collectCellID";
static NSString *cell1HeadID = @"collectHeadID";
static NSString *cellid2 = @"";
@interface ECMainCourseViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)ECBaseTableView *m_tableView;

@property(nonatomic,strong)UICollectionView *m_collectionView;

@property(nonatomic,strong)UICollectionView *m_classCollectionView;


@end

@implementation ECMainCourseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.m_collectionView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

//首页主页
-(UICollectionView *)m_collectionView
{
    if (!_m_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemWidth = (kECScreenWidth - 30.f)/2.f;
        layout.itemSize = CGSizeMake(itemWidth, 150);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _m_collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNavHeight, kECScreenWidth , kECScreenHeight - kNavHeight - kTabbarHeight) collectionViewLayout:layout];
        _m_collectionView.backgroundColor = [UIColor whiteColor];
        _m_collectionView.dataSource = self;
        _m_collectionView.delegate = self;
        _m_collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
        //通过Nib生成cell，然后注册 Nib的view需要继承 UICollectionViewCell
        [self.m_collectionView registerNib:[UINib nibWithNibName:@"ECCourseCollectCell" bundle:nil] forCellWithReuseIdentifier:cellid1];
        //注册headerView Nib的view需要继承UICollectionReusableView
        [self.m_collectionView registerNib:[UINib nibWithNibName:@"ECCourseHeadView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:cell1HeadID];
        //注册footerView Nib的view需要继承UICollectionReusableView
//        [self.m_collectionView registerNib:[UINib nibWithNibName:@"SQSupplementaryView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kfooterIdentifier];
        //
    }
    return _m_collectionView;
}

-(UICollectionView *)m_classCollectionView
{
    if (!_m_classCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(40, 40);
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 1;
        
        _m_classCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
        _m_classCollectionView.dataSource = self;
        _m_classCollectionView.delegate = self;
        
    }
    return _m_collectionView;
}


#pragma mark - UICollection Data source
//section
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.m_collectionView) {
        //重用cell
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellid1 forIndexPath:indexPath];
        cell.backgroundColor = kECBlueColor1;
        return cell;
    }else{
        return nil;
    }
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.m_collectionView) {
    
        if ([kind isEqualToString: UICollectionElementKindSectionFooter]){
            return nil;
        }else{
            NSString *reuseIdentifier = @"collectHeadID";
            UICollectionReusableView *view =  [collectionView dequeueReusableSupplementaryViewOfKind :kind withReuseIdentifier:reuseIdentifier   forIndexPath:indexPath];
            
            return view;
        }
        
    }else{
        return nil;
    }


}

#pragma mark - UICollection Delegate

//返回头headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    CGSize size={320,45};
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ECBaseViewController *vc = [[ECBaseViewController alloc] init];
//    vc.view.backgroundColor = [UIColor blueColor];
    [self.navigationController pushViewController:vc animated:YES];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
