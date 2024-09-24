import 'package:book_box/models/tournament_model.dart';
import 'package:flutter/cupertino.dart';

import '../network/api_client.dart';
import '../network/api_constant.dart';

class TournamentController {
  Future getTournament(BuildContext context) async {
    var response = await getData(paramUri: ApiConstant.tournament);
    if (response["status"].toString() == "true" && response["data"] != null) {
      return TournamentModel.fromJson(response);
    } else {
      return null;
    }
  }
}
