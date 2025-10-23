import 'package:chat_app/data/model/user_model.dart';
import 'package:chat_app/data/remote/firebase_repository.dart';
import 'package:chat_app/ui/signup/cubit/signup_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupCubit extends Cubit<SignupState>{
  FirebaseRepository firebaseRepository;
  SignupCubit({required this.firebaseRepository}) : super(SignupInitialState());

  Future<void> signupUser(UserModel user, String pass) async {
      emit(SignupLoadingState());
      try{
        await firebaseRepository.createUser(user: user, pass: pass);
        emit(SignupSuccessState());
      }catch(e){
        emit(SignupFailedState(errorMsg: e.toString()));
      }
  }


}