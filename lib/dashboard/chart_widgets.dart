import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fl_chart/fl_chart.dart';

// StatCard Widget
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StatCard(this.title, this.value, this.icon, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, size: 30, color: color),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 5),
              Text(value,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

// ImagePicker Widget
class ImagePickerWidget extends StatefulWidget {
  final File? image;
  final void Function(File?) onImagePicked;

  const ImagePickerWidget({
    required this.image,
    required this.onImagePicked,
    super.key,
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      widget.onImagePicked(File(pickedFile.path));
    }
  }

  void _showImageOptions(BuildContext context, Offset offset) async {
    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
          offset.dx, offset.dy, offset.dx + 1, offset.dy + 1),
      items: const [
        PopupMenuItem(value: 'gallery', child: Text('Add from Gallery')),
        PopupMenuItem(value: 'camera', child: Text('Take Picture')),
        PopupMenuItem(value: 'remove', child: Text('Remove Picture')),
      ],
    );

    if (selected == 'gallery') {
      _pickImage(ImageSource.gallery);
    } else if (selected == 'camera') {
      _pickImage(ImageSource.camera);
    } else if (selected == 'remove') {
      widget.onImagePicked(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) =>
          _showImageOptions(context, details.globalPosition),
      child: CircleAvatar(
        radius: 60,
        backgroundImage: widget.image != null
            ? FileImage(widget.image!)
            : const AssetImage('assets/icons/profile.jpg') as ImageProvider,
        child: Align(
          alignment: Alignment.bottomRight,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.edit, size: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

// LineChart Widget
class LineChartWidget extends StatelessWidget {
  const LineChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 200,
        child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: const [
                  FlSpot(0, 0),
                  FlSpot(1, 1),
                  FlSpot(2, 1),
                  FlSpot(3, 2),
                  FlSpot(4, 4),
                  FlSpot(5, 2),
                ],
                isCurved: true,
                color: Colors.red,
                gradient: const LinearGradient(
                  colors: [Colors.red, Colors.purpleAccent, Colors.blueAccent],
                ),
              ),
            ],
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: TextStyle(fontSize: 12),
                      );
                    },
                  ),
                  axisNameWidget: const Text('X Axis')),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(),
                      style: TextStyle(fontSize: 12),
                    );
                  },
                ),
                axisNameWidget: Text('Y Axis'), // Left axis label
              ),
            ),
          ),
        ));
  }
}

// BarChart Widget
class BarChartWidget extends StatelessWidget {
  const BarChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Y Axis', style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('20'),
                SizedBox(height: 40),
                Text('10'),
                SizedBox(height: 40),
                Text('0'),
              ],
            ),
            Expanded(
              child: SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    titlesData:
                        const FlTitlesData(show: false), // Hide default titles
                    barGroups: [
                      BarChartGroupData(
                          x: 2, barRods: [BarChartRodData(toY: 10)]),
                      BarChartGroupData(
                          x: 3, barRods: [BarChartRodData(toY: 12)]),
                      BarChartGroupData(
                          x: 4, barRods: [BarChartRodData(toY: 4)]),
                      BarChartGroupData(
                          x: 6, barRods: [BarChartRodData(toY: 10)]),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Text('2'),
            Text('3'),
            Text('4'),
            Text('6'),
          ],
        ),
        const Text('X Axis', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
      ],
    );
  }
}
