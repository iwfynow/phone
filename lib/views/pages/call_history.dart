import 'package:flutter/material.dart';
import 'package:phone/generated/l10n.dart';
import 'package:phone/views/widgets/call_log_expansion_tile.dart';
import '../../views/pages/recent/recents_page.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/contact_view_model.dart';
import '../../viewmodels/filtration_viewmodel.dart';

class CallHistory extends StatefulWidget implements PreferredSizeWidget {
  const CallHistory({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  CallHistoryState createState() => CallHistoryState();
}

class CallHistoryState extends State<CallHistory> {
  @override
  Widget build(BuildContext context) {
    final kTabs = [
      Tab(text: S.of(context).all),
      Tab(text: S.of(context).missed),
    ];
    TabBarView kTabPages = const TabBarView(children: [
      Recents(),
      MissedCalls()
    ]);

    return DefaultTabController(
      length: kTabs.length,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: Text(S.of(context).call_history),
          bottom: PreferredSize(
            preferredSize: widget.preferredSize,
            child: Container(
              color: Theme.of(context).brightness == Brightness.light
                  ? const Color(0xFFE9E9F3)
                  : const Color(0xFF1B1B23),
              child: TabBar(
                tabs: kTabs,
              ),
            ),
          ),
          toolbarHeight: widget.preferredSize.height,
        ),
        body: kTabPages,
      ),
    );
  }
}

class MissedCalls extends StatelessWidget {
  const MissedCalls({super.key});

  @override
  Widget build(BuildContext context) {
    final cvm = Provider.of<ContactViewModel>(context);
    var missedList = cvm.callHistory.where((mapElement) => (mapElement.values.elementAt(1) == '3')).toList();
      return ListView.builder(
        itemCount: missedList.length,
        itemBuilder: (context, index){
          Filtration().filtrationNumberContact(missedList[index].values.first);
          var phoneNumber = missedList[index].values.first;
          var timestamp = int.parse(missedList[index].values.last);
          return CallLogExpansionTile(
            phoneNumber: phoneNumber, 
            timestamp: timestamp, 
            icon: const Icon(Icons.call_missed, color: Colors.red)
          );
      }
    );
  }
}