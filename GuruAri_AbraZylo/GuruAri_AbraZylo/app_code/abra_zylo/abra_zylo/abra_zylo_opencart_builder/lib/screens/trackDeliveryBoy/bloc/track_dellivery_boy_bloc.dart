import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/screens/trackDeliveryBoy/bloc/track_delivery_boy_screen_event.dart';
import 'package:oc_demo/screens/trackDeliveryBoy/bloc/track_delivery_boy_screen_repository.dart';
import 'package:oc_demo/screens/trackDeliveryBoy/bloc/track_delivery_boy_screen_state.dart';

class TrackDeliveryBoyBloc
    extends Bloc<TrackDeliveryBoyScreenEvent, TrackDeliveryBoyBaseState> {
  TrackDeliveryBoyRepository? repository;

  TrackDeliveryBoyBloc({this.repository})
      : super(TrackDeliveryBoyInitialState()) {
    on<TrackDeliveryBoyScreenEvent>(mapEventToState);
  }

  void mapEventToState(TrackDeliveryBoyScreenEvent event,
      Emitter<TrackDeliveryBoyBaseState> emit) async {
    if (event is TrackDeliveryBoyScreenDatFetchEvent) {
      try {
        var model = await repository?.getTrackDeliveryBoyData(event.id);
        if (model != null) {
          emit(TrackDeliveryBoySuccessState(model));
        } else {
          emit(TrackDeliveryBoyErrorState(''));
        }
      } catch (error, _) {
        emit(TrackDeliveryBoyErrorState(error.toString()));
      }
    }
  }
}
