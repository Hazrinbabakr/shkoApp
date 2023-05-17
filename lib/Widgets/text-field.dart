import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shko/helper/colors.dart';



class TextFieldFormInput extends StatelessWidget {
  final String? title;
  final TextInputType? inputType;
  final bool required;
  final String ?initialValue;
  final TextEditingController? controller;
  final bool password;
  final bool readOnly;
  final VoidCallback? onTap;


  const TextFieldFormInput({Key? key,
    this.title,this.controller, this.inputType, this.required = false,this.initialValue, this.password = false,this.readOnly = false, this.onTap}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            "$title ${required?"*":""}",
            style: const TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 16
            )
        ),
        const SizedBox(height: 8,),
        TextFieldWidget(
          controller: controller,
          initValue: initialValue,
          maxLines: 1,
          readOnly: readOnly,
          onTap: onTap,
          obscureText: password,
          inputType: inputType,
          validator: (String? text){
            if(inputType == TextInputType.emailAddress){
              if(text!.isEmpty && !required) return null;
              if(text.isEmpty) return "required";
              //if(Helper.isEmail(text)) return "invalid email";
              return null;
            }
            else{
              if(!required) return null;
              if(text!.isEmpty) return "required";
            }
            return null;
          },
        )
      ],
    );
  }

}



class TextFieldWidget extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onSubmitted;
  final FormFieldSetter<String>? onSave;
  final String? hint;
  final String? initValue;
  final TextInputType? inputType;
  final int? maxLines;
  final String? label;
  final bool withBorder;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final Widget? icon;
  final Widget? prefix;
  final Color?  fillColor;
  final bool obscureText;

  const TextFieldWidget(
      {
        Key? key,
        this.onChanged,
        this.validator,
        this.onSave,
        this.hint,
        this.initValue,
        this.inputType,
        this.maxLines,
        this.label,
        this.withBorder = true,
        this.readOnly = false,
        this.onTap,
        this.controller,
        this.icon,
        this.onSubmitted,
        this.fillColor,
        this.prefix,
        this.obscureText = false
      })
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      controller: controller,
      initialValue: initValue,
      onFieldSubmitted: onSubmitted,
      onSaved: onSave,
      cursorHeight: 20,
      cursorColor: Theme.of(context).primaryColor,
      //cursorColor: AppColors.accentColor,
      maxLines: maxLines,
      onTap: onTap,
      readOnly: readOnly,
      obscureText: obscureText,
      keyboardType: inputType,
      inputFormatters: inputType == TextInputType.number
          ? [FilteringTextInputFormatter.digitsOnly]
          : [],
      validator: validator,
      style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: fillColor == null ? null : Colors.black
      ),
      decoration: InputDecoration(
        isDense: true,
        filled: fillColor != null,
        fillColor: fillColor,
        hintText: hint ?? "",
        labelText: label,
        //labelStyle: AppTextStyle.mediumBlack,
        suffixIcon: icon,

        prefixIcon: prefix,
        hintStyle: const TextStyle(fontSize: 12),
        contentPadding: EdgeInsets.symmetric(
            vertical: label == null ? 14 : 14, horizontal: 8),
        border: !withBorder
            ? InputBorder.none
            : OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
                color: AppColors.accent,
                width: 0.7
            )
        ),
        focusedBorder: !withBorder
            ? InputBorder.none
            : OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
                color: AppColors.accent,
              width: 0.7
            )),
        enabledBorder: !withBorder
            ? InputBorder.none
            : OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
                color: AppColors.accent,
                width: 0.7
            )
        ),
      ),
    );
  }
}

//
// class DropDownFieldWidget<T> extends StatelessWidget {
//   final ValueChanged<T?>? onChanged;
//   final FormFieldValidator<T>? validator;
//   final ValueChanged<T>? onSubmitted;
//   final FormFieldSetter<T>? onSave;
//   final String? hint;
//   final String? initValue;
//   final TextInputType? inputType;
//   final int? maxLines;
//   final String? label;
//   final bool withBorder;
//   final bool readOnly;
//   final VoidCallback? onTap;
//   final TextEditingController? controller;
//   final Widget? icon;
//   final Widget? prefix;
//   final Color? fillColor;
//   final bool obscureText;
//   final List<DropdownMenuItem<T>> items;
//   final T? value;
//
//   const DropDownFieldWidget(
//       {
//         Key? key,
//         this.onChanged,
//         this.validator,
//         this.onSave,
//         this.hint,
//         this.initValue,
//         this.inputType,
//         this.maxLines,
//         this.label,
//         this.withBorder = true,
//         this.readOnly = false,
//         this.onTap,
//         this.controller,
//         this.icon,
//         this.onSubmitted,
//         this.fillColor,
//         this.prefix,
//         this.obscureText = false,
//         required this.items,
//         this.value
//       })
//       : super(key: key);
//
//
//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonFormField<T>(
//       onChanged: onChanged,
//       onSaved: onSave,
//       validator: validator,
//       value: value,
//       style: TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.w500,
//           color: fillColor == null ? Colors.black : Colors.black
//       ),
//       decoration: InputDecoration(
//         isDense: true,
//         filled: fillColor != null,
//         fillColor: fillColor,
//         hintText: hint ?? "",
//         labelText: label,
//         //labelStyle: AppTextStyle.mediumBlack,
//         suffixIcon: icon,
//         prefixIcon: prefix,
//         hintStyle: const TextStyle(fontSize: 12),
//         contentPadding: EdgeInsets.symmetric(
//             vertical: label == null ? 8 : 14, horizontal: 8),
//         border: !withBorder
//             ? InputBorder.none
//             : OutlineInputBorder(
//             borderRadius: BorderRadius.circular(5),
//             borderSide: const BorderSide(
//                 color: darkcolor
//             )
//         ),
//         focusedBorder: !withBorder
//             ? InputBorder.none
//             : OutlineInputBorder(
//             borderRadius: BorderRadius.circular(5),
//             borderSide: const BorderSide(
//                 color: darkcolor
//             )),
//         enabledBorder: !withBorder
//             ? InputBorder.none
//             : OutlineInputBorder(
//             borderRadius: BorderRadius.circular(5),
//             borderSide: const BorderSide(
//                 color: darkcolor
//             )
//         ),
//       ),
//       items: items,
//
//
//     );
//   }
// }
//
