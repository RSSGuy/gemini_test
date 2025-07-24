class AppConfig {
  static const aiCloudFunctionUrl = String.fromEnvironment(
    'AI_CLOUD_FUNCTION_URL',
    defaultValue: 'NOT_SET',
  );
}