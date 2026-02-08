import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testapp/features/customer_dashboard/home/widgets/personal_details.dart';
import '../../../../core/const/app_colors.dart';
import '../../../../core/const/images_path.dart';

class CustomAppDrawer extends StatelessWidget {
  final void Function()? onLogoutTap;
  const CustomAppDrawer({super.key, this.onLogoutTap});

  @override
  Widget build(BuildContext context) {
    //final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;

    return Drawer(
      backgroundColor: AppColors.textColor,
      child: SafeArea(
        child: Container(
          color: AppColors.textColor,
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: sw*0.076),
          child:
          /// Personal Info section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(ImagesPath.logo, width: 82, height: 70),
              SizedBox(height: 20),
              /// Personal Info Section
              PersonalDetails(),
            ],
          ),
        ),
      ),
    );
  }
}
