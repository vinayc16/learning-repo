import 'package:dio/dio.dart';
import '../core/api/api_client.dart';
import '../core/utils/api_constants.dart';
import '../core/utils/api_response.dart';
import '../models/product_model.dart';

/// Product Service for all product-related API calls
class ProductService {
  final ApiClient _apiClient = ApiClient();

  /// Get all products with pagination
  Future<ApiResponse<List<ProductModel>>> getProducts({
    int offset = 0,
    int limit = 10,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.productsWithPagination(offset: offset, limit: limit),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final products = data.map((e) => ProductModel.fromJson(e)).toList();

        return ApiResponse.success(
          data: products,
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse.error(
          message: 'Failed to fetch products',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      return ApiResponse.error(
        message: e.message ?? 'An error occurred',
        statusCode: e.response?.statusCode,
        error: e,
      );
    } catch (e) {
      return ApiResponse.error(
        message: 'Unexpected error: $e',
        error: e,
      );
    }
  }

  /// Get single product by ID
  Future<ApiResponse<ProductModel>> getProductById(int id) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.productById(id),
      );

      if (response.statusCode == 200) {
        final product = ProductModel.fromJson(response.data);

        return ApiResponse.success(
          data: product,
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse.error(
          message: 'Failed to fetch product',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      return ApiResponse.error(
        message: e.message ?? 'An error occurred',
        statusCode: e.response?.statusCode,
        error: e,
      );
    } catch (e) {
      return ApiResponse.error(
        message: 'Unexpected error: $e',
        error: e,
      );
    }
  }

  /// Get single product by slug
  Future<ApiResponse<ProductModel>> getProductBySlug(String slug) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.productBySlug(slug),
      );

      if (response.statusCode == 200) {
        final product = ProductModel.fromJson(response.data);

        return ApiResponse.success(
          data: product,
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse.error(
          message: 'Failed to fetch product',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      return ApiResponse.error(
        message: e.message ?? 'An error occurred',
        statusCode: e.response?.statusCode,
        error: e,
      );
    } catch (e) {
      return ApiResponse.error(
        message: 'Unexpected error: $e',
        error: e,
      );
    }
  }

  /// Create a new product (POST)
  Future<ApiResponse<ProductModel>> createProduct(
      ProductModel product) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.products,
        data: product.toCreateJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final createdProduct = ProductModel.fromJson(response.data);

        return ApiResponse.success(
          data: createdProduct,
          message: 'Product created successfully',
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse.error(
          message: 'Failed to create product',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      return ApiResponse.error(
        message: e.message ?? 'An error occurred',
        statusCode: e.response?.statusCode,
        error: e,
      );
    } catch (e) {
      return ApiResponse.error(
        message: 'Unexpected error: $e',
        error: e,
      );
    }
  }

  /// Update a product (PUT)
  Future<ApiResponse<ProductModel>> updateProduct(
      int id, ProductModel product) async {
    try {
      final response = await _apiClient.put(
        ApiConstants.productById(id),
        data: product.toUpdateJson(),
      );

      if (response.statusCode == 200) {
        final updatedProduct = ProductModel.fromJson(response.data);

        return ApiResponse.success(
          data: updatedProduct,
          message: 'Product updated successfully',
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse.error(
          message: 'Failed to update product',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      return ApiResponse.error(
        message: e.message ?? 'An error occurred',
        statusCode: e.response?.statusCode,
        error: e,
      );
    } catch (e) {
      return ApiResponse.error(
        message: 'Unexpected error: $e',
        error: e,
      );
    }
  }

  /// Partial update a product (PATCH)
  Future<ApiResponse<ProductModel>> patchProduct(
      int id, Map<String, dynamic> updates) async {
    try {
      final response = await _apiClient.patch(
        ApiConstants.productById(id),
        data: updates,
      );

      if (response.statusCode == 200) {
        final updatedProduct = ProductModel.fromJson(response.data);

        return ApiResponse.success(
          data: updatedProduct,
          message: 'Product patched successfully',
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse.error(
          message: 'Failed to patch product',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      return ApiResponse.error(
        message: e.message ?? 'An error occurred',
        statusCode: e.response?.statusCode,
        error: e,
      );
    } catch (e) {
      return ApiResponse.error(
        message: 'Unexpected error: $e',
        error: e,
      );
    }
  }

  /// Delete a product
  Future<ApiResponse<bool>> deleteProduct(int id) async {
    try {
      final response = await _apiClient.delete(
        ApiConstants.productById(id),
      );

      if (response.statusCode == 200) {
        return ApiResponse.success(
          data: true,
          message: 'Product deleted successfully',
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse.error(
          message: 'Failed to delete product',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      return ApiResponse.error(
        message: e.message ?? 'An error occurred',
        statusCode: e.response?.statusCode,
        error: e,
      );
    } catch (e) {
      return ApiResponse.error(
        message: 'Unexpected error: $e',
        error: e,
      );
    }
  }

  /// Get related products by ID
  Future<ApiResponse<List<ProductModel>>> getRelatedProducts(int id) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.relatedProducts(id),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final products = data.map((e) => ProductModel.fromJson(e)).toList();

        return ApiResponse.success(
          data: products,
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse.error(
          message: 'Failed to fetch related products',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      return ApiResponse.error(
        message: e.message ?? 'An error occurred',
        statusCode: e.response?.statusCode,
        error: e,
      );
    } catch (e) {
      return ApiResponse.error(
        message: 'Unexpected error: $e',
        error: e,
      );
    }
  }

  /// Upload product image (Multipart)
  /// Note: This is a demo implementation as the API might not support this
  Future<ApiResponse<String>> uploadProductImage(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last,
        ),
      });

      final response = await _apiClient.uploadMultipart(
        '/files/upload', // Update with actual endpoint
        formData: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final imageUrl = response.data['location'] ?? '';

        return ApiResponse.success(
          data: imageUrl,
          message: 'Image uploaded successfully',
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse.error(
          message: 'Failed to upload image',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      return ApiResponse.error(
        message: e.message ?? 'An error occurred',
        statusCode: e.response?.statusCode,
        error: e,
      );
    } catch (e) {
      return ApiResponse.error(
        message: 'Unexpected error: $e',
        error: e,
      );
    }
  }
}
