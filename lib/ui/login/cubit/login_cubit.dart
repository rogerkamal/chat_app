import 'package:chat_app/data/remote/firebase_repository.dart';
import 'package:chat_app/ui/login/cubit/login_state.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState>{
  FirebaseRepository firebaseRepository;
  LoginCubit({required this.firebaseRepository}): super (LoginInitialState());

  Future<void> authenticateUser({required String email, required String pass}) async {
    emit(LoginLoadingState());

    try{
      await  firebaseRepository.loginUser(email: email, pass: pass);
      emit(LoginSuccessState());
        } catch(e){
        emit(LoginFailureState(errorMsg: e.toString()));
        }

  }
}