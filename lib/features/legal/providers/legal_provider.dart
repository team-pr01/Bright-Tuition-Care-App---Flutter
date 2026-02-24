import 'package:btcclient/features/legal/data/local_terms.dart';
import 'package:btcclient/features/legal/data/models/legal_document.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final termsProvider =
Provider<LegalDocument>((ref) {

  return termsDocument;

});