/*
* Copyright (c) 2020 Exchangily LLC
*
* Licensed under Apache License v2.0
* You may obtain a copy of the License at
*
*      https://www.apache.org/licenses/LICENSE-2.0
*
*----------------------------------------------------------------------
* Author: ken.qiu@exchangily.com
*----------------------------------------------------------------------
*/

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../environments/environment.dart';

mixin KanbanService {
  getScarAddress() async {
    var url =
        environment['endpoints']['kanban'] + 'exchangily/getExchangeAddress';
    var client = new http.Client();
    var response = await client.get(url);
    var json = jsonDecode(response.body);
    return json;
  }
}
