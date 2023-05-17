import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shko/helper/colors.dart';
import 'package:shko/localization/AppLocal.dart';

const kMaxTextLength = 500;

class AddressTextFieldItem extends StatefulWidget {
  final FormFieldValidator<String>? validator;
  final bool isOptional;
  final String title;
  final String? hint;
  final TextEditingController? controller;
  final int maxLines;
  final bool canEdit;
  final FocusNode? next;
  final FocusNode? current;
  final int? maxLength;

  const AddressTextFieldItem({
    Key? key,
    this.validator,
    this.isOptional = false,
    required this.title,
    this.hint,
    this.controller,
    this.maxLines = 1,
    this.canEdit = true,
    this.next,
    this.current,
    this.maxLength
  }) : super(key: key);

  @override
  _AddressTextFieldItemState createState() => _AddressTextFieldItemState();
}

class _AddressTextFieldItemState extends State<AddressTextFieldItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if(widget.title.isNotEmpty)
        Row(
          children: [
            Text(
              widget.title,
              style: TextStyle(fontSize: 14  , fontWeight: FontWeight.w300),
            ),
            !widget.isOptional
                ? Text(
                    " *",
                    style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.secondary),
                  )
                : const SizedBox()
          ],
        ),
        TextFormField(
            validator: widget.validator ??
                (text) {
                  if (widget.isOptional) {
                    return null;
                  }
                  if (text!.trim().isEmpty) {
                    return AppLocalizations.of(context)
                        .trans("fieldIsRequired");
                  }
                  return null;
                },
            controller: widget.controller,
            focusNode: widget.current,
            inputFormatters: [
              LengthLimitingTextInputFormatter(widget.maxLength??kMaxTextLength)
            ],
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16
            ),
            onFieldSubmitted: (txt) {
              if (widget.next != null) {
                FocusScope.of(context).requestFocus(widget.next);
              }
            },
            maxLines: widget.maxLines,
            readOnly: !widget.canEdit,
            cursorColor: Theme.of(context).colorScheme.secondary,
            // style: TextStyle(
            //   color: Colors.black
            // ),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                fontWeight: FontWeight.w300
              ),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).dividerColor,
                      width: 1
                  )
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 1
                  )
              ),
            )
        ),
      ],
    );
  }
}
