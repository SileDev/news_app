import 'package:flutter/material.dart';

class NewsCard extends StatelessWidget {
  final int postIndex;
  final String? providerName, postTitle, imageUrl, postContent;
  const NewsCard({
    Key? key,
    required this.postIndex,
    this.providerName,
    this.postTitle,
    this.imageUrl,
    this.postContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Color(0xffc7c7c7),
            width: 2,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              providerName == null ? "$postIndex" : "$postIndex. $providerName",
              maxLines: 1,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
          if (postTitle != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                postTitle!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          if (imageUrl != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: FadeInImage.assetNetwork(
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                    image: imageUrl!,
                    placeholder: 'lib/assets/placeholder.jpg',
                    imageErrorBuilder: (context, error, stackTraces) {
                      return const Image(
                          image: NetworkImage(
                              "https://images.wsj.net/im-606417/social"));
                    },
                  ),
                ),
              ),
            ),
          if (postContent != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                postContent!,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              children: const [
                Expanded(
                  child: IconButton(
                    onPressed: null,
                    splashRadius: 20,
                    tooltip: "Rate Up",
                    icon: Icon(
                      Icons.thumb_up_off_alt_outlined,
                      color: Color(0xffff6060),
                    ),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    onPressed: null,
                    tooltip: "Comments",
                    splashRadius: 20,
                    icon: Icon(
                      Icons.insert_comment_outlined,
                      color: Color(0xff6060b0),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
