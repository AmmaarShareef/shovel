import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'dart:ui' show Offset;
import '../../providers/job_provider.dart';
import '../../models/job.dart';

class JobsMapScreen extends StatefulWidget {
  const JobsMapScreen({super.key});

  @override
  State<JobsMapScreen> createState() => _JobsMapScreenState();
}

class _JobsMapScreenState extends State<JobsMapScreen> {
  static const double _fallbackLat = 40.7128;
  static const double _fallbackLng = -74.0060;
  double _radiusKm = 5;

  @override
  void initState() {
    super.initState();
    _fetchJobs();
  }

  Future<void> _fetchJobs() async {
    await context.read<JobProvider>().fetchAvailableJobs(
          lat: _fallbackLat,
          lng: _fallbackLng,
          radius: _radiusKm,
        );
  }

  Map<String, Offset> _buildMockPositions(List<Job> jobs) {
    if (jobs.isEmpty) return {};

    double minLat = jobs.first.location.lat;
    double maxLat = jobs.first.location.lat;
    double minLng = jobs.first.location.lng;
    double maxLng = jobs.first.location.lng;

    for (final job in jobs) {
      minLat = job.location.lat < minLat ? job.location.lat : minLat;
      maxLat = job.location.lat > maxLat ? job.location.lat : maxLat;
      minLng = job.location.lng < minLng ? job.location.lng : minLng;
      maxLng = job.location.lng > maxLng ? job.location.lng : maxLng;
    }

    final latSpan = (maxLat - minLat).abs() < 0.0001 ? 1.0 : (maxLat - minLat);
    final lngSpan = (maxLng - minLng).abs() < 0.0001 ? 1.0 : (maxLng - minLng);

    final positions = <String, Offset>{};
    for (final job in jobs) {
      final nx = ((job.location.lng - minLng) / lngSpan).clamp(0.1, 0.9);
      final ny = (1 - (job.location.lat - minLat) / latSpan).clamp(0.1, 0.9);
      positions[job.id] = Offset(nx, ny);
    }
    return positions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jobs Map'),
        elevation: 0,
        backgroundColor: Colors.green[600],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/shoveler/home');
            }
          },
        ),
      ),
      body: Consumer<JobProvider>(
        builder: (context, jobProvider, _) {
          final positions = _buildMockPositions(jobProvider.jobs);

          return Column(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final size = Size(constraints.maxWidth, constraints.maxHeight);
                    final radiusPx = (size.shortestSide * (_radiusKm / 25)).clamp(60.0, size.shortestSide * 0.45);

                    return Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blueGrey[50],
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: CustomPaint(
                            painter: _MockMapGridPainter(),
                            child: Center(
                              child: Container(
                                width: radiusPx * 2,
                                height: radiusPx * 2,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green.withOpacity(0.08),
                                  border: Border.all(color: Colors.green, width: 2),
                                ),
                                child: Center(
                                  child: Text(
                                    '${_radiusKm.toStringAsFixed(0)} km',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 16,
                          top: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.map, size: 16, color: Colors.green[700]),
                                const SizedBox(width: 6),
                                Text(
                                  'Mock map (live data ready)',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                        for (final job in jobProvider.jobs)
                          _MockJobMarker(
                            job: job,
                            position: positions[job.id] ?? const Offset(0.5, 0.5),
                            mapSize: size,
                          ),
                      ],
                    );
                  },
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Search radius: ${_radiusKm.toStringAsFixed(0)} km',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Slider(
                      value: _radiusKm,
                      min: 1,
                      max: 25,
                      divisions: 24,
                      label: '${_radiusKm.toStringAsFixed(0)} km',
                      onChanged: (value) {
                        setState(() {
                          _radiusKm = value;
                        });
                      },
                      onChangeEnd: (_) => _fetchJobs(),
                      activeColor: Colors.green[600],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${jobProvider.jobs.length} job${jobProvider.jobs.length == 1 ? '' : 's'} found',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[700],
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _fetchJobs,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Refresh'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MockMapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.18)
      ..strokeWidth = 1;

    const step = 40.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _MockMapGridPainter oldDelegate) => false;
}

class _MockJobMarker extends StatelessWidget {
  final Job job;
  final Offset position; // normalized
  final Size mapSize;

  const _MockJobMarker({
    required this.job,
    required this.position,
    required this.mapSize,
  });

  @override
  Widget build(BuildContext context) {
    const markerSize = 36.0;
    final dx = (position.dx * mapSize.width).clamp(markerSize, mapSize.width - markerSize);
    final dy = (position.dy * mapSize.height).clamp(markerSize, mapSize.height - markerSize);

    return Positioned(
      left: dx - markerSize / 2,
      top: dy - markerSize / 2,
      child: GestureDetector(
        onTap: () {
          context.read<JobProvider>().setActiveJob(job);
          context.go('/shoveler/job-details/${job.id}');
        },
        child: Column(
          children: [
            Container(
              width: markerSize,
              height: markerSize,
              decoration: BoxDecoration(
                color: Colors.green[600],
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '\$${job.paymentAmount.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Text(
                job.title,
                style: const TextStyle(fontSize: 10),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
