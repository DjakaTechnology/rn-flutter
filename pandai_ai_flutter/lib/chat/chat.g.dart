// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatServiceHash() => r'aa3d0cbd20fdaf3f2b9c0e82fce65a0c0a33096a';

/// Service that manages the chat state and message handling
///
/// Copied from [ChatService].
@ProviderFor(ChatService)
final chatServiceProvider = AutoDisposeAsyncNotifierProvider<
  ChatService,
  List<ChatMessageItem>
>.internal(
  ChatService.new,
  name: r'chatServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$chatServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ChatService = AutoDisposeAsyncNotifier<List<ChatMessageItem>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
