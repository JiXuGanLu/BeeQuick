//
//  YBZYAddressEditFillCell.m
//  BeeQuick
//
//  Created by 黄叶青 on 2016/10/28.
//  Copyright © 2016年 YBZY. All rights reserved.
//

#import "YBZYAddressEditFillCell.h"

@interface YBZYAddressEditFillCell () <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, weak) UITextField *inputTextField;

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) YBZYCityGroupModel *selectedCityGroup;

@end

@implementation YBZYAddressEditFillCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didInput) name:UITextFieldTextDidChangeNotification object:nil];
    
    UILabel *titleLabel = [UILabel ybzy_labelWithText:@"嗯嗯嗯嗯" andTextColor:YBZYCommonDarkTextColor andFontSize:16];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UITextField *inputTextField = [[UITextField alloc] init];
    inputTextField.font = YBZYCommonBigFont;
    [inputTextField setTextColor:YBZYCommonDarkTextColor];
    inputTextField.delegate = self;
    [self.contentView addSubview:inputTextField];
    self.inputTextField = inputTextField;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.offset(16);
        make.width.offset(80);
    }];
    
    [inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(titleLabel.mas_right).offset(20);
        make.right.offset(-16);
    }];
}

- (void)setTitle:(NSString *)title {
    _title = title.copy;
    
    self.titleLabel.text = title;
}

- (void)setPlaceHolderString:(NSString *)placeHolderString {
    _placeHolderString = placeHolderString.copy;
    
    [self.inputTextField setPlaceholder:placeHolderString];
}

- (void)setOriginalString:(NSString *)originalString {
    _originalString = originalString.copy;
    
    [self.inputTextField setText:originalString];
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    _keyboardType = keyboardType;
    
    [self.inputTextField setKeyboardType:keyboardType];
}

- (void)setCityGroups:(NSArray<YBZYCityGroupModel *> *)cityGroups {
    _cityGroups = cityGroups;
    
    self.selectedCityGroup = cityGroups.firstObject;
}

- (void)setIsPickerInput:(BOOL)isPickerInput {
    _isPickerInput = isPickerInput;
    
    if (isPickerInput) {
        self.inputTextField.inputView = self.pickerView;
        
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, YBZYScreenWidth, 44)];
        toolBar.backgroundColor = [UIColor whiteColor];
        toolBar.barStyle = UIBarStyleDefault;
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonClick:)];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonClick:)];
        UIBarButtonItem *spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UILabel *titleLabel = [UILabel ybzy_labelWithText:@"请选择你所在的城市" andTextColor:YBZYCommonLightTextColor andFontSize:16];
        [toolBar setItems:[NSArray arrayWithObjects:cancelButton, spaceButton, doneButton, nil]];
        [toolBar addSubview:titleLabel];
        [titleLabel sizeToFit];
        titleLabel.center = toolBar.center;
        self.inputTextField.inputAccessoryView = toolBar;
    } else {
        self.inputTextField.inputView = nil;
    }
}

- (void)doneButtonClick:(UIButton *)sender {
    if ([self.pickerView selectedRowInComponent:0] == 0 && [self.pickerView selectedRowInComponent:1] == 0) {
        self.inputTextField.text = @"北京";
    }
    
    [self.inputTextField resignFirstResponder];
}

- (void)cancelButtonClick:(UIButton *)sender {
    [self.inputTextField resignFirstResponder];
}

- (void)didInput {
    if (self.inputBlock) {
        self.inputBlock(self.inputTextField.text);
    }
}

#pragma mark - textfield代理

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.inputBlock) {
        self.inputBlock(textField.text);
    }
}

#pragma mark - pickerview代理

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.cityGroups.count;
    }
    return self.selectedCityGroup.cities.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return self.cityGroups[row].title;
    }
    return self.selectedCityGroup.cities[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.selectedCityGroup = self.cityGroups[row];
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:false];
        self.inputTextField.text = self.selectedCityGroup.cities.firstObject;
    } else {
        self.inputTextField.text = self.selectedCityGroup.cities[row];
    }
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
        _pickerView.backgroundColor = [UIColor colorWithWhite:0.99 alpha:0.7];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.showsSelectionIndicator = true;
    }
    return _pickerView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
