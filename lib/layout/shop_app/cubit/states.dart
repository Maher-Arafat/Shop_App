import 'package:newapp/models/change_cart_model.dart';
import 'package:newapp/models/order_model.dart';
import 'package:newapp/models/update_cart_model.dart';

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

class ShopLoadingCartsState extends ShopStates {}

class ShopChangeSuccessCartsState extends ShopStates {}

class ShopErrorChangeCartsState extends ShopStates {}

class ShopLoadingCartItemState extends ShopStates {}

class ShopChangeSuccessCartItemState extends ShopStates {
  final ChangeCartModel model;
  ShopChangeSuccessCartItemState(this.model);
}

class ShopErrorChangeCartItemState extends ShopStates {}

class ShopLoadingChangeCartState extends ShopStates {}

class ShopSuccessChangeCartState extends ShopStates {}

class ShopSrrorChangeCartState extends ShopStates {}

class ShopLoadingChangeQuantityItemState extends ShopStates {}

class ShopSuccessChangeQuantityItemState extends ShopStates {
  final UpdateCartModel model;
  ShopSuccessChangeQuantityItemState(this.model);
}

class ShopErrorChangeQuantityItemState extends ShopStates {}

class ShopLoadingAddOrderState extends ShopStates {}

class ShopSuccessAddOrderState extends ShopStates {
  AddOrderModel model;
  ShopSuccessAddOrderState(this.model);
}

class ShopErrorAddOrderState extends ShopStates {}

class ShopLoadingGetOrdersState extends ShopStates {}

class ShopSuccessGetOrdersState extends ShopStates {}

class ShopErrorGetOrdersState extends ShopStates {}

class ShopLoadingOrderDetailsState extends ShopStates {}

class ShopSuccessOrderDetailsState extends ShopStates {
  final OrderDetailsModel orderItemsDetails;
  ShopSuccessOrderDetailsState(this.orderItemsDetails);
}

class ShopErrorOrderDetailsState extends ShopStates {}

class ShopCancelLoadingOrderState extends ShopStates {}

class ShopCancelSuccessOrderState extends ShopStates {
  final CancelOrderModel cancelOrderModel;
  ShopCancelSuccessOrderState(this.cancelOrderModel);
}

class ShopCancelErrorOrderState extends ShopStates {}

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
