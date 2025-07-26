import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_book_example/features_personal/user_model.dart';
import 'package:flutter_book_example/pages/page_home.dart';
import 'package:flutter_book_example/provider/provider_basket.dart';
import 'package:flutter_book_example/widgets/constant.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class PageConfirm extends StatefulWidget {
  final UserModel? personal;
  final String? paymetMethod;
  final String? adress;
  final bool? success;
  const PageConfirm({
    super.key,
    required this.personal,
    this.paymetMethod,
    this.adress,
    this.success,
  });

  @override
  State<PageConfirm> createState() => _PageConfirmState();
}

class _PageConfirmState extends State<PageConfirm> {
  bool isChecking = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          isChecking = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final basket = Provider.of<BasketProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(color: Colors.black38),
          Center(child: isChecking ? checkingCard() : resultCard(basket)),
        ],
      ),
    );
  }

  Widget checkingCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(
              "Bilgileriniz kontrol ediliyor...",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget resultCard(BasketProvider basket) {
    String todaysDate = DateFormat("dd.MM.yyyy").format(DateTime.now());
    final random = Random();
    String orderNo = (1000 + random.nextInt(9000)).toString();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: widget.success == true ? Colors.green : Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                Icon(
                  widget.success == true ? Icons.check_circle : Icons.error,
                  size: 60,
                  color: kTextWhiteColor,
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        widget.success == true
                            ? "Sayın ${widget.personal?.username ?? "Bilinmeyen Kullanıcı"},\nSiparişiniz alınmıştır!"
                            : "Siparişiniz başarısız oldu!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: kTextWhiteColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (widget.success == true) ...[
                      const SizedBox(height: 15),
                      Table(
                        children: [
                          _confirmTableRow("Sipariş No:", orderNo),
                          _confirmTableRow("Sipariş Tarihi:", todaysDate),
                          _confirmTableRow(
                            "Ürün Sayısı:",
                            "${basket.totalItems} adet",
                          ),
                          _confirmTableRow(
                            "Ödeme Tipi",
                            "${widget.paymetMethod}",
                          ),
                          _confirmTableRow(
                            "Ödenen Tutar:",
                            "${NumberFormat.currency(locale: 'tr_TR', symbol: '', decimalDigits: 2).format(basket.totalPrice)} ₺",
                          ),
                          _confirmTableRow("Tahmini Teslimat:", "3 iş günü"),
                          _confirmTableRow(
                            "Teslimat Adresi:",
                            "${widget.adress}",
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),
                      Text(
                        "Alınan Ürünler:",
                        style: TextStyle(
                          color: kTextWhiteColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...basket.basketBooks.entries.map((entry) {
                        final book = entry.key;
                        final int quantity = entry.value;
                        return Table(
                          children: [
                            _confirmTableRow(
                              "- ${book.volumeInfo?.title ?? "Ürün"}",
                              "$quantity adet",
                            ),
                          ],
                        );
                      }),
                    ],
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: widget.success == true
                            ? () {
                                basket.deleteBookList();
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PageHome(),
                                  ),
                                  (route) => false,
                                );
                              }
                            : () {
                                Navigator.pop(context);
                              },
                        child: Text(
                          widget.success == true
                              ? "Anasayfaya Dön"
                              : "Geri Dön",
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

TableRow _confirmTableRow(String name, String value) {
  return TableRow(
    children: [
      TableCell(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Text(
            name,
            style: TextStyle(color: kTextWhiteColor, fontSize: 16),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(6.0),
        child: Text(
          value,
          style: TextStyle(color: kTextWhiteColor, fontSize: 16),
        ),
      ),
    ],
  );
}
