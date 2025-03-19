import 'package:flutter/material.dart';

class PlayerFeedbackPage extends StatefulWidget {
  const PlayerFeedbackPage({super.key});

  @override
  _PlayerFeedbackPageState createState() => _PlayerFeedbackPageState();
}

class _PlayerFeedbackPageState extends State<PlayerFeedbackPage> {
  final TextEditingController feedbackController = TextEditingController();
  List<String> strengths = ["Strength 1", "Strength 2", "Strength 3"];
  List<String> improvements = ["Improvement 1", "Improvement 2", "Improvement 3"];
  Map<String, int> ratings = {
    "Technical Skills": 0,
    "Physical Fitness": 0,
    "Team Co-operation": 0,
    "Game Understanding": 0,
    "Overall Performance": 0
  };

  void _addStrength() {
    setState(() {
      strengths.add("New Strength");
    });
  }

  void _addImprovement() {
    setState(() {
      improvements.add("New Improvement");
    });
  }

  void _submitFeedback() {
    if (feedbackController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please provide detailed feedback!")),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Feedback Submitted Successfully! ✅")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffbababa),
      appBar: AppBar(
        title: Text('Player Feedback',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF101010),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            PlayerInfo(),
            ...ratings.keys.map((category) => RatingRow(
              title: category,
              rating: ratings[category]!,
              onRatingSelected: (stars) {
                setState(() {
                  ratings[category] = stars;
                });
              },
            )),
            FeedbackSection(controller: feedbackController),
            StrengthImprovementSection(title: "Key Strengths", items: strengths, onAdd: _addStrength),
            StrengthImprovementSection(title: "Areas for Improvement", items: improvements, onAdd: _addImprovement),
            SubmitButton(onSubmit: _submitFeedback),
          ],
        ),
      ),
    );
  }
}

// PLAYER INFORMATION
class PlayerInfo extends StatelessWidget {
  const PlayerInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundImage: NetworkImage('https://placehold.co/64x64'),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Alex Thompson', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                Text('Forward • Manchester United U18', style: TextStyle(color: Colors.black54)),
                Text('Player ID: #2024789', style: TextStyle(color: Colors.black54)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}




// PERFORMANCE RATING
class RatingRow extends StatelessWidget {
  final String title;
  final int rating;
  final Function(int) onRatingSelected;

  const RatingRow({super.key, required this.title, required this.rating, required this.onRatingSelected});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(height: 8),
            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < rating ? Icons.star : Icons.star_border, // Filled star or outlined star
                    color: index < rating ? Colors.yellow[700] : Color(
                        0xFFFFDB6A), // Golden color for border
                  ),
                  onPressed: () => onRatingSelected(index + 1),
                );
              }),
            ),

          ],
        ),
      ),
    );
  }
}






// DETAILED FEEDBACK
class FeedbackSection extends StatelessWidget {
  final TextEditingController controller;

  const FeedbackSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Detailed Feedback', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(height: 8),
            TextField(
              controller: controller,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Provide detailed feedback...',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFAB4824)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// STRENGTHS & IMPROVEMENTS
class StrengthImprovementSection extends StatelessWidget {
  final String title;
  final List<String> items;
  final VoidCallback onAdd;

  const StrengthImprovementSection({super.key, required this.title, required this.items, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(height: 8),
            Column(
              children: items
                  .map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: item,
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFAB4824)),
                    ),
                  ),
                ),
              ))
                  .toList(),
            ),
            SizedBox(height: 8),
            IconButton(
              icon: Icon(Icons.add_circle, color: Color(0xFFAB4824)),
              onPressed: onAdd,
            ),
          ],
        ),
      ),
    );
  }
}

// SUBMIT BUTTON
class SubmitButton extends StatelessWidget {
  final VoidCallback onSubmit;

  const SubmitButton({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: onSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFAB4824), // Updated button color
          foregroundColor: Colors.white,
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text('Submit Feedback', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }
}
