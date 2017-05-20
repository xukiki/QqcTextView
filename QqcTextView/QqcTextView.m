//
//  QqcTextView.m
//  QqcTextView
//
//  Created by 王刚 on 15/10/16.
//  Copyright © 2015年 王刚. All rights reserved.
//

#import "QqcTextView.h"

@interface QqcTextViewSupport : NSObject <UITextViewDelegate>

@property (nonatomic, weak) id<UITextViewDelegate> delegate;

@end
@implementation QqcTextViewSupport

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    QqcTextView *t = (QqcTextView *)textView;
    
    if([self.delegate respondsToSelector:@selector(textViewShouldBeginEditing:)])
        return [self.delegate textViewShouldBeginEditing:textView];
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    QqcTextView *t = (QqcTextView *)textView;
    if (t.text.length == 0) {
        t.placeholderLabel.hidden = NO;
    } else {
        t.placeholderLabel.hidden = YES;
    }
    
    if([self.delegate respondsToSelector:@selector(textViewShouldEndEditing:)])
        return [self.delegate textViewShouldEndEditing:textView];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if([self.delegate respondsToSelector:@selector(textViewDidBeginEditing:)])
        [self.delegate textViewDidBeginEditing:textView];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if([self.delegate respondsToSelector:@selector(textViewDidEndEditing:)])
        [self.delegate textViewDidEndEditing:textView];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSInteger maxLength = ((QqcTextView *)textView).maxLength;
    if (maxLength > 0) {
        //增加文字
        if (text.length > 0) {
            if (range.location >= maxLength || textView.text.length >= maxLength) {
                return NO;
            } else {
                return YES;
            }
        } else { //减少文字
            return YES;
        }
    } else {
        return YES;
    }

}

- (void)textViewDidChange:(UITextView *)textView {
    
    QqcTextView *t = (QqcTextView *)textView;
    NSInteger maxLength = t.maxLength;

    if (maxLength > 0) {
        if (t.markedTextRange == nil && maxLength > 0 && t.text.length > maxLength) {
            t.text = [t.text substringToIndex:maxLength];
        }
    }
    
    if (t.text.length == 0) {
        t.placeholderLabel.hidden = NO;
    } else {
        t.placeholderLabel.hidden = YES;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.delegate textViewDidChange:t];
    }

}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    if([self.delegate respondsToSelector:@selector(textViewDidChangeSelection:)])
        [self.delegate textViewDidChangeSelection:textView];
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if([self.delegate respondsToSelector:@selector(textView:shouldInteractWithURL:inRange:)])
        return [self.delegate textView:textView shouldInteractWithURL:URL inRange:characterRange];
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange {
    if([self.delegate respondsToSelector:@selector(textView:shouldInteractWithTextAttachment:inRange:)])
        return [self.delegate textView:textView shouldInteractWithTextAttachment:textAttachment inRange:characterRange];
    return YES;
}


-(void)setDelegate:(id<UITextViewDelegate>)dele{
    _delegate = dele;
}

@end


@interface QqcTextView()

@property (nonatomic, strong) QqcTextViewSupport *textViewSupport;


@end

@implementation QqcTextView

- (void)awakeFromNib
{
    [self doInit];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self doInit];
    }
    return self;
}

- (void)doInit
{
    [self addSubview:self.placeholderLabel];
    [self addPlaceholderConstraint];
    super.delegate = self.textViewSupport;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (QqcTextViewSupport *)textViewSupport
{
    if (nil == _textViewSupport) {
        _textViewSupport = [[QqcTextViewSupport alloc] init];
    }
    
    return _textViewSupport;
}


#pragma mark - setter

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        
        _placeholderLabel = [[UILabel alloc]init];
        _placeholderLabel.font = [UIFont systemFontOfSize:16];
        _placeholderLabel.numberOfLines = 0;
        _placeholderLabel.textColor = color_cccccc_qqc;
        _placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _placeholderLabel;
}

- (void)addPlaceholderConstraint
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:8]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:6]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-12]];
    
    [self layoutIfNeeded];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.placeholderLabel.text = _placeholder;
    
}

-(void)setDelegate:(id<UITextViewDelegate>)deleg{
    self.textViewSupport.delegate = deleg;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    if (str_is_exist_qqc(text)) {
        self.placeholderLabel.hidden = YES;
    }
}

@end
