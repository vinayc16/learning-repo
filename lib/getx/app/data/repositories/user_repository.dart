import 'package:dio/dio.dart';
import '../../core/constant/api_constant.dart';
import '../model/response_modal.dart';
import '../model/user_modal.dart';
import '../services/api_services.dart';

class UserRepository {
  final ApiServices _apiServices = ApiServices();
  CancelToken? _cancelToken;

  // Get All Users
  Future<ApiResponse<List<UserModel>>> getUsers() async {
    _cancelToken = CancelToken();

    final queryParameters = <String, dynamic>{};

    return await _apiServices.getList<UserModel>(
      ApiConstants.users,
      UserModel.fromJson,
      queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
      cancelToken: _cancelToken,
    );
  }

  // getUserById

  Future<ApiResponse<UserModel>> getUserById(int id) async {
    _cancelToken = CancelToken();
    final queryParameters = <String, dynamic>{};

    return await _apiServices.get<UserModel>(
      '${ApiConstants.users}/$id',
          (data) => UserModel.fromJson(data),
      cancelToken: _cancelToken,
    );
  }

  // create New User
  Future<ApiResponse<UserModel>> createUser(UserModel user) async{
    _cancelToken = CancelToken();
    return await _apiServices.post<UserModel>(
        ApiConstants.users,
            (data) => UserModel.fromJson(user),
        data:user.toJson(),
        cancelToken: _cancelToken
    );
  }

  // update User

  Future<ApiResponse<UserModel>> updateUser(UserModel user) async{
    _cancelToken = CancelToken();
    return await _apiServices.put<UserModel>(
        '${ApiConstants.users}/${user.id}',
            (data)=> UserModel.fromJson(user),
        data:user.toJson(),
        cancelToken: _cancelToken
    );
  }


// delete user

  Future<ApiResponse<bool>> deleteUser(int id) async{
    _cancelToken = CancelToken();
    return await _apiServices.delete<bool>(
        '${ApiConstants.users}/$id',
            (data)=> true,
        cancelToken: _cancelToken
    );
  }


  void cancelRequest(){
    _cancelToken?.cancel("Request cancelled by the user");
  }
}