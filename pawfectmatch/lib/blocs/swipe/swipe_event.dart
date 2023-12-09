part of 'swipe_bloc.dart';

abstract class SwipeEvent extends Equatable {
  const SwipeEvent();

  @override
  List<Object?> get props => [];
}

class LoadDogs extends SwipeEvent{
  final String dogId;

  LoadDogs({
    required this.dogId,
  });

  @override
  List<Object?> get props => [dogId];
}

class UpdateHome extends SwipeEvent {
  final List<Dog>? dogs;

  UpdateHome({
    required this.dogs,
  });

  @override
  List<Object?> get props => [dogs];
}

class SwipeLeft extends SwipeEvent{
  final Dog dogs;

  const SwipeLeft({required this.dogs});

  @override
  List<Object> get props => [dogs];
}

class SwipeRight extends SwipeEvent{
  final Dog dogs;

  const SwipeRight({required this.dogs});

  @override
  List<Object> get props => [dogs];
}
