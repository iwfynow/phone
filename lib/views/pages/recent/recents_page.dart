import 'package:flutter/material.dart';
import 'package:phone/views/widgets/call_log_expansion_tile.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/contact_view_model.dart';

class Recents extends StatelessWidget {
  const Recents({super.key});

  @override
  Widget build(BuildContext context) {
    final cvm = Provider.of<ContactViewModel>(context);
    Icon icon;
    return ListView.builder(
      itemCount: cvm.callHistory.length,
      itemBuilder: (context, index) {
        var mapElement = cvm.callHistory[index];
        var phoneNumber = mapElement.values.first.toString();
        var callType = mapElement.values.elementAt(1).toString();
        var timestamp = int.parse(mapElement.values.last);
            switch (callType) {
              case '1':
                icon = const Icon(Icons.call_received);
                break;
              case '2':
                icon = const Icon(Icons.call_made);
                break;
              case '3':
                icon = const Icon(Icons.call_missed, color: Colors.red);
                break;
              default:
                icon = const Icon(Icons.call_received);
                break;
            }
        return CallLogExpansionTile(
          phoneNumber: phoneNumber,
          timestamp: timestamp,
          icon: icon
        );
      },
    );
  }
}
