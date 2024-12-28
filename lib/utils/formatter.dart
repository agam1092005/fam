class Formatter {
  static String formatText(String template, List<String> entities) {
    for (var entity in entities) {
      template = template.replaceFirst('{}', entity);
    }
    return template;
  }
}
