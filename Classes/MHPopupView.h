//
//  MHPopupView.h
//
//  Created by Mason on 16/5/31.
//
//

#import <UIKit/UIKit.h>

@interface MHPopupView : UIView

/**
 *
 *
 *  @param edge      UIRectEdgeTop => slide from top
 *                   UIRectEdgeLeft => slide from left                                   \
 *                   UIRectEdgeRight => slide from right                                  > default is bottom at bottom
 *                   UIRectEdgeNone,UIRectEdgeAll,UIRectEdgeBottom => slide from bottom  /
 *
 *  @param docked    UIRectEdgeTop or UIRectEdgeBottom, only be used if slide from left or right
 *                   default is UIRectEdgeBottom.
 *
 *  @param container target view
 */
- (void)slideFromEdge:(UIRectEdge)edge docked:(UIRectEdge)docked inContainer:(UIView *)container;

/**
 *  dismiss method
 */
- (void)dismissIdentity;
@end
