//
//  MTInputAlertView.h
//  HideMe
//
//  Created by Mihir Thakkar on 06/09/2016.
//  Copyright (c) 2014 Mihir Thakkar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MTInputAlertViewTransitionStyle) {
    MTInputAlertViewTransitionStyleSlideFromBottom,
    MTInputAlertViewTransitionStyleSlideFromTop,
    MTInputAlertViewTransitionStyleFade,
    MTInputAlertViewTransitionStyleBounce,
    MTInputAlertViewTransitionStyleDropDown
};

typedef void(^InputPopupCompletionBlock)(BOOL isCancelled, NSMutableDictionary *dictData);

@interface MTCCInputView : UIView <UITextFieldDelegate>
{
    BOOL isCancelled;
    NSString *previousTextFieldContent;
    UITextRange *previousSelection;
    NSMutableDictionary *dictCardData;
}

@property (nonatomic, copy) InputPopupCompletionBlock  showCompletionBlock;

@property(nonatomic,retain) IBOutlet UIScrollView *shadowView;
@property (nonatomic, assign)IBOutlet UIView *viewPopUpBox;

@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UIButton *btnSubmit;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UILabel *lblLineEmail;


//@property (nonatomic, assign)IBOutlet UIView *viewCardDetails;
//
//@property (nonatomic, assign)IBOutlet UIButton *btnSaveCard;
//@property (nonatomic, assign)IBOutlet UIImageView *imgSaveUnsaveCard;
//@property (nonatomic, assign)IBOutlet UIView *saveCardOrNotView;
//@property (nonatomic, assign)IBOutlet UILabel *lblAmountLine;
//@property (nonatomic, assign)IBOutlet UILabel *lblCardNumberLine;
//@property (nonatomic, assign)IBOutlet UILabel *lblExpiryMonthLine;
//@property (nonatomic, assign)IBOutlet UILabel *lblExpiryYearLine;
//@property (nonatomic, assign)IBOutlet UILabel *lblCVVLine;
//@property (nonatomic, assign)IBOutlet UILabel *lblNameLine;
//
//@property (nonatomic, assign)IBOutlet UITextField *txtAmount;
//@property (nonatomic, assign)IBOutlet UITextField *txtCVVNumber;
//@property (nonatomic, assign)IBOutlet UITextField *txtFullName;
//@property (nonatomic, assign)IBOutlet UITextField *txtCardNumber;
//@property (nonatomic, assign)IBOutlet UITextField *txtCardExpiryMonth;
//@property (nonatomic, assign)IBOutlet UITextField *txtCardExpiryYear;

//@property (nonatomic, assign)IBOutlet UIButton *btnCancel;
@property (nonatomic, assign)IBOutlet UIButton *btnPayNow;

//@property (nonatomic, assign)BOOL isSaveCard;

@property (nonatomic, assign)NSMutableDictionary *dictPaymentData;

@property (nonatomic, assign) MTInputAlertViewTransitionStyle transitionStyle;

@property(nonatomic,readwrite) CGFloat animationDuration;

- (void) showWithCompletionBlock:(InputPopupCompletionBlock)completionBlock;
- (void) hide;

@end
