class ShowDialog {
  String title;
  String description;
  String buttonTitle;

  ShowDialog({String title, String description, String buttonTitle}) {
    title = title ?? 'Enter Password';
    description = description ??
        'Type the same password that you set while creating the wallet';
    buttonTitle = buttonTitle ?? 'Confirm';
  }
}
