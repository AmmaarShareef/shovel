import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/job_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/job.dart';

class CreateJobScreen extends StatefulWidget {
  const CreateJobScreen({super.key});

  @override
  State<CreateJobScreen> createState() => _CreateJobScreenState();
}

class _CreateJobScreenState extends State<CreateJobScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _addressController;
  late TextEditingController _priceController;
  DateTime? _selectedDate;

  // Image and points
  String? _imageDataUrl;
  final List<Offset> _points = [];
  final List<List<Offset>> _polygons = [];
  final _imageStackKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _addressController = TextEditingController();
    _priceController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImageWeb() async {
    final uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();
    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        final file = files.first;
        final reader = html.FileReader();
        reader.readAsDataUrl(file);
        reader.onLoadEnd.listen((event) {
          setState(() {
            _imageDataUrl = reader.result as String?;
            _points.clear();
            _polygons.clear();
          });
        });
      }
    });
  }

  void _onImageTap(Offset localPosition) {
    if (_points.length >= 4) return;
    final box = _imageStackKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final size = box.size;
    
    final newPoint = Offset(localPosition.dx / size.width, localPosition.dy / size.height);
    
    
    setState(() {
      _points.add(newPoint);
      // Once we have 4 points, reorder them into a simple (non-self-intersecting)
      // polygon by sorting points by angle around their centroid. This allows
      // users to tap anywhere and still produce a closed shape. Save the
      // completed polygon and clear the in-progress points so the user can
      // create additional polygons.
      if (_points.length == 4) {
        final ordered = _orderPointsForPolygon(List<Offset>.from(_points));
        _polygons.add(ordered);
        _points.clear();
      }
    });
  }

    // Order points into a polygon by sorting around centroid (angle sort).
    List<Offset> _orderPointsForPolygon(List<Offset> pts) {
      if (pts.length <= 2) return List<Offset>.from(pts);
      final cx = pts.map((p) => p.dx).reduce((a, b) => a + b) / pts.length;
      final cy = pts.map((p) => p.dy).reduce((a, b) => a + b) / pts.length;
      final center = Offset(cx, cy);
      final ordered = List<Offset>.from(pts);
      ordered.sort((a, b) {
        final angA = (a - center).direction; // radians
        final angB = (b - center).direction;
        return angA.compareTo(angB);
      });
      return ordered;
    }

  // Helper method to check if two line segments intersect
  bool _doLineSegmentsIntersect(Offset p1, Offset p2, Offset p3, Offset p4) {
    return _ccw(p1, p3, p4) != _ccw(p2, p3, p4) && 
           _ccw(p1, p2, p3) != _ccw(p1, p2, p4);
  }

  // Helper method to check if the CCW test passes
  bool _ccw(Offset a, Offset b, Offset c) {
    return (c.dy - a.dy) * (b.dx - a.dx) > (b.dy - a.dy) * (c.dx - a.dx);
  }

  bool _isFormComplete() {
    return _titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _addressController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        double.tryParse(_priceController.text) != null &&
        _imageDataUrl != null &&
        _polygons.isNotEmpty &&
        _selectedDate != null;
  }

  void _clearPoints() {
    setState(() {
      _points.clear();
      _polygons.clear();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitJob() async {
    if (!_formKey.currentState!.validate() || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields and select a date'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_priceController.text.isEmpty || double.tryParse(_priceController.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid price'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_imageDataUrl == null || _polygons.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload an image and mark at least one area'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final jobProvider = context.read<JobProvider>();
      final authProvider = context.read<AuthProvider>();
      await jobProvider.createJob(
        CreateJobData(
          title: _titleController.text,
          description: _descriptionController.text,
          address: _addressController.text,
          location: LocationCoordinates(lat: 40.7128, lng: -74.0060),
          deadline: _selectedDate!,
          beforePhoto: _imageDataUrl!,
          polygons: _polygons,
          paymentAmount: double.parse(_priceController.text),
          customerId: authProvider.user?.id,
        ),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Job created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/customer/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Job'),
        elevation: 0,
        backgroundColor: Colors.blue[600],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Basic Info Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info, color: Colors.blue[600]),
                          const SizedBox(width: 8),
                          Text(
                            'Job Details',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'Job Title',
                          hintText: 'e.g., Clear driveway',
                          prefixIcon: Icon(Icons.title, color: Colors.grey[400]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Title is required' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          hintText: 'Describe the work needed',
                          prefixIcon: Icon(Icons.description, color: Colors.grey[400]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        maxLines: 3,
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Description is required' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _priceController,
                        decoration: InputDecoration(
                          labelText: 'Price (\$)',
                          hintText: 'e.g., 50.00',
                          prefixIcon: Icon(Icons.attach_money, color: Colors.grey[400]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) return 'Price is required';
                          if (double.tryParse(value!) == null) {
                            return 'Enter a valid number';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Location Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.green[600]),
                          const SizedBox(width: 8),
                          Text(
                            'Location',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          labelText: 'Address',
                          hintText: 'Full address',
                          prefixIcon: Icon(Icons.location_on, color: Colors.grey[400]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Address is required' : null,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Image Annotation Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.image, color: Colors.purple[600]),
                          const SizedBox(width: 8),
                          Text(
                            'Area Photo',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Upload a photo and mark the area with 4 points',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _pickImageWeb,
                              icon: const Icon(Icons.upload_file),
                              label: const Text('Upload Image'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton.icon(
                            onPressed: _clearPoints,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Clear'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (_imageDataUrl != null) ...[
                        Text(
                          'Polygons: ${_polygons.length}  •  Points: ${_points.length}/4',
                          style: TextStyle(
                            fontSize: 12,
                            color: _polygons.isNotEmpty ? Colors.green[600] : Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTapDown: (details) {
                            final box = _imageStackKey.currentContext?.findRenderObject() as RenderBox?;
                            if (box != null) {
                              final local = box.globalToLocal(details.globalPosition);
                              _onImageTap(local);
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Stack(
                              key: _imageStackKey,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    _imageDataUrl!,
                                    width: double.infinity,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Positioned.fill(
                                  child: CustomPaint(
                                    painter: _PointsPainter(
                                      polygons: _polygons,
                                      points: _points,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ] else
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[50],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image_not_supported, size: 48, color: Colors.grey[300]),
                              const SizedBox(height: 12),
                              Text(
                                'No image selected',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Deadline Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.orange[600]),
                          const SizedBox(width: 8),
                          Text(
                            'Deadline',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[50],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedDate?.toString().split(' ')[0] ?? 'Select date',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Icon(Icons.arrow_forward, color: Colors.grey[600]),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Submit Button
              Consumer<JobProvider>(
                builder: (context, jobProvider, child) {
                  final isComplete = _isFormComplete();
                  
                  return Container(
                    width: double.infinity,
                    decoration: isComplete
                        ? BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue[600]!.withOpacity(0.6),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          )
                        : null,
                    child: ElevatedButton.icon(
                      onPressed: jobProvider.isLoading ? null : _submitJob,
                      icon: const Icon(Icons.check_circle),
                      label: Text(jobProvider.isLoading ? 'Creating...' : 'Create Job'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.blue[600],
                        disabledBackgroundColor: Colors.grey[300],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _PointsPainter extends CustomPainter {
  final List<List<Offset>> polygons; // normalized polygons
  final List<Offset> points; // normalized in-progress points

  _PointsPainter({required this.polygons, required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final pointPaint = Paint()..color = Colors.red;
    final linePaint = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw completed polygons
    for (final poly in polygons) {
      final scaled = poly.map((p) => Offset(p.dx * size.width, p.dy * size.height)).toList();
      if (scaled.length >= 3) {
        final path = Path()..moveTo(scaled.first.dx, scaled.first.dy);
        for (int i = 1; i < scaled.length; i++) {
          path.lineTo(scaled[i].dx, scaled[i].dy);
        }
        path.close();

        final fillPaint = Paint()
          ..color = Colors.yellow.withOpacity(0.18)
          ..style = PaintingStyle.fill;
        canvas.drawPath(path, fillPaint);
        canvas.drawPath(path, linePaint);
      } else {
        // if somehow fewer than 3, just draw points
        for (final p in scaled) {
          canvas.drawCircle(p, 6, pointPaint);
        }
      }
    }

    // Draw in-progress points and connecting lines
    final scaledInProgress = points.map((p) => Offset(p.dx * size.width, p.dy * size.height)).toList();
    for (final p in scaledInProgress) {
      canvas.drawCircle(p, 6, pointPaint);
    }
    for (int i = 0; i < scaledInProgress.length - 1; i++) {
      canvas.drawLine(scaledInProgress[i], scaledInProgress[i + 1], linePaint);
    }
    if (scaledInProgress.length == 4) {
      // close the in-progress polygon if completed (should be moved to polygons normally)
      canvas.drawLine(scaledInProgress.last, scaledInProgress.first, linePaint);
      final path = Path()..moveTo(scaledInProgress.first.dx, scaledInProgress.first.dy);
      for (int i = 1; i < scaledInProgress.length; i++) {
        path.lineTo(scaledInProgress[i].dx, scaledInProgress[i].dy);
      }
      path.close();
      final fillPaint = Paint()
        ..color = Colors.yellow.withOpacity(0.12)
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, fillPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _PointsPainter oldDelegate) =>
      oldDelegate.polygons != polygons || oldDelegate.points != points;
}

