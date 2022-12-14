
import '../pitch_detector_result.dart';

abstract class PitchAlgorithm {
  PitchDetectorResult getPitch(final List<double> audioBuffer);
}
