import 'package:flutter/material.dart';
import 'package:night_watch3/helpers/constants.dart';
import 'package:timeago/timeago.dart' as timeago;

class RecordingRow extends StatelessWidget {
  final String filename;
  final String currentlyPlayingFilename;
  final Function onTap;

  // ignore: use_key_in_widget_constructors
  const RecordingRow({
    required this.filename,
    required this.currentlyPlayingFilename,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        color: currentlyPlayingFilename == filename
            ? kColourPrimary
            : kColourBackground,
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            Icon(
              currentlyPlayingFilename == filename
                  ? Icons.pause_circle_filled
                  : Icons.play_circle_filled,
              size: 36.0,
              color: currentlyPlayingFilename == filename
                  ? Colors.white
                  : kColourPrimary,
            ),
            const SizedBox(width: 16.0),
            Text(
              timeago.format(
                  DateTime.parse(filename.split('_').last.substring(0, 25))),
              style: currentlyPlayingFilename == filename
                  ? kTextStyleRecordingPlaying
                  : kTextStyleRecording,
            ),
          ],
        ),
      ),
      onTap: () {
        onTap(filename);
      },
    );
  }
}
