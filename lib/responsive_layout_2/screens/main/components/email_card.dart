import 'package:flutter/material.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../constants.dart';
import '../../../extensions.dart';
import '../../../models/email.dart';

class EmailCard extends StatelessWidget {
  final bool isActive;
  final Email email;
  final VoidCallback press;
  const EmailCard({
    Key? key,
    this.isActive = true,
    required this.email,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
      child: Material(
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: press,
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(kDefaultPadding),
                decoration: BoxDecoration(
                  color: isActive ? kPrimaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 32,
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage: AssetImage(email.image),
                          ),
                        ),
                        const SizedBox(width: kDefaultPadding / 2),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              text: '${email.name} \n',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: isActive ? Colors.white : kTextColor,
                              ),
                              children: [
                                TextSpan(
                                  text: email.subject,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(
                                        color: isActive
                                            ? Colors.white
                                            : kTextColor,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              email.time,
                              style:
                                  Theme.of(context).textTheme.caption!.copyWith(
                                        color: isActive ? Colors.white70 : null,
                                      ),
                            ),
                            const SizedBox(height: 5),
                            if (email.isAttachmentAvailable)
                              WebsafeSvg.asset(
                                'assets/icons/Paperclip.svg',
                                color: isActive ? Colors.white70 : kGrayColor,
                              )
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: kDefaultPadding / 2),
                    Text(
                      email.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.caption!.copyWith(
                            height: 1.5,
                            color: isActive ? Colors.white70 : null,
                          ),
                    )
                  ],
                ),
              ).addNeumorphism(
                blurRadius: 15,
                borderRadius: 15,
                offset: const Offset(5, 5),
                topShadowColor: Colors.white60,
                bottomShadowColor: const Color(0xFF234395).withOpacity(0.15),
              ),
              if (!email.isChecked)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    height: 12,
                    width: 12,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: kBadgeColor,
                    ),
                  ).addNeumorphism(
                    blurRadius: 4,
                    borderRadius: 8,
                    offset: const Offset(2, 2),
                  ),
                ),
              if (email.tagColor != null)
                Positioned(
                  left: 8,
                  top: 0,
                  child: WebsafeSvg.asset(
                    'assets/icons/Markup filled.svg',
                    height: 18,
                    color: email.tagColor,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
