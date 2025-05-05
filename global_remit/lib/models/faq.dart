class RelatedLink {
  final String title;
  final String url;
  
  const RelatedLink({
    required this.title,
    required this.url,
  });
  
  factory RelatedLink.fromJson(Map<String, dynamic> json) {
    return RelatedLink(
      title: json['title'],
      url: json['url'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'url': url,
    };
  }
}

class FAQ {
  final String id;
  final String question;
  final String answer;
  final String category;
  final List<RelatedLink> relatedLinks;
  final bool isPinned;
  
  const FAQ({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
    this.relatedLinks = const [],
    this.isPinned = false,
  });
  
  factory FAQ.fromJson(Map<String, dynamic> json) {
    return FAQ(
      id: json['id'],
      question: json['question'],
      answer: json['answer'],
      category: json['category'],
      relatedLinks: (json['relatedLinks'] as List?)
          ?.map((link) => RelatedLink.fromJson(link))
          .toList() ?? [],
      isPinned: json['isPinned'] ?? false,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'category': category,
      'relatedLinks': relatedLinks.map((link) => link.toJson()).toList(),
      'isPinned': isPinned,
    };
  }
}