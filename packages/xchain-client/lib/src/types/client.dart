import 'package:xchain_client/xchain_client.dart';

typedef XchainClientParams = ({
  Network? network,
  String? phrase,
  FeeBounds? feeBounds,
  RootDerivationPaths? rootDerivationPaths,
});

typedef ThornodeApiMap = Map<Network, String>;
