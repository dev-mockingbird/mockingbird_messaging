// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:mockingbird_messaging/src/event/event.dart';
import 'package:mockingbird_messaging/src/transport/transport.dart';

abstract class Encoding {
  Packet encode(Event event);
  Event decode(Packet payload);
}
