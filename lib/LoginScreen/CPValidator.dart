import 'dart:async';

import 'ErrorGen.dart';

mixin CPValidator {
  var oldPasswordValidator = StreamTransformer<ErrorGen, String>.fromHandlers(
      handleData: (errorGen, sink) {
    var oldPassword = errorGen.value;
     if (errorGen.isError) {
      sink.addError(errorGen.value);
    } else if (oldPassword.length > 5) {
      sink.add(oldPassword);
    } else {
      sink.addError("Password length > 4");
    }
  });

  var passwordValidator = StreamTransformer<ErrorGen, String>.fromHandlers(
      handleData: (errorGen, sink) {
    var password = errorGen.value;
    if (errorGen.isError) {
      sink.addError(errorGen.value);
    } else if (password.length > 5) {
      sink.add(password);
    } else {
      sink.addError("Password length > 4");
    }
  });

  var emailErrorValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (errorMessage, sink) {
    sink.addError(errorMessage);
  });
}
