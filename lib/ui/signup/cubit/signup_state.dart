abstract class SignupState{}

class SignupInitialState extends SignupState{}
class SignupLoadingState extends SignupState{}
class SignupSuccessState extends SignupState{}
class SignupFailedState extends SignupState{
  String  errorMsg;
  SignupFailedState({required this.errorMsg});
}

