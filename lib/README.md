# Flutter Product Store - Clean Architecture with Provider & Dio

## 🏗️ Architecture Overview

This project follows a **Clean Architecture** pattern with proper separation of concerns:

```
lib/
├── core/
│   ├── api/
│   │   ├── api_client.dart              # Singleton Dio client
│   │   └── interceptors/
│   │       ├── logging_interceptor.dart  # Request/Response logging
│   │       └── error_interceptor.dart    # Error handling
│   └── utils/
│       ├── api_constants.dart            # API endpoints & constants
│       └── api_response.dart             # Generic response wrapper
├── models/
│   ├── product_model.dart                # Product data model
│   └── category_model.dart               # Category data model
├── services/
│   └── product_service.dart              # API service layer
├── providers/
│   └── product_provider.dart             # State management
├── screens/
│   └── products/
│       ├── product_list_screen.dart      # Product listing UI
│       └── product_detail_screen.dart    # Product details UI
└── widgets/
    └── product_card.dart                 # Reusable product card
```

---

## 🚀 Features Implemented

### ✅ **API Client (Dio)**
- **Singleton pattern** for efficient resource management
- **Interceptors** for logging and error handling
- **All HTTP Methods**:
  - `GET` - Fetch data
  - `POST` - Create resources
  - `PUT` - Update entire resource
  - `PATCH` - Partial update
  - `DELETE` - Remove resource
  - `Multipart` - File uploads
  - `Download` - File downloads

### ✅ **Error Handling**
- **Status Code Handling**: 400, 401, 403, 404, 500, etc.
- **Network Errors**: Connection timeout, no internet, etc.
- **User-Friendly Messages**: Readable error messages for all scenarios
- **Error Interceptor**: Centralized error transformation

### ✅ **State Management (Provider)**
- **ProductProvider**: Manages product state
- **Pagination**: Load more products on scroll
- **CRUD Operations**: Create, Read, Update, Delete
- **Loading States**: Shows loading indicators
- **Error States**: Displays error messages

### ✅ **API Integration**
Using **Platzi Fake Store API**: `https://api.escuelajs.co/api/v1`

#### **Endpoints Implemented**:
1. `GET /products` - Fetch all products (with pagination)
2. `GET /products/:id` - Fetch single product by ID
3. `GET /products/slug/:slug` - Fetch product by slug
4. `POST /products` - Create new product
5. `PUT /products/:id` - Update product
6. `PATCH /products/:id` - Partial update
7. `DELETE /products/:id` - Delete product
8. `GET /products/:id/related` - Get related products

---

## 📱 Screens

### 1. **Product List Screen**
- Grid layout with 2 columns
- Infinite scroll pagination
- Pull-to-refresh
- Loading & error states
- Smooth transitions

### 2. **Product Detail Screen**
- Image carousel with indicators
- Product information (title, price, description)
- Category badge
- Add to cart button
- Favorite button

---

## 🎨 Design Features

- **Dark Theme** with modern color scheme
- **Glassmorphism effects**
- **Smooth animations**
- **Responsive grid layout**
- **Loading states** with indicators
- **Error handling UI**

---

## 🛠️ How to Use

### **1. Run the App**
```bash
flutter pub get
flutter run
```

### **2. API Service Example**
```dart
// Initialize service
final productService = ProductService();

// Fetch products
final response = await productService.getProducts(offset: 0, limit: 10);

if (response.success) {
  print('Products: ${response.data}');
} else {
  print('Error: ${response.message}');
}
```

### **3. Provider Usage**
```dart
// In your widget
final provider = Provider.of<ProductProvider>(context);

// Fetch products
await provider.fetchProducts(refresh: true);

// Access data
final products = provider.products;
final isLoading = provider.isLoading;
final error = provider.errorMessage;
```

### **4. Direct API Client Usage**
```dart
final apiClient = ApiClient();

// GET request
final response = await apiClient.get('/products');

// POST request
final createResponse = await apiClient.post(
  '/products',
  data: {'title': 'New Product', 'price': 100},
);

// Multipart upload
final formData = FormData.fromMap({
  'file': await MultipartFile.fromFile(filePath),
});
final uploadResponse = await apiClient.uploadMultipart(
  '/files/upload',
  formData: formData,
);
```

---

## 📦 API Response Structure

All API calls return `ApiResponse<T>`:

```dart
class ApiResponse<T> {
  final bool success;      // True if successful
  final T? data;           // Response data
  final String? message;   // Success/error message
  final int? statusCode;   // HTTP status code
  final dynamic error;     // Error object
}
```

**Success Example**:
```dart
ApiResponse.success(
  data: products,
  statusCode: 200,
  message: 'Products fetched successfully',
);
```

**Error Example**:
```dart
ApiResponse.error(
  message: 'Failed to fetch products',
  statusCode: 500,
  error: exception,
);
```

---

## 🔧 Configuration

### **API Base URL**
Located in `lib/core/utils/api_constants.dart`:

```dart
static const String baseUrl = 'https://api.escuelajs.co/api/v1';
```

### **Timeout Settings**
In `lib/core/api/api_client.dart`:

```dart
connectTimeout: const Duration(seconds: 30),
receiveTimeout: const Duration(seconds: 30),
sendTimeout: const Duration(seconds: 30),
```

---

## 🧪 Testing

### **Test API Calls**
```dart
// Test GET
await productService.getProducts();

// Test POST
final newProduct = ProductModel(...);
await productService.createProduct(newProduct);

// Test PUT
await productService.updateProduct(id, updatedProduct);

// Test DELETE
await productService.deleteProduct(id);
```

---

## 📊 Status Code Handling

| Code | Error Message |
|------|---------------|
| 400  | Bad request. Please check your input. |
| 401  | Unauthorized. Please login again. |
| 403  | Forbidden. |
| 404  | Resource not found. |
| 422  | Validation error. |
| 429  | Too many requests. |
| 500  | Internal server error. |
| 502  | Bad gateway. |
| 503  | Service unavailable. |

---

## 🎯 Best Practices

1. ✅ **Singleton Dio Client** - Reuse HTTP client
2. ✅ **Error Interceptor** - Centralized error handling
3. ✅ **Generic Response Wrapper** - Consistent response format
4. ✅ **Separation of Concerns** - Models, Services, Providers, UI
5. ✅ **Loading States** - Better UX
6. ✅ **Null Safety** - Type-safe code
7. ✅ **Pagination** - Efficient data loading
8. ✅ **Pull-to-Refresh** - Better UX

---

## 🚀 Next Steps

1. Add **authentication** (login/register)
2. Implement **cart functionality**
3. Add **favorites** feature
4. Implement **search** and **filters**
5. Add **offline caching** with Hive/SQLite
6. Create **unit tests** for services
7. Add **integration tests** for screens

---

## 📚 Dependencies

```yaml
dependencies:
  dio: ^5.9.0          # HTTP client
  provider: ^6.1.5+1   # State management
  flutter: 
    sdk: flutter
```

---

## 🤝 Contributing

Feel free to add more features or improve the architecture!

---

## 📝 License

MIT License - Free to use and modify.
