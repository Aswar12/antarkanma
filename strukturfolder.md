New-Item lib\main.dart
New-Item lib\app\bindings\initial_binding.dart
New-Item lib\app\constants\app_colors.dart
New-Item lib\app\constants\app_strings.dart
New-Item lib\app\constants\app_theme.dart
New-Item lib\app\controllers\auth_controller.dart
New-Item lib\app\controllers\user_controller.dart
New-Item lib\app\controllers\merchant_controller.dart
New-Item lib\app\controllers\product_controller.dart
New-Item lib\app\controllers\order_controller.dart
New-Item lib\app\controllers\courier_controller.dart
New-Item lib\app\data\models\user_model.dart
New-Item lib\app\data\models\merchant_model.dart
New-Item lib\app\data\models\product_model.dart
New-Item lib\app\data\models\order_model.dart
New-Item lib\app\data\models\courier_model.dart
New-Item lib\app\data\providers\api_provider.dart
New-Item lib\app\data\providers\local_storage_provider.dart
New-Item lib\app\data\repositories\user_repository.dart
New-Item lib\app\data\repositories\merchant_repository.dart
New-Item lib\app\data\repositories\product_repository.dart
New-Item lib\app\data\repositories\order_repository.dart
New-Item lib\app\data\repositories\courier_repository.dart
New-Item lib\app\modules\auth\views\login_view.dart
New-Item lib\app\modules\auth\views\register_view.dart
New-Item lib\app\modules\auth\auth_binding.dart
New-Item lib\app\modules\user\views\user_home_view.dart
New-Item lib\app\modules\user\views\product_list_view.dart
New-Item lib\app\modules\user\views\cart_view.dart
New-Item lib\app\modules\user\views\order_history_view.dart
New-Item lib\app\modules\user\user_binding.dart
New-Item lib\app\modules\merchant\views\merchant_home_view.dart
New-Item lib\app\modules\merchant\views\product_management_view.dart
New-Item lib\app\modules\merchant\views\order_management_view.dart
New-Item lib\app\modules\merchant\merchant_binding.dart
New-Item lib\app\modules\courier\views\courier_home_view.dart
New-Item lib\app\modules\courier\views\delivery_list_view.dart
New-Item lib\app\modules\courier\courier_binding.dart
New-Item lib\app\routes\app_pages.dart
New-Item lib\app\services\auth_service.dart
New-Item lib\app\services\api_service.dart
New-Item lib\app\widgets\custom_button.dart
New-Item lib\app\widgets\custom_text_field.dart
New-Item lib\app\widgets\loading_indicator.dart
New-Item lib\utils\helpers.dart
New-Item lib\utils\validators.dart


app/
├── bindings/              # Dependency bindings
│       initial_binding.dart
├── constants/             # Constants used throughout the app
│       app_colors.dart
│       app_strings.dart
│       app_theme.dart
│       app_values.dart
├── controllers/           # Business logic controllers
│       auth_controller.dart
│       courier_controller.dart
│       merchant_controller.dart
│       order_controller.dart
│       product_controller.dart
│       user_controller.dart
├── data/                  # Data layer
│   ├── models/            # Data models
│   │       courier_model.dart
│   │       merchant_model.dart
│   │       order_model.dart
│   │       product_model.dart
│   │       user_model.dart
│   ├── providers/         # Data providers (API, local storage)
│   │       api_provider.dart
│   │       auth_provider.dart
│   │       local_storage_provider.dart
│   └── repositories/      # Data repositories
│           courier_repository.dart
│           merchant_repository.dart
│           order_repository.dart
│           product_repository.dart
│           user_repository.dart
├── modules/               # Feature modules
│   ├── auth/              # Authentication feature
│   │   │   auth_binding.dart
│   │   └── views
│   │           login_view.dart
│   │           register_view.dart
│   │           sign_in_page.dart
│   │           sign_up_page.dart
│   ├── courier/           # Courier feature
│   │   │   courier_binding.dart
│   │   └── views
│   │           courier_home_view.dart
│   │           delivery_list_view.dart
│   ├── merchant/          # Merchant feature
│   │   │   merchant_binding.dart
│   │   └── views
│   │           merchant_home_view.dart
│   │           order_management_view.dart
│   │           product_management_view.dart
│   ├── splash/            # Splash screen feature
│   │           views
│   │           splash_page.dart
│   └── user/              # User feature
│       │   user_binding.dart
│       └── views
│               cart_view.dart
│               chat_page.dart
│               home_page.dart
│               order_history_view.dart
│               order_page.dart
│               product_list_view.dart
│               profile_page.dart
│               user_home_view.dart
│               user_main_page.dart
├── routes/                # Application routes
│       app_pages.dart
├── services/              # Services (API, Auth)
│       api_service.dart
│       auth_service.dart
│       storage_service.dart
├── utils/                 # Utility functions
│       helpers.dart
│       validators.dart
└── widgets/               # Reusable widgets
        custom_button.dart
        custom_text_field.dart
        loading_indicator.dart
        product_card.dart
        product_tile.dart