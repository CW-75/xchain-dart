import 'package:xchain_client/src/network.dart';

abstract interface class XchainClient {
  void setNetwork(Network network);
  Network getNetwork();
}

class BaseClient implements XchainClient {
  Network _network = Network.mainnet;

  @override
  void setNetwork(Network network) => _network = network;

  @override
  Network getNetwork() => _network;
}
