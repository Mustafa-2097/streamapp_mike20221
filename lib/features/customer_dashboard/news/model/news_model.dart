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
