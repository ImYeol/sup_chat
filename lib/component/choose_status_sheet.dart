import 'package:flutter/material.dart';
import 'package:sup_chat/component/button_wrapper.dart';
class ChooseStatusSheet extends StatelessWidget {
  final TextEditingController textController = TextEditingController();
  ChooseStatusSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
  mainAxisSize: MainAxisSize.max,
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
    Container(
      width: double.infinity,
      height: 500,
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
        child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                        child: Material(
                          color: Colors.transparent,
                          elevation: 1,
                          child: Container(
                            width: 45,
                            height: 1,
                            decoration: BoxDecoration(
                              color: Theme.of(context).shadowColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: textController,
                    autofocus: true,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: '상태 메시지를 입력해주세요',
                      hintStyle: Theme.of(context).textTheme.labelMedium,
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      errorBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      focusedErrorBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                    ),
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  Divider(
                    thickness: 1,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 5),
                    child: Text(
                      '상태 선택',
                      style: Theme.of(context).textTheme.bodyMedium
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: const [
                        StatusSelectionItem()
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                    child: ButtonWrapper(
                      onPressed: () {
                        print('StatusSelectionButton pressed ...');
                      },
                      text: '선택완료',
                      options: ButtonWrapperOption(
                        width: double.infinity,
                        height: 50,
                        color: Theme.of(context).primaryColor,
                        textStyle:
                            Theme.of(context).textTheme.bodyMedium,
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ],
              ),
            )
      ),
    ),
  ],
);
  }
}

class StatusSelectionItem extends StatelessWidget {
  const StatusSelectionItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(
              12, 8, 12, 8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.set_meal,
                color: Theme.of(context).iconTheme.color,
                size: 50,
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                    20, 0, 0, 0),
                child: Text(
                  '식사중',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding:
              EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
          child: Theme(
            data: ThemeData(
              checkboxTheme: const CheckboxThemeData(
                shape: CircleBorder(),
              ),
              unselectedWidgetColor:
                  Theme.of(context).scaffoldBackgroundColor
            ),
            child: Checkbox(
              value: false,
              onChanged: (newValue) async {
              },
              activeColor: Theme.of(context).colorScheme.tertiary
            ),
          ),
        ),
      ],
    );
  }
}

