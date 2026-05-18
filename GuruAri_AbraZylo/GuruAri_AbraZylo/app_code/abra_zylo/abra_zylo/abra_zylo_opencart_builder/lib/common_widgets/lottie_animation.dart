import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:oc_demo/constants/app_constants.dart';

class LottieAnimation extends StatelessWidget {
  const LottieAnimation({
    required this.title,
    required this.buttonTitle,
    required this.lottiePath,
    required this.onPressed,
    required this.subtitle,
    Key? key,
  }) : super(key: key);

  final String lottiePath, title, subtitle, buttonTitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SizedBox(
          height: AppSizes.deviceHeight / 2,
          width: AppSizes.deviceWidth - 50,
          child: Card(
            color: Theme.of(context).cardColor,
            child: Column(
              children: <Widget>[
                Lottie.asset(
                  lottiePath,
                  width: AppSizes.deviceWidth / 2,
                  height: AppSizes.deviceHeight / 3.5,
                  fit: BoxFit.fill,
                  repeat: true,
                ),
                Text(title, style: Theme.of(context).textTheme.displaySmall),
                const Padding(padding: EdgeInsets.all(AppSizes.size4)),
                Text(
                  subtitle,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.normal),
                ),
                const Padding(padding: EdgeInsets.all(AppSizes.size8)),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: AppSizes.size18, horizontal: AppSizes.size18),
                    // shape: const RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.zero
                    // ),
                    // elevation: 0,
                  ),
                  onPressed: onPressed,
                  child: Text(
                    buttonTitle,
                    style: const TextStyle(color: AppColors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget lottieAnimation(BuildContext context, String lottiePath, String title,
//     String subtitle, String buttonTitle, VoidCallback? callback) {
//   return Center(
//     child: SingleChildScrollView(
//       physics: const NeverScrollableScrollPhysics(),
//       child: Card(
//         elevation: 0,
//         child: Container(
//           height: AppSizes.deviceHeight / 2,
//           width: AppSizes.deviceWidth - 50,
//           decoration: BoxDecoration(
//             border: Border.all(
//                 width: 1.0,
//                 color: Theme.of(context).colorScheme.secondaryContainer),
//           ),
//           child: Column(children: [
//             Lottie.asset(lottiePath,
//                 width: AppSizes.deviceWidth / 2,
//                 height: AppSizes.deviceHeight / 3.5,
//                 fit: BoxFit.fill,
//                 repeat: false),
//             Text(title, style: Theme.of(context).textTheme.displaySmall),
//             const Padding(padding: EdgeInsets.all(AppSizes.size4)),
//             Text(
//               subtitle,
//               style: Theme.of(context)
//                   .textTheme
//                   .bodyLarge
//                   ?.copyWith(fontWeight: FontWeight.normal),
//             ),
//             const Padding(padding: EdgeInsets.all(AppSizes.size8)),
//             ElevatedButton(
//                 onPressed: callback,
//                 style: ElevatedButton.styleFrom(primary: AppColors.black),
//                 child: Text(
//                   buttonTitle,
//                   style: const TextStyle(color: AppColors.white),
//                 ))
//           ]),
//         ),
//       ),
//     ),
//   );
// }
