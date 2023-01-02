import "package:dio/dio.dart";
import "package:openai_demo/model/openai_error_model.dart";
import "package:openai_demo/model/openai_response_model.dart";
import "package:openai_demo/singleton/cryptography_singleton.dart";
import "package:pretty_dio_logger/pretty_dio_logger.dart";

class DioSingleton {
  factory DioSingleton() {
    return _singleton;
  }

  DioSingleton._internal();

  static final DioSingleton _singleton = DioSingleton._internal();

  final Dio dio = Dio();
  final String baseURL = "https://api.openai.com/";
  final String baseVer = "v1/";
  final String baseEnd = "images/generations";

  Future<void> addPrettyDioLoggerInterceptor() {
    dio.interceptors.add(
      PrettyDioLogger(),
    );
    return Future<void>.value();
  }

  Future<OpenAiResponseModel> generateImagesFunction({
    required String prompt,
    required int n,
    required String size,
    required void Function(String) callbackHandle,
  }) async {
    String errorMessage = "";
    OpenAiResponseModel aiResponseModel = OpenAiResponseModel();
    OpenAiErrorModel openAiErrorModel = OpenAiErrorModel();
    Response<dynamic> response = Response<dynamic>(
      requestOptions: RequestOptions(path: ""),
    );
    try {
      response = await dio.post(
        baseURL + baseVer + baseEnd,
        data: <String, dynamic>{
          "prompt": prompt,
          "n": n,
          "size": size,
        },
        options: Options(
          headers: <String, dynamic>{
            "Content-Type": "application/json",
            "Authorization": "Bearer ${await revealKey()}",
          },
        ),
      );
    } on DioError catch (error) {
      openAiErrorModel = OpenAiErrorModel.fromJson(error.response?.data);
      errorMessage = openAiErrorModel.error?.message ?? "";
    }
    response.statusCode == 200
        ? aiResponseModel = OpenAiResponseModel.fromJson(response.data)
        : callbackHandle(errorMessage);
    return Future<OpenAiResponseModel>.value(aiResponseModel);
  }

  Future<String> revealKey() async {
    final String openKey = CryptographySingleton().decryptMyData(
      await CryptographySingleton().loadEncryptedStringFromAssets(),
    );
    return Future<String>.value(openKey);
  }
}
