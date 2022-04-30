import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podboi/Constants/controller_references.dart';
import 'package:podboi/Controllers/general_box_controller.dart';
import 'package:podboi/Services/network/api.dart';

final loginRegisterController =
    StateNotifierProvider<LoginRegisterStateNotifier, LoginRegisterState>(
        (ref) {
  return LoginRegisterStateNotifier(ref);
});

class LoginRegisterStateNotifier extends StateNotifier<LoginRegisterState> {
  final ref;
  LoginRegisterStateNotifier(this.ref)
      : super(LoginRegisterState(isLoading: false));
  late final ApiService _apiController = ref.read(apiService);

  userLogin({required String email, required String password}) async {
    state = state.copyWith(isLoading: true);

    var res =
        await _apiController.userLoginNetwork(email: email, password: password);

    if (res != null) {
      if (res.statusCode == 200) {
        bool _b = await saveTokenRequest(token: res.data);
        if (_b) {
          print(" login success, token saved !");
        }
        state = state.copyWith(isLoading: false);
      } else {
        print(" login failed ");
        print(res.data);
        state = state.copyWith(isLoading: false);
      }
    } else {
      print(" login failed ");
      state = state.copyWith(isLoading: false);
    }

    state = state.copyWith(isLoading: false);
  }
}

class LoginRegisterState {
  final bool isLoading;

  LoginRegisterState({required this.isLoading});

  LoginRegisterState copyWith({bool? isLoading}) {
    return LoginRegisterState(isLoading: isLoading ?? this.isLoading);
  }
}
