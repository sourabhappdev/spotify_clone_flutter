import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'select_image_state.dart';

class SelectImageCubit extends Cubit<SelectImageState> {
  SelectImageCubit() : super(SelectImageInitial());
  late String image;

  Future<void> selectImage(ImageSource imageSource) async {
    try {
      emit(SelectImageLoading());
      final ImagePicker picker = ImagePicker();

      final XFile? imageFile = await picker.pickImage(source: imageSource);
      image = imageFile?.path ?? '';
      if (imageFile != null) {
        emit(SelectImageSuccess(image: imageFile.path));
      } else {
        emit(const SelectImageFailure(error: 'No image selected'));
      }
    } catch (e) {
      emit(SelectImageFailure(error: 'Failed to pick image: $e'));
    }
  }
}
