import "dart:io";

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:openai_demo/model/openai_response_model.dart";
import "package:openai_demo/singleton/dio_singleton.dart";
import "package:openai_demo/singleton/image_singleton.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomeScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  int? _selectedNumberOfImages;
  final List<int> _generatedList = List<int>.generate(
    10,
    (int i) {
      return i + 1;
    },
  );
  String? _selectedSize;
  final List<String> _sizesList = <String>[
    "256x256",
    "512x512",
    "1024x1024",
  ];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _showLoader = false;
  OpenAiResponseModel _aiResponseModel = OpenAiResponseModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    clearAll();
    _formKey.currentState?.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OpenAI Image Generation Demo"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: !_showLoader && (_aiResponseModel.data?.isEmpty ?? true)
                    ? const SizedBox()
                    : (_aiResponseModel.data?.isEmpty ?? true)
                        ? Column(
                            children: <Widget>[
                              const Spacer(),
                              if (Platform.isIOS)
                                const CupertinoActivityIndicator()
                              else
                                const CircularProgressIndicator(),
                              const Spacer(),
                            ],
                          )
                        : GridView.builder(
                            itemCount: _aiResponseModel.data?.length ?? 0,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 18,
                              crossAxisSpacing: 18,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return ImageSingleton().imageWidget(
                                _aiResponseModel.data?[index].url ?? "",
                              );
                            },
                          ),
              ),
              const SizedBox(height: 15),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text("What are you imagining right now?"),
                      ),
                      controller: _textEditingController,
                      validator: (String? value) {
                        return (value == null || value.isEmpty)
                            ? "Field Required"
                            : null;
                      },
                    ),
                    DropdownButtonFormField<int>(
                      isExpanded: true,
                      value: _selectedNumberOfImages,
                      hint: const Text("Select number of images"),
                      onChanged: (int? value) {
                        _selectedNumberOfImages = value ?? 0;
                        setState(() {});
                      },
                      validator: (int? value) {
                        return (value == null) ? "Field Required" : null;
                      },
                      items: _generatedList.map<DropdownMenuItem<int>>(
                        (int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(
                              value.toString(),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: _selectedSize,
                      hint: const Text("Select Size"),
                      onChanged: (String? value) {
                        _selectedSize = value ?? "";
                        setState(() {});
                      },
                      validator: (String? value) {
                        return (value == null) ? "Field Required" : null;
                      },
                      items: _sizesList.map<DropdownMenuItem<String>>(
                        (String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        },
                      ).toList(),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          onPressed: clearAll,
                          icon: Row(
                            children: const <Widget>[
                              Icon(Icons.clear_all),
                              SizedBox(width: 10),
                              Text("Clear all"),
                            ],
                          ),
                        ),
                        FloatingActionButton(
                          onPressed: () async {
                            unFocusPrimaryFocus();
                            if (_formKey.currentState?.validate() ?? false) {
                              clearOldData();
                              showLoaderAndMakeImageURLsEmpty();
                              await makeOpenAIAPIRequest();
                              hideLoaderAndMakeImageURLsEmpty();
                            }
                          },
                          child: const Icon(Icons.auto_awesome_outlined),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void clearOldData() {
    _aiResponseModel = OpenAiResponseModel();
    setState(() {});
    return;
  }

  void showLoaderAndMakeImageURLsEmpty() {
    _showLoader = true;
    setState(() {});
    return;
  }

  Future<void> makeOpenAIAPIRequest() async {
    _aiResponseModel = await DioSingleton().generateImagesFunction(
      prompt: _textEditingController.value.text,
      n: _selectedNumberOfImages ?? 0,
      size: _selectedSize ?? "",
      callbackHandle: showSnackBar,
    );
    setState(() {});
    return Future<void>.value();
  }

  void hideLoaderAndMakeImageURLsEmpty() {
    _showLoader = false;
    setState(() {});
    return;
  }

  void clearAll() {
    unFocusPrimaryFocus();
    _textEditingController.clear();
    _selectedNumberOfImages = null;
    _selectedSize = null;
    _formKey.currentState?.reset();
    _showLoader = false;
    _aiResponseModel = OpenAiResponseModel();
    setState(() {});
    return;
  }

  void unFocusPrimaryFocus() {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {});
    return;
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
    String message,
  ) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 8),
      ),
    );
  }
}
