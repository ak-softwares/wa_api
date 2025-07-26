enum TextSizes { small, medium, large }

enum UserType { customer, vendor, admin, n8nUser}

enum SearchType { accountVoucher, transaction, product }

enum OrderType { purchase, sale, }

enum OrientationType {horizontal, vertical}

enum EcommercePlatform { none, woocommerce, shopify, amazon}

enum PurchaseListType { purchasable, purchased, notAvailable, vendors }

enum SyncType { add, update, check }

enum SyncStatus { idle, fetching, checking, pushing, completed, failed }