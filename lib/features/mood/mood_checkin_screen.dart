import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/mood_provider.dart';
import '../../core/network/api_client.dart';

class MoodCheckinScreen extends ConsumerStatefulWidget {
  const MoodCheckinScreen({super.key});

  @override
  ConsumerState<MoodCheckinScreen> createState() => _MoodCheckinScreenState();
}

class _MoodCheckinScreenState extends ConsumerState<MoodCheckinScreen> {
  int _intensity = 5;
  bool _submitted = false;
  bool _loading = false;

  Future<void> _submit() async {
    final selected = ref.read(selectedMoodProvider);
    setState(() => _loading = true);
    try {
      await ApiClient().post('/moods', {
        'moodType': selected.name,
        'intensity': _intensity,
      });
      setState(() { _submitted = true; _loading = false; });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(selectedMoodProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Mood Check-in')),
      body: _submitted
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('✅', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 16),
                  const Text('Mood saved!',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Done'),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('How are you feeling?',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),

                  // ✅ Mood selector — dark mode aware
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: moodList.map((mood) {
                      final isSelected = selected.name == mood.name;
                      return GestureDetector(
                        onTap: () => ref.read(selectedMoodProvider.notifier).state = mood,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            // ✅ FIXED: dark mode uses dark surface, not grey.shade100
                            color: isSelected
                                ? const Color(0xFF6C63FF).withOpacity(0.2)
                                : isDark
                                    ? const Color(0xFF1E2035)
                                    : Colors.grey.shade100,
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF6C63FF)
                                  : Colors.transparent,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Text(mood.emoji,
                                  style: const TextStyle(fontSize: 32)),
                              const SizedBox(height: 6),
                              // ✅ FIXED: text color adapts to theme
                              Text(
                                mood.name,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 32),

                  // Intensity slider
                  Text('Intensity: $_intensity / 10',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  Slider(
                    value: _intensity.toDouble(),
                    min: 1,
                    max: 10,
                    divisions: 9,
                    label: '$_intensity',
                    activeColor: const Color(0xFF6C63FF),
                    onChanged: (v) => setState(() => _intensity = v.round()),
                  ),

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C63FF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: _loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Save Mood',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}