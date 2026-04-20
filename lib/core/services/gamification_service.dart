import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/animal_repository.dart';

final animalRepoProvider = Provider((ref) => AnimalRepository());
