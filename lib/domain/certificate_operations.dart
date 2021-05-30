import 'dart:io';

import 'package:mobile_atac_synchronizer/globals.dart';

class CertificateOperations {
  static bool isAllowedCertificateDomain(X509Certificate cert, String host, int port) {
    return host == Globals.ALLOWED_DOMAIN;
  }
}