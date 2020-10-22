//
//  MTInputAlertView.m
//  HideMe
//
//  Created by Mihir Thakkar on 06/09/2016.
//  Copyright (c) 2014 Mihir Thakkar. All rights reserved.
//

#import "MTCCInputView.h"

@implementation MTCCInputView

@synthesize animationDuration;
@synthesize transitionStyle;

CGRect firstRect;

- (instancetype)init
{
    self = [super init];
    
    if ( self )
    {
        self = [super initWithFrame:[UIScreen mainScreen].bounds];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MTCCInputView" owner:self options:nil][0];
        self.frame = frame;
        
        self.animationDuration = 0.4;
        
        dictCardData = [[NSMutableDictionary alloc]init];
        self.transitionStyle = MTInputAlertViewTransitionStyleFade;
    }
    return self;
}

#pragma mark - Other Methods -
-(void)reformatAsCardNumber:(UITextField *)textField
{
    NSUInteger targetCursorPosition = [textField offsetFromPosition:textField.beginningOfDocument toPosition:textField.selectedTextRange.start];
    
    NSString *cardNumberWithoutSpaces = [self removeNonDigits:textField.text andPreserveCursorPosition:&targetCursorPosition];
    
    if ([cardNumberWithoutSpaces length] > 16)
    {
        [textField setText:previousTextFieldContent];
        textField.selectedTextRange = previousSelection;
        return;
    }
    
    NSString *cardNumberWithSpaces =
    [self insertSpacesEveryFourDigitsIntoString:cardNumberWithoutSpaces
                      andPreserveCursorPosition:&targetCursorPosition];
    
    textField.text = cardNumberWithSpaces;
    UITextPosition *targetPosition =
    [textField positionFromPosition:[textField beginningOfDocument]
                             offset:targetCursorPosition];
    
    [textField setSelectedTextRange:
     [textField textRangeFromPosition:targetPosition
                           toPosition:targetPosition]
     ];
}
- (NSString *)removeNonDigits:(NSString *)string
    andPreserveCursorPosition:(NSUInteger *)cursorPosition
{
    NSUInteger originalCursorPosition = *cursorPosition;
    NSMutableString *digitsOnlyString = [NSMutableString new];
    for (NSUInteger i=0; i<[string length]; i++) {
        unichar characterToAdd = [string characterAtIndex:i];
        if (isdigit(characterToAdd)) {
            NSString *stringToAdd =
            [NSString stringWithCharacters:&characterToAdd
                                    length:1];
            
            [digitsOnlyString appendString:stringToAdd];
        }
        else {
            if (i < originalCursorPosition) {
                (*cursorPosition)--;
            }
        }
    }
    
    return digitsOnlyString;
}
- (NSString *)insertSpacesEveryFourDigitsIntoString:(NSString *)string
                          andPreserveCursorPosition:(NSUInteger *)cursorPosition
{
    NSMutableString *stringWithAddedSpaces = [NSMutableString new];
    NSUInteger cursorPositionInSpacelessString = *cursorPosition;
    for (NSUInteger i=0; i<[string length]; i++) {
        if ((i>0) && ((i % 4) == 0)) {
            [stringWithAddedSpaces appendString:@"-"];
            if (i < cursorPositionInSpacelessString) {
                (*cursorPosition)++;
            }
        }
        unichar characterToAdd = [string characterAtIndex:i];
        NSString *stringToAdd =
        [NSString stringWithCharacters:&characterToAdd length:1];
        
        [stringWithAddedSpaces appendString:stringToAdd];
    }
    
    return stringWithAddedSpaces;
}
#pragma mark - UITextfield delegate methods -
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if (textField == _txtCardNumber)
//    {
//        previousTextFieldContent = textField.text;
//        previousSelection = textField.selectedTextRange;
//        
//        return YES;
//    }
//    else if (textField == _txtCardExpiryMonth)
//    {
//        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//        if (newString.length == 2)
//        {
//            if ([newString intValue] <= 12 )
//            {
//                _lblExpiryMonthLine.backgroundColor = [UIColor redColor];
//            }
//            else
//            {
//                _lblExpiryMonthLine.backgroundColor = [UIColor redColor];
////                [Utilities showToastMessage:@"Please Input Correct Month"];
//            }
//        }
//        return !(newString.length > 2);
//    }
//    else if (textField == _txtCardExpiryYear)
//    {
//        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"yyyy"];
//        NSString *yearString = [formatter stringFromDate:[NSDate date]];
//        NSString *lastTwoStr = [yearString substringWithRange:NSMakeRange(2, [yearString length]-2)];
//        if (newString.length == 2)
//        {
//            if (!([newString doubleValue] <= [lastTwoStr doubleValue] ))
//            {
//                _lblExpiryYearLine.backgroundColor = [UIColor redColor];
//            }
//            else
//            {
//                _lblExpiryYearLine.backgroundColor = [UIColor redColor];
////                [Utilities showToastMessage:@"Please Input Correct Year"];
//                
//            }
//        }
//        return !(newString.length > 2);
//    }
//    else if (textField == _txtCVVNumber)
//    {
//        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//        return !(newString.length > 4);
//    }
//    return YES;
//}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _txtEmail)
    {
        _lblLineEmail.backgroundColor = [UIColor redColor];
    }
  
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _txtEmail)
    {
        _lblLineEmail.backgroundColor = [UIColor blackColor];
    }
   
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)subscribeKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)unsubscribeKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    CGRect keyBoardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    
    UIScrollView *someScrollView = _shadowView;
    
    CGPoint tableViewBottomPoint = CGPointMake(0, CGRectGetMaxY([someScrollView bounds]));
    CGPoint convertedTableViewBottomPoint = [someScrollView convertPoint:tableViewBottomPoint
                                                                  toView:keyWindow];
    
    CGFloat keyboardOverlappedSpaceHeight = convertedTableViewBottomPoint.y - keyBoardFrame.origin.y;
    
    if (keyboardOverlappedSpaceHeight > 0)
    {
        [someScrollView setContentOffset:CGPointMake(0.0, 60) animated:YES];
    }
    
    /*[UIView animateWithDuration:0.8 delay:0.1 options:UIViewAnimationOptionTransitionNone animations:^{
        self.alpha = 1.0;
        _viewPopUpBox.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
     */
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    //UIEdgeInsets tableViewInsets = UIEdgeInsetsZero;
    UIScrollView *someScrollView = _shadowView;
    
            [someScrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
}

