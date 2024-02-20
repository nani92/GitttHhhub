class RepoData {
  final String name;
  final String fullName;
  final String avatar;
  final String language;
  final String description;
  final bool hasIssues;
  final String issueLink;
  final String pullsLink;

  const RepoData(
    this.name,
    this.fullName,
    this.avatar,
    this.language,
    this.description,
    this.hasIssues,
    this.issueLink,
    this.pullsLink,
  );

  RepoData.fromJson(Map<String, dynamic> data)
      : name = data['name'] ?? '',
        fullName = data['full_name'] ?? '',
        avatar = data['owner']['avatar_url'] ?? '',
        language = data['language'] ?? '',
        description = data['description'] ?? '',
        hasIssues = data['open_issues'] > 0 ?? false,
        issueLink =  data['issues_url'] ?? '',
        pullsLink =  data['pulls_url'] ?? '';
}
