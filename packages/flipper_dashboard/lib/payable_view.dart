import 'package:flipper_dashboard/PreviewSaleButton.dart';
import 'package:flipper_dashboard/typeDef.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

class PayableView extends HookConsumerWidget {
  const PayableView({
    Key? key,
    required this.ticketHandler,
    this.completeTransaction,
    required this.model,
    this.previewCart,
    this.wording,
    required this.transactionId,
    required this.mode,
    required this.digitalPaymentEnabled,
  }) : super(key: key);

  final Function ticketHandler;
  final CoreViewModel model;
  final CompleteTransaction? completeTransaction;
  final PreviewCart? previewCart;
  final String transactionId;
  final String? wording;
  final SellingMode mode;
  final bool digitalPaymentEnabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync =
        ref.watch(transactionsProvider(forceRealData: true));
    // Get the current screen width to determine layout
    final screenWidth = MediaQuery.of(context).size.width;
    // Threshold for switching to vertical layout
    final isSmallScreen = screenWidth < 600;

    return Padding(
      padding: const EdgeInsets.fromLTRB(19.0, 0, 19.0, 30.5),
      child: isSmallScreen
          ? _buildVerticalLayout(context, ref, transactionsAsync)
          : _buildHorizontalLayout(context, ref, transactionsAsync),
    );
  }

  // Vertical layout for small screens and mobile
  Widget _buildVerticalLayout(BuildContext context, WidgetRef ref,
      AsyncValue<List<ITransaction>> transactionsAsync) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: 64,
          width: double.infinity,
          child: TextButton(
            style: secondaryButtonStyle,
            onPressed: () {
              ticketHandler();
            },
            child: transactionsAsync.when(
              data: (transactions) => _buildTicket(
                tickets: transactions.length,
                transactions: transactions.length,
                context: context,
                isCompact: true,
              ),
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text('Error: $error'),
            ),
          ),
        ).shouldSeeTheApp(ref, featureName: AppFeature.Tickets),
        const SizedBox(height: 10)
            .shouldSeeTheApp(ref, featureName: AppFeature.Tickets),
        SizedBox(
          height: 64,
          width: double.infinity,
          child: PreviewSaleButton(
            digitalPaymentEnabled: digitalPaymentEnabled,
            transactionId: transactionId,
            mode: mode,
            wording: wording ?? "Pay",
            completeTransaction: completeTransaction,
            previewCart: previewCart,
          ),
        ),
      ],
    );
  }

  // Horizontal layout for larger screens
  Widget _buildHorizontalLayout(BuildContext context, WidgetRef ref,
      AsyncValue<List<ITransaction>> transactionsAsync) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: SizedBox(
            height: 64,
            child: TextButton(
              style: secondaryButtonStyle,
              onPressed: () {
                ticketHandler();
              },
              child: transactionsAsync.when(
                data: (transactions) => _buildTicket(
                  tickets: transactions.length,
                  transactions: transactions.length,
                  context: context,
                  isCompact: false,
                ),
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) => Text('Error: $error'),
              ),
            ),
          ),
        ).shouldSeeTheApp(ref, featureName: AppFeature.Tickets),
        const SizedBox(width: 10)
            .shouldSeeTheApp(ref, featureName: AppFeature.Tickets),
        PreviewSaleButton(
          digitalPaymentEnabled: digitalPaymentEnabled,
          transactionId: transactionId,
          mode: mode,
          wording: wording ?? "Pay",
          completeTransaction: completeTransaction,
          previewCart: previewCart,
        ),
      ],
    );
  }

  Widget _buildTicket({
    required int tickets,
    required int transactions,
    required BuildContext context,
    required bool isCompact,
  }) {
    final bool hasTickets = tickets > 0;
    final bool hasNoTransactions = transactions == 0;

    if (isCompact) {
      // More compact version for small screens
      return hasTickets || hasNoTransactions
          ? Text(
              FLocalization.of(context).tickets,
              textAlign: TextAlign.center,
              style: primaryTextStyle.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            )
          : Text(
              FLocalization.of(context).save,
              textAlign: TextAlign.center,
              style: primaryTextStyle.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            );
    }

    // Original version for larger screens
    return hasTickets || hasNoTransactions
        ? Text(
            FLocalization.of(context).tickets,
            textAlign: TextAlign.center,
            style: primaryTextStyle.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 17,
            ),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                FLocalization.of(context).save,
                textAlign: TextAlign.center,
                style: primaryTextStyle.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 17,
                ),
              ),
              Text(
                'New Transaction${tickets > 1 ? 's' : ''}',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: primaryTextStyle.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 17,
                ),
              ),
            ],
          );
  }
}
