import 'package:flutter/material.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../constants.dart';
import '../../models/email.dart';
import 'components/header.dart';

class EmailScreen extends StatelessWidget {
  final Email email;
  const EmailScreen({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Header(),
            const Divider(thickness: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      maxRadius: 24,
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage(email.image),
                    ),
                    const SizedBox(width: kDefaultPadding),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        text: email.name,
                                        style:
                                            Theme.of(context).textTheme.button,
                                        children: [
                                          TextSpan(
                                              text:
                                                  '<elvia.atkins@gmail.com> to Jerry Torp',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      email.subject,
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: kDefaultPadding / 2),
                              Text(
                                'Today at ${email.time}',
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                          const SizedBox(height: kDefaultPadding),
                          LayoutBuilder(
                            builder: (context, constraints) => SizedBox(
                              width: constraints.maxWidth > 850
                                  ? 800
                                  : constraints.maxWidth,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    email.body,
                                    style: const TextStyle(
                                      height: 1.5,
                                      color: Color(0xFF4D5875),
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  const SizedBox(height: kDefaultPadding),
                                  Row(
                                    children: [
                                      if (email.isAttachmentAvailable)
                                        const Text(
                                          '6 attachments',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      const Spacer(),
                                      Text(
                                        'Download All',
                                        style:
                                            Theme.of(context).textTheme.caption,
                                      ),
                                      const SizedBox(
                                          width: kDefaultPadding / 4),
                                      WebsafeSvg.asset(
                                        'assets/icons/Download.svg',
                                        height: 16,
                                        color: kGrayColor,
                                      ),
                                    ],
                                  ),
                                  const Divider(thickness: 1),
                                  const SizedBox(height: kDefaultPadding / 2),
                                  const SizedBox(
                                    height: 200,
                                    // child: StaggeredGrid.countBuilder(
                                    //   physics:
                                    //       const NeverScrollableScrollPhysics(),
                                    //   crossAxisCount: 4,
                                    //   itemCount: 3,
                                    //   itemBuilder:
                                    //       (BuildContext context, int index) =>
                                    //           ClipRRect(
                                    //     borderRadius:
                                    //         BorderRadius.circular(8),
                                    //     child: Image.asset(
                                    //       'assets/images/Img_$index.png',
                                    //       fit: BoxFit.cover,
                                    //     ),
                                    //   ),
                                    //   staggeredTileBuilder: (int index) =>
                                    //       StaggeredTile.count(
                                    //     2,
                                    //     index.isOdd ? 2 : 1,
                                    //   ),
                                    //   mainAxisSpacing: kDefaultPadding,
                                    //   crossAxisSpacing: kDefaultPadding,
                                    // ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
