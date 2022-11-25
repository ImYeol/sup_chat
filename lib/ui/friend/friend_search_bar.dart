import 'package:flutter/material.dart';
import 'package:sup_chat/component/icon_button_wrapper.dart';

class FriendSearchBar extends StatelessWidget {
  EdgeInsetsGeometry? padding;
  TextEditingController? textEdittingController;

  FriendSearchBar({Key? key, this.padding, this.textEdittingController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsetsDirectional.fromSTEB(16, 8, 16, 12),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: TextFormField(
              controller: textEdittingController,
              onChanged: (_) {},
              // onChanged: (_) => EasyDebounce.debounce(
              //   'textController',
              //   Duration(milliseconds: 2000),
              //   () => setState(() {}),
              // ),
              autofocus: true,
              obscureText: false,
              decoration: InputDecoration(
                labelText: 'Search members...',
                labelStyle: Theme.of(context).textTheme.labelSmall,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0x00000000),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0x00000000),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.background,
              ),
              style: Theme.of(context).textTheme.labelMedium,
              maxLines: null,
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
            child: IconButtonWrapper(
              borderColor: Colors.transparent,
              borderRadius: 30,
              borderWidth: 1,
              buttonSize: 44,
              icon: Icon(
                Icons.search_rounded,
                color: Theme.of(context).iconTheme.color,
                size: 24,
              ),
              onPressed: () {
                print('IconButton pressed ...');
              },
            ),
          ),
        ],
      ),
    );
  }
}
