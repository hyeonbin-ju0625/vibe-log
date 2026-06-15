import '../models/trip_plan.dart';
import '../models/trip_request.dart';
import '../services/claude_service.dart';

class TripRepository {
  static final _instance = TripRepository._();
  TripRepository._();
  factory TripRepository() => _instance;

  final _claude = ClaudeService();

  Future<TripPlan> generatePlan(TripRequest request, String apiKey) async {
    return await _claude.generatePlan(request, apiKey);
  }
}
