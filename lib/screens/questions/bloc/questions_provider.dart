import 'package:flutter/material.dart';

class QuestionsProvider extends ChangeNotifier {

  double questionnaireProgressValue = 0.0;


  ///Set the progress Value here
  setQuestionnaireProgress() {

    questionnaireProgressValue = questionnaireProgressValue+0.1;

    notifyListeners();

  }

  ///Set the progress Value here
  decreaseQuestionnaireProgress() {

    if(questionnaireProgressValue > 0.0) {
      questionnaireProgressValue = questionnaireProgressValue - 0.1;

      notifyListeners();
    }


  }
}
