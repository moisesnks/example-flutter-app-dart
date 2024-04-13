import 'package:flutter/foundation.dart';
import 'dart:io';
import '../models/profile.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';

class ProfileViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService;
  final AuthService _authService;
  final StorageService _storageService;

  Profile? _currentProfile;
  File? _selectedImageFile;
  bool _isLoading = false;
  String? _errorMessage;

  ProfileViewModel(
      this._firestoreService, this._authService, this._storageService);

  bool get isLoading => _isLoading;
  Profile? get currentProfile => _currentProfile;
  File? get selectedImageFile => _selectedImageFile;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _authService.isAuthenticated;

  set selectedImageFile(File? file) {
    _selectedImageFile = file;
    notifyListeners();
  }

  Future<void> fetchProfile() async {
    if (!isAuthenticated) {
      _errorMessage = "No authenticated user.";
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();
    try {
      _currentProfile = await _firestoreService.getProfile();
    } catch (e) {
      _errorMessage = 'Failed to load profile: ${e.toString()}';
      _currentProfile = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadProfilePhoto(Uint8List? newPhotoBytes) async {
    if (newPhotoBytes == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Subir la imagen a storage y obtener la URL
      final newPhotoUrl =
          await _storageService.uploadProfileImage(newPhotoBytes);

      // Asignar la nueva URL de la foto al perfil local
      if (_currentProfile != null) {
        _currentProfile!.photoUrl = newPhotoUrl;
      }
    } catch (e) {
      _errorMessage = 'Failed to upload photo: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitProfileChanges(profile) async {
    // Envía los cambios del perfil a Firestore
    if (profile != null) {
      _isLoading = true;
      notifyListeners();
      try {
        await _firestoreService.updateProfile(profile!);
      } catch (e) {
        _errorMessage = 'Failed to submit changes: ${e.toString()}';
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> logout() async {
    try {
      await _authService.signOut();
      _currentProfile = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error logging out: ${e.toString()}';
      notifyListeners();
    }
  }
}
