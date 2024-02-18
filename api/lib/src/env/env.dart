import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied()
final class Env {
  @EnviedField(obfuscate: true)
  static String GEMINI_API_KEY = _Env.GEMINI_API_KEY;
}
