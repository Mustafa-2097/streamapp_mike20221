class NewsModel {
  bool? success;
  String? message;
  Meta? meta;
  List<Article>? data;

  NewsModel({this.success, this.message, this.meta, this.data});

  NewsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    if (json['data'] != null) {
      data = <Article>[];
      if (json['data'] is List) {
        json['data'].forEach((v) {
          data!.add(Article.fromJson(v));
        });
      } else if (json['data'] is Map<String, dynamic>) {
        // Handle single object response (e.g. news by ID)
        data!.add(Article.fromJson(json['data']));
      }
    }
  }
}

class Meta {
  int? page;
  int? limit;
  int? total;

  Meta({this.page, this.limit, this.total});

  Meta.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    limit = json['limit'];
    total = json['total'];
  }
}

class Article {
  String? id;
  String? author;
  String? title;
  String? description;
  String? url;
  String? urlToImage;
  String? publishedAt;
  String? content;
  int? viewCount;
  String? category;
  int? likes;
  int? dislikes;
  int? commentCount;
  bool? isLiked;
  bool? isDisliked;
  List<Comment>? comments;

  Article({
    this.id,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
    this.viewCount,
    this.category,
    this.likes,
    this.dislikes,
    this.commentCount,
    this.isLiked,
    this.isDisliked,
    this.comments,
  });

  Article.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    author = json['author'];
    title = json['title'];
    description = json['description'] ?? json['content']; // Fallback
    url = json['url'];
    // Map imageUrl to urlToImage for backward compatibility
    urlToImage = json['imageUrl'] ?? json['urlToImage'];
    // Map createdAt to publishedAt for backward compatibility
    publishedAt = json['createdAt'] ?? json['publishedAt'];
    content = json['content'];
    // Map reads to viewCount for backward compatibility
    viewCount = json['reads'] ?? json['viewCount'];
    category = json['category'];
    likes = json['likes'];
    dislikes = json['dislikes'];
    commentCount = json['commentCount'];
    isLiked = json['isLiked'];
    isDisliked = json['isDisliked'];
    if (json['comments'] != null) {
      comments = <Comment>[];
      json['comments'].forEach((v) {
        comments!.add(Comment.fromJson(v));
      });
    }
  }
}

class Comment {
  String? id;
  String? newsId;
  String? userId;
  String? userName;
  String? userImage;
  String? comment;
  String? parentId;
  String? createdAt;
  String? updatedAt;
  List<Comment>? replies;

  Comment({
    this.id,
    this.newsId,
    this.userId,
    this.userName,
    this.userImage,
    this.comment,
    this.parentId,
    this.createdAt,
    this.updatedAt,
    this.replies,
  });

  Comment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    newsId = json['newsId'];
    userId = json['userId'];
    userName = json['userName'];
    userImage = json['userImage'];
    comment = json['comment'];
    parentId = json['parentId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['replies'] != null) {
      replies = <Comment>[];
      json['replies'].forEach((v) {
        replies!.add(Comment.fromJson(v));
      });
    }
  }
}

/*
class NewsModel {
  bool? success;
  String? message;
  NewsData? data;

  NewsModel({this.success, this.message, this.data});

  NewsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? NewsData.fromJson(json['data']) : null;
  }
}

class NewsData {
  String? status;
  int? totalResults;
  List<Article>? articles;

  NewsData({this.status, this.totalResults, this.articles});

  NewsData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalResults = json['totalResults'];
    if (json['articles'] != null) {
      articles = <Article>[];
      json['articles'].forEach((v) {
        articles!.add(Article.fromJson(v));
      });
    }
  }
}

class Article {
  String? id;
  Source? source;
  String? author;
  String? title;
  String? description;
  String? url;
  String? urlToImage;
  String? publishedAt;
  String? content;
  int? viewCount;

  Article({
    this.id,
    this.source,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
    this.viewCount,
  });

  Article.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    source = json['source'] != null ? Source.fromJson(json['source']) : null;
    author = json['author'];
    title = json['title'];
    description = json['description'];
    url = json['url'];
    urlToImage = json['urlToImage'];
    publishedAt = json['publishedAt'];
    content = json['content'];
    viewCount = json['viewCount'];
  }
}

class Source {
  String? id;
  String? name;

  Source({this.id, this.name});

  Source.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}
*/