-(IBAction)onClickClose:(id)sender
{
    dictCardData = nil;
    [self endEditing:YES];
    isCancelled = YES;
    [self hide];
}

-(void)setLayout
{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    _viewPopUpBox.layer.cornerRadius = 6.0f;
    _viewPopUpBox.layer.borderColor = [UIColor clearColor].CGColor;
    _viewPopUpBox.layer.borderWidth = 1.0f;
    _viewPopUpBox.clipsToBounds = YES;
    
    _viewPopUpBox.multipleTouchEnabled = NO;

    _btnSubmit.layer.cornerRadius = 6.0f;
    _btnSubmit.layer.borderColor = [UIColor clearColor].CGColor;
    _btnSubmit.layer.borderWidth = 1.0f;
    _btnSubmit.clipsToBounds = YES;
    
    _btnCancel.layer.cornerRadius = 6.0f;
    _btnCancel.layer.borderColor = [UIColor clearColor].CGColor;
    _btnCancel.layer.borderWidth = 1.0f;
    _btnCancel.clipsToBounds = YES;
    
    
    
    _txtEmail.delegate = self;
    _lblLineEmail.backgroundColor = [UIColor blackColor];
    
    [_btnSubmit addTarget:self action:@selector(onClickSubmit:) forControlEvents:UIControlEventTouchUpInside];
    [_btnCancel addTarget:self action:@selector(onClickClose:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)onClickSubmit:(id)sender
{

    [self hide];
}

- (void) showWithCompletionBlock:(InputPopupCompletionBlock)completionBlock
{
    _showCompletionBlock = completionBlock;
    
    [self subscribeKeyboardNotifications];
        
    [self setLayout];
    _viewPopUpBox.frame = CGRectMake( _viewPopUpBox.frame.origin.x, (self.frame.size.height-_viewPopUpBox.frame.size.height)/2, _viewPopUpBox.frame.size.width, _viewPopUpBox.frame.size.height);
    
    _viewPopUpBox.alpha = 0.0;
    self.alpha = 0.0;
    
    UIWindow *mainWindow = [UIApplication sharedApplication].windows[0];
    [mainWindow addSubview:self];
    
    self.alpha = 1.0;
    _viewPopUpBox.alpha = 1.0;
    [self transitionInCompletion:^{
        
    }];
}

- (IBAction)btnSaveCardClicked:(id)sender
{
//    _btnSaveCard.selected = !_btnSaveCard.selected;
//
//    if (_btnSaveCard.selected)
//    {
////        _imgSaveUnsaveCard.image = radioButton_UnSelect;
//        _isSaveCard = NO;
//    }
//    else
//    {
////        _imgSaveUnsaveCard.image = radioButton_Select;
//        _isSaveCard = YES;
//    }
}

- (void)transitionInCompletion:(void(^)(void))completion
{
    switch (self.transitionStyle) {
        case MTInputAlertViewTransitionStyleSlideFromBottom:
        {
            CGRect rect = _viewPopUpBox.frame;
            CGRect originalRect = rect;
            rect.origin.y = self.bounds.size.height;
            _viewPopUpBox.frame = rect;
            [UIView animateWithDuration:0.3
                             animations:^{
                                 _viewPopUpBox.frame = originalRect;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case MTInputAlertViewTransitionStyleSlideFromTop:
        {
            CGRect rect = _viewPopUpBox.frame;
            CGRect originalRect = rect;
            rect.origin.y = -rect.size.height;
            _viewPopUpBox.frame = rect;
            [UIView animateWithDuration:0.3
                             animations:^{
                                 _viewPopUpBox.frame = originalRect;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case MTInputAlertViewTransitionStyleFade:
        {
            self.alpha = 0.0;
            _viewPopUpBox.alpha = 0;
            
            [UIView animateWithDuration:0.3
                             animations:^{
                                 self.alpha = 1.0;
                                 _viewPopUpBox.alpha = 1;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case MTInputAlertViewTransitionStyleBounce:
        {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            animation.values = @[@(0.01), @(1.2), @(0.9), @(1)];
            animation.keyTimes = @[@(0), @(0.4), @(0.6), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = 0.5;
            animation.delegate = self;
            [animation setValue:completion forKey:@"handler"];
            [_viewPopUpBox.layer addAnimation:animation forKey:@"bouce"];
        }
            break;
        case MTInputAlertViewTransitionStyleDropDown:
        {
            CGFloat y = _viewPopUpBox.center.y;
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
            animation.values = @[@(y - self.bounds.size.height), @(y + 20), @(y - 10), @(y)];
            animation.keyTimes = @[@(0), @(0.5), @(0.75), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = 0.4;
            animation.delegate = self;
            [animation setValue:completion forKey:@"handler"];
            [_viewPopUpBox.layer addAnimation:animation forKey:@"dropdown"];
        }
            break;
        default:
            break;
    }
}

- (void)transitionOutCompletion:(void(^)(void))completion
{
    switch (self.transitionStyle) {
        case MTInputAlertViewTransitionStyleSlideFromBottom:
        {
            CGRect rect = _viewPopUpBox.frame;
            rect.origin.y = self.bounds.size.height;
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 _viewPopUpBox.frame = rect;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case MTInputAlertViewTransitionStyleSlideFromTop:
        {
            CGRect rect = _viewPopUpBox.frame;
            rect.origin.y = -rect.size.height;
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 _viewPopUpBox.frame = rect;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case MTInputAlertViewTransitionStyleFade:
        {
            [UIView animateWithDuration:0.25
                             animations:^{
                                 self.alpha = 0.0;
                                 _viewPopUpBox.alpha = 0;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case MTInputAlertViewTransitionStyleBounce:
        {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            animation.values = @[@(1), @(1.2), @(0.01)];
            animation.keyTimes = @[@(0), @(0.4), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = 0.35;
            animation.delegate = self;
            [animation setValue:completion forKey:@"handler"];
            [_viewPopUpBox.layer addAnimation:animation forKey:@"bounce"];
            
            _viewPopUpBox.transform = CGAffineTransformMakeScale(0.01, 0.01);
        }
            break;
        case MTInputAlertViewTransitionStyleDropDown:
        {
            CGPoint point = _viewPopUpBox.center;
            point.y += self.bounds.size.height;
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 _viewPopUpBox.center = point;
                                 CGFloat angle = ((CGFloat)arc4random_uniform(100) - 50.f) / 100.f;
                                 _viewPopUpBox.transform = CGAffineTransformMakeRotation(angle);
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        default:
            break;
    }
}

-(void)hide
{
    [self unsubscribeKeyboardNotifications];
    
    [self transitionOutCompletion:^{
        
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             
                             self.alpha = 0.0;
                             _viewPopUpBox.alpha = 0.0;
                         }
                         completion:^(BOOL finished) {
                             [self removeFromSuperview];
                             _showCompletionBlock(isCancelled, dictCardData);
                             
                         }];
    }];
}

#pragma mark - CAAnimation delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    void(^completion)(void) = [anim valueForKey:@"handler"];
    if (completion) {
        completion();
    }
}

@end
