import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';
import '../core/utils/api_response.dart';

/// Product Provider for state management
class ProductProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();

  // State variables
  List<ProductModel> _products = [];
  ProductModel? _selectedProduct;
  bool _isLoading = false;
  String? _errorMessage;
  int _currentPage = 0;
  final int _itemsPerPage = 10;
  bool _hasMore = true;

  // Getters
  List<ProductModel> get products => _products;
  ProductModel? get selectedProduct => _selectedProduct;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;
  int get currentPage => _currentPage;

  /// Fetch products with pagination
  Future<void> fetchProducts({bool refresh = false}) async {
    if (_isLoading) return;

    if (refresh) {
      _currentPage = 0;
      _products = [];
      _hasMore = true;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _productService.getProducts(
        offset: _currentPage * _itemsPerPage,
        limit: _itemsPerPage,
      );

      if (response.success && response.data != null) {
        if (response.data!.isEmpty) {
          _hasMore = false;
        } else {
          _products.addAll(response.data!);
          _currentPage++;
        }
      } else {
        _errorMessage = response.message ?? 'Failed to fetch products';
      }
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: $e';
      if (kDebugMode) {
        print('Error fetching products: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch single product by ID
  Future<void> fetchProductById(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _productService.getProductById(id);

      if (response.success && response.data != null) {
        _selectedProduct = response.data;
      } else {
        _errorMessage = response.message ?? 'Failed to fetch product';
      }
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: $e';
      if (kDebugMode) {
        print('Error fetching product: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create a new product
  Future<bool> createProduct(ProductModel product) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _productService.createProduct(product);

      if (response.success && response.data != null) {
        _products.insert(0, response.data!);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message ?? 'Failed to create product';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: $e';
      _isLoading = false;
      notifyListeners();
      if (kDebugMode) {
        print('Error creating product: $e');
      }
      return false;
    }
  }

  /// Update a product
  Future<bool> updateProduct(int id, ProductModel product) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _productService.updateProduct(id, product);

      if (response.success && response.data != null) {
        final index = _products.indexWhere((p) => p.id == id);
        if (index != -1) {
          _products[index] = response.data!;
        }
        _selectedProduct = response.data;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message ?? 'Failed to update product';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: $e';
      _isLoading = false;
      notifyListeners();
      if (kDebugMode) {
        print('Error updating product: $e');
      }
      return false;
    }
  }

  /// Delete a product
  Future<bool> deleteProduct(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _productService.deleteProduct(id);

      if (response.success) {
        _products.removeWhere((p) => p.id == id);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message ?? 'Failed to delete product';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: $e';
      _isLoading = false;
      notifyListeners();
      if (kDebugMode) {
        print('Error deleting product: $e');
      }
      return false;
    }
  }

  /// Clear selected product
  void clearSelectedProduct() {
    _selectedProduct = null;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Reset provider state
  void reset() {
    _products = [];
    _selectedProduct = null;
    _isLoading = false;
    _errorMessage = null;
    _currentPage = 0;
    _hasMore = true;
    notifyListeners();
  }
}
