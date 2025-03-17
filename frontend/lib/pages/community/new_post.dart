import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawsome/reusable_widgets/CommunityWidgets.dart';
import 'package:pawsome/services/database_service.dart';
import 'package:pawsome/services/storage_service.dart';

/// A stateful widget that allows users to create a new post.
/// Users can add a description, location, and optionally an image placeholder.
class NewPostPage extends StatefulWidget {
  @override
  _NewPostPageState createState() => _NewPostPageState();
}


/// State class for [NewPostPage].
/// Manages the user input for the new post and handles the post submission.
class _NewPostPageState extends State<NewPostPage> {
  // Store and upload image file to firebase storage
  File? _selectedImage;

  final ImagePicker _picker = ImagePicker();

  String _postType = "Normal"; // Default post type

  // Controller for the description text field.
  final TextEditingController _descriptionController = TextEditingController();

  // Controller for the location text field.
  final TextEditingController _locationController = TextEditingController();

  // Instance of DatabaseService for handling post creation.
  final _databaseService = DatabaseService();

  // Instance of StorageService for handling post images.
  final StorageService _storageService = StorageService();

  /// Function to pick an image from the gallery.
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  /// Function to create a new post.
  Future<void> _createPost() async {
    if (_descriptionController.text.isEmpty || _locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("All fields are required!")));
      return;
    }

    String? imageUrl;
    if (_selectedImage != null) {
      // Upload image to Firebase Storage and get URL
      imageUrl = await _storageService.uploadImage(_selectedImage!);
    }

    // Save post to Firestore
    await _databaseService.createPost(
      description: _descriptionController.text.trim(),
      location: _locationController.text.trim(),
      imageUrl: imageUrl,
      postType: _postType, // Stores the selected post type
    );

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Post created successfully!")));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF0CC), // Light yellow background
        elevation: 0,

        // Back button to navigate to the previous screen.
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Add New Post",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),

        // Main column that contains the post creation UI.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),

            // Image upload placeholder
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                child: _selectedImage == null
                    ? const Center(child: Icon(Icons.camera_alt, size: 50, color: Colors.black))
                    : Image.file(_selectedImage!, fit: BoxFit.cover),
              ),
            ),

            const SizedBox(height: 20),

            // Post Description Field
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: 'Add description',
                filled: true,
                fillColor: Colors.grey[300],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 20),

            // Post's Location Field
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                hintText: 'Add location',
                filled: true,
                fillColor: Colors.grey[300],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 20),

            // Dropdown to select post type
            DropdownButtonFormField<String>(
              value: _postType,
              decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
              items: ["Locate", "Adopt", "Normal"].map((String type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _postType = value!;
                });
              },
            ),
            const SizedBox(height: 20),

            // Submit post button
            ElevatedButton(
              onPressed: _createPost,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              child: const Text('POST', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            // Button to submit the new post.
            // firebaseUIButton(context, 'POST', () {
            //   // Placeholder for adding post logic with Firebase.
            //   _databaseService.createLocatePost();
            //   Navigator.push(context,
            //       MaterialPageRoute(builder: (context) => Sitter()));  // SHOULD NAVIGATE TO Adopt OR Locate PAGE
            // }),
          ],
        ),
      ),
      bottomNavigationBar:buildBottomNavigationBar(context, 3),
    );
  }
}
