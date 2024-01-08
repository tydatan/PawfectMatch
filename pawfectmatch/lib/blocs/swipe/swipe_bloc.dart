import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pawfectmatch/models/models.dart';
import 'package:pawfectmatch/repositories/repositories.dart';

part 'swipe_event.dart';
part 'swipe_state.dart';

class SwipeBloc extends Bloc<SwipeEvent, SwipeState> {
  final DatabaseRepository _databaseRepository;

  SwipeBloc({
    required DatabaseRepository databaseRepository,
  })  : _databaseRepository = databaseRepository, 
        super(SwipeLoading()){
    on<LoadDogs>(_onLoadDogs);
    on<UpdateHome>(_onUpdateHome);
    on<SwipeLeft>(_onSwipeLeft);
    on<SwipeRight>(_onSwipeRight);

  }

void _onLoadDogs(
  LoadDogs event,
  Emitter<SwipeState> emit,
) async {
  try {
    emit(SwipeLoading()); // Emit SwipeLoading state before loading dogs

    // Fetch dogs from the repository
    final dogsStream = _databaseRepository.getDogs();

    // Listen to the stream and get the first result
    final List<Dog> dogs = await dogsStream.first;

    emit(SwipeLoaded(dogs: dogs));
  } catch (error) {
    print('Error loading dogs: $error');
    emit(SwipeError());
  }
}



  void _onUpdateHome(
    UpdateHome event,
    Emitter<SwipeState> emit,
  ) {
    print('i am going insane UPDATE HOME');
    if (event.dogs != null) {
      emit(SwipeLoaded(dogs: event.dogs!));
    } else {
      emit(SwipeError());
    }
  }

  void _onSwipeLeft(
    SwipeLeft event,
    Emitter<SwipeState> emit,
  ) {
    if (state is SwipeLoaded) {
      final state = this.state as SwipeLoaded;
      List<Dog> dogs = List.from(state.dogs)..remove(event.dogs);

      if (dogs.isNotEmpty) {
        emit(SwipeLoaded(dogs: dogs));
      } else {
        emit(SwipeError());
      }
    }
  }

  void _onSwipeRight(
    SwipeRight event,
    Emitter<SwipeState> emit,
  ) {
    if (state is SwipeLoaded) {
      final state = this.state as SwipeLoaded;
      List<Dog> dogs = List.from(state.dogs)..remove(event.dogs);

      if (dogs.isNotEmpty) {
        emit(SwipeLoaded(dogs: dogs));
      } else {
        emit(SwipeError());
      }
    }
  }
  
}