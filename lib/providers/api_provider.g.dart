// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(apiProducts)
final apiProductsProvider = ApiProductsProvider._();

final class ApiProductsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ApiProduct>>,
          List<ApiProduct>,
          FutureOr<List<ApiProduct>>
        >
    with $FutureModifier<List<ApiProduct>>, $FutureProvider<List<ApiProduct>> {
  ApiProductsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiProductsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiProductsHash();

  @$internal
  @override
  $FutureProviderElement<List<ApiProduct>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ApiProduct>> create(Ref ref) {
    return apiProducts(ref);
  }
}

String _$apiProductsHash() => r'951d9e341c15d56a0772062a369f1e5adf61e096';
