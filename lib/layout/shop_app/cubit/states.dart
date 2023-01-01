import '../../../models/change_favorites_model.dart';
import '../../../models/login_model.dart';

abstract class ShopStates {}

class ShopInitialState extends ShopStates {}

class ShopChangeBottomNavState extends ShopStates {}

class ShopLoadinginHomeState extends ShopStates {}

class ShopSuccessHomeState extends ShopStates {}

class ShopErrorHomeState extends ShopStates {}

class ShopSuccessCategoriesState extends ShopStates {}

class ShopErrorCategoriesState extends ShopStates {}

class ShopCategoryDetailLoadingState extends ShopStates {}

class ShopCategoryDetailSuccessState extends ShopStates {
  final String name;
  ShopCategoryDetailSuccessState(this.name);
}

class ShopCategoryDetailErrorState extends ShopStates {}

class ShopProductDetailLoadingState extends ShopStates {}

class ShopProductDetailSuccessState extends ShopStates {}

class ShopLoadingFromSearchProductDetailsState extends ShopStates {}

class ShopProductDetailErrorState extends ShopStates {}

class ShopChangeFavoritesState extends ShopStates {}

class ShopSuccessChangeFavoritesState extends ShopStates {
  final ChangeFavoriteModel model;
  ShopSuccessChangeFavoritesState(this.model);
}

class ShopErrorChangeFavoritesState extends ShopStates {}

class ShopLoadingGetFavoritesState extends ShopStates {}

class ShopSuccessGetFavoritesState extends ShopStates {}

class ShopErrorGetFavoritesState extends ShopStates {}

class ShopLoadingUserDataState extends ShopStates {}

class ShopSuccessUserDataState extends ShopStates {
  final ShopLoginModel loginModel;
  ShopSuccessUserDataState(this.loginModel);
}

class ShopErrorUserDataState extends ShopStates {}

class ShopLoadingUpdateUserState extends ShopStates {}

class ShopSuccessUpdateUserState extends ShopStates {
  final ShopLoginModel loginModel;
  ShopSuccessUpdateUserState(this.loginModel);
}

class ShopErrorUpdateUserState extends ShopStates {}
