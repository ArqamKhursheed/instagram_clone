import 'package:flutter/material.dart';
import 'package:instagram_clone/Resources/firestore_methods.dart';
import 'package:instagram_clone/Utils/colors.dart';
import 'package:instagram_clone/Widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Models/user.dart';
import '../provider/user_provider.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimation = false;

  @override
  Widget build(BuildContext context) {
    final User? _user = Provider.of<UserProvider>(context).getUser as User?;
    return _user == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            color: mobileBackgroundColor,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8)
                          .copyWith(right: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(widget.snap['profImage']),
                            radius: 18,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.snap['username'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return SimpleDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                children: <Widget>[
                                  SimpleDialogOption(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 16),
                                    child: const Text(
                                      'Delete',
                                      textAlign: TextAlign.center,
                                    ),
                                    onPressed: () async {},
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.more_vert_outlined),
                      ),
                    ],
                  ),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    GestureDetector(
                      onDoubleTap: () async {
                        await FirestoreMethods().likePost(
                            uid: _user.uid,
                            likes: widget.snap['likes'],
                            postId: widget.snap['postId']);
                        setState(() {
                          isLikeAnimation = true;
                        });
                      },
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35,
                        width: double.infinity,
                        child: Image.network(
                          widget.snap['postUrl'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: isLikeAnimation ? 1 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: LikeAnimation(
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 90,
                        ),
                        isAnimating: isLikeAnimation,
                        duration: const Duration(milliseconds: 400),
                        onEnd: () {
                          setState(() {
                            isLikeAnimation = false;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    LikeAnimation(
                      isAnimating: widget.snap['likes'].contains(
                        _user.uid,
                      ),
                      smallLike: true,
                      child: IconButton(
                        onPressed: () async {
                          await FirestoreMethods().likePost(
                              uid: _user.uid,
                              likes: widget.snap['likes'],
                              postId: widget.snap['postId']);
                        },
                        icon: widget.snap['likes'].contains(
                          _user.uid,
                        )
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : const Icon(
                                Icons.favorite_border_outlined,
                                color: Colors.white,
                              ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.comment,
                        // color: Colors.red,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.send,
                        // color: Colors.red,
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.bookmark_outline,
                            // color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.snap['likes'].length} likes',
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 4),
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(color: primaryColor),
                            children: [
                              TextSpan(
                                text: widget.snap['username'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              TextSpan(
                                text: '  ${widget.snap['description']}',
                                // style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.only(top: 6),
                          width: double.infinity,
                          child: Text(
                            'View all 200 comments',
                            style: const TextStyle(
                                fontSize: 15, color: secondaryColor),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            DateFormat.yMMMd().format(
                              widget.snap['datePublished'].toDate(),
                            ),
                            style: const TextStyle(
                                fontSize: 14, color: secondaryColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
  }
}
