import 'package:flutter/material.dart';
import 'package:notification/model/motivation_models.dart';
import 'package:notification/service/motivation_service.dart';

class MotivationController extends ChangeNotifier {
  final _motivHttpService = MotivationHttpServices();

  Future<List<MotivationModel>> getMotiv(String quote) async {
    List<MotivationModel> motivation = await _motivHttpService.fetchQuoteData(quote);
    return motivation;
  }
}
