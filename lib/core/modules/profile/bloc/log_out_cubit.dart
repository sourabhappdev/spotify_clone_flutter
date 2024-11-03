import 'package:appwrite/appwrite.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:spotify_clone/common/services/app_state.dart';
import 'package:spotify_clone/common/services/appwrite_service.dart';

part 'log_out_state.dart';

class LogOutCubit extends Cubit<LogOutState> {
  LogOutCubit() : super(LogOutInitial());

  void logout(String sessionId) async {
    try {
      emit(LogOutLoading());
      final res = AppWriteService.account.deleteSession(sessionId: sessionId);
      await AppState.instance.clearAllValues();
      emit(LogOutSuccess());
    } on AppwriteException catch (e) {
      emit(LogOutFailure(error: e.message ?? 'An unknown error occurred'));
    } catch (e) {
      emit(const LogOutFailure(error: 'Something went wrong'));
    }
  }
}
