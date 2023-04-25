import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:stackwallet/db/isar/main_db.dart';
import 'package:stackwallet/models/isar/models/blockchain_data/utxo.dart';
import 'package:stackwallet/pages_desktop_specific/coin_control/utxo_row.dart';
import 'package:stackwallet/utilities/logger.dart';
import 'package:stackwallet/widgets/desktop/primary_button.dart';

class FreezeButton extends StatefulWidget {
  const FreezeButton({
    Key? key,
    required this.selectedUTXOs,
  }) : super(key: key);

  final Set<UtxoRowData> selectedUTXOs;

  @override
  State<FreezeButton> createState() => _FreezeButtonState();
}

class _FreezeButtonState extends State<FreezeButton> {
  String _freezeLabelCache = "Freeze";

  String _freezeLabel(Set<UtxoRowData> dataSet) {
    if (dataSet.isEmpty) return _freezeLabelCache;

    bool hasUnblocked = false;
    for (final data in dataSet) {
      if (!MainDB.instance.isar.utxos
          .where()
          .idEqualTo(data.utxoId)
          .findFirstSync()!
          .isBlocked) {
        hasUnblocked = true;
        break;
      }
    }
    _freezeLabelCache = hasUnblocked ? "Freeze" : "Unfreeze";
    return _freezeLabelCache;
  }

  Future<void> _onFreezeStateButtonPressed() async {
    List<UTXO> utxosToUpdate = [];
    switch (_freezeLabelCache) {
      case "Freeze":
        for (final e in widget.selectedUTXOs) {
          final utxo = MainDB.instance.isar.utxos
              .where()
              .idEqualTo(e.utxoId)
              .findFirstSync()!;
          if (!utxo.isBlocked) {
            utxosToUpdate.add(utxo.copyWith(isBlocked: true));
          }
        }
        break;

      case "Unfreeze":
        for (final e in widget.selectedUTXOs) {
          final utxo = MainDB.instance.isar.utxos
              .where()
              .idEqualTo(e.utxoId)
              .findFirstSync()!;
          if (utxo.isBlocked) {
            utxosToUpdate.add(utxo.copyWith(isBlocked: false));
          }
        }
        break;

      default:
        Logging.instance.log(
          "Unknown utxo method name found in $runtimeType",
          level: LogLevel.Fatal,
        );
        return;
    }

    // final update utxo set in db
    if (utxosToUpdate.isNotEmpty) {
      await MainDB.instance.putUTXOs(utxosToUpdate);
    }
  }

  late Stream<UTXO?> bigStream;

  @override
  void initState() {
    List<Stream<UTXO?>> streams = [];
    for (final data in widget.selectedUTXOs) {
      final stream = MainDB.instance.watchUTXO(id: data.utxoId);

      streams.add(stream);
    }

    bigStream = StreamGroup.merge(streams);
    bigStream.listen((event) {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          setState(() {});
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("BUILD: $runtimeType");
    return PrimaryButton(
      buttonHeight: ButtonHeight.l,
      width: 200,
      label: _freezeLabel(widget.selectedUTXOs),
      onPressed: _onFreezeStateButtonPressed,
    );
  }
}