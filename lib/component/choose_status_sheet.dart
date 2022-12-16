import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sup_chat/component/button_wrapper.dart';
import 'package:sup_chat/model/status.dart';
import 'package:sup_chat/model/user_status.dart';
import 'package:sup_chat/service/status_service.dart';
import 'package:sup_chat/service/user_service.dart';

class StatusSelectionSheet extends StatefulWidget {
  final UserStatus userStatus;
  const StatusSelectionSheet({Key? key, required this.userStatus})
      : super(key: key);

  @override
  State<StatusSelectionSheet> createState() => _StatusSelectionSheetState();
}

class _StatusSelectionSheetState extends State<StatusSelectionSheet> {
  final TextEditingController textController = TextEditingController();
  late StatusType newStatusType;

  @override
  void initState() {
    newStatusType = widget.userStatus.statusType ?? StatusType.INVALID;
    textController.text = widget.userStatus.comment ?? '';
    print("_StatusSelectionSheetState ${widget.userStatus}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 400,
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
                child: Text('상태 선택',
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
              Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: StatusType.values.length,
                    itemBuilder: ((context, index) => InkWell(
                          onTap: () {
                            setState(() {
                              newStatusType = StatusType.values[index];
                            });
                          },
                          child: StatusSelectionItem(
                            type: StatusType.values[index],
                            checked: newStatusType == StatusType.values[index],
                          ),
                        )),
                  )),
              buildStatusSaveButton()
            ],
          )),
    );
  }

  Widget buildStatusSaveButton() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
      child: ButtonWrapper(
        onPressed: () async {
          if (widget.userStatus.comment != textController.text ||
              widget.userStatus.statusType != newStatusType) {
            // TODO: show indicator
            widget.userStatus.comment = textController.text;
            widget.userStatus.statusType = newStatusType;
            final user = Get.find<UserService>().currentUser.value;
            await widget.userStatus.update(user.uid);
          }
          Get.back(result: widget.userStatus);
        },
        text: '선택완료',
        options: ButtonWrapperOption(
          width: double.infinity,
          height: 40,
          color: Theme.of(context).primaryColor,
          textStyle: Theme.of(context).textTheme.titleSmall,
          borderSide: const BorderSide(
            color: Colors.transparent,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }
}

class StatusSelectionItem extends StatelessWidget {
  final StatusType type;
  final bool checked;
  const StatusSelectionItem(
      {Key? key, required this.type, required this.checked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                mapStatusTypeToIcon[type],
                color: Theme.of(context).iconTheme.color,
                size: 50,
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                child: Text(
                  mapStatusTypeToString[type] ?? '잘못된상태',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
          child: Theme(
            data: ThemeData(
                checkboxTheme: const CheckboxThemeData(
                  shape: CircleBorder(),
                ),
                unselectedWidgetColor:
                    Theme.of(context).scaffoldBackgroundColor),
            child: Checkbox(
                value: checked,
                onChanged: (newValue) async {},
                activeColor: Theme.of(context).colorScheme.tertiary),
          ),
        ),
      ],
    );
  }
}
