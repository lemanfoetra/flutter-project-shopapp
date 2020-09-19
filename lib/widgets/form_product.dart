import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class FormProduct extends StatefulWidget {
  Function functionOnSubmit;
  String id;
  String name;
  String price;
  String description;
  String imagePath;
  String imageUrl;

  /// productId khusus untuk updata product
  String productId;

  FormProduct({
    this.functionOnSubmit,
    this.productId,
    this.name,
    this.price,
    this.description,
    this.imagePath,
    this.imageUrl,
  });

  @override
  _FormProductState createState() => _FormProductState();
}

class _FormProductState extends State<FormProduct> {
  final _imageFicker = new ImagePicker();
  final _formKey = GlobalKey<FormState>();
  double _previewImageHeight = 0;
  PickedFile imageFile;
  bool _isLoading = false;

  /// Mengambil Image
  Future pilihImage(ImageSource source) async {
    imageFile = await _imageFicker.getImage(source: source);
    if (imageFile != null) {
      setState(() {
        widget.imagePath = imageFile.path;
        _previewImageHeight = 250;
      });
    }
  }

  /// Untuk menyimpan hasil add atau edit
  Future<void> submit(BuildContext context) async {

    // if null = add new , if not null = edit
    if (widget.productId == null) {
      if (widget.imagePath != null) {
        _alert(context, 'Gambar tidak boleh kosong');
        return;
      }
    }

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      setState(() {
        _isLoading = true;
      });

      try {
        await widget.functionOnSubmit(
          widget.name,
          widget.price,
          widget.description,
          widget.imagePath,
        );
        _alert(context, 'Peroduk berhasil disimpan.');
      } catch (error) {
        _alert(context, error);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Widget untuk alert kesalahan error atau apapun itu.
  void _alert(BuildContext context, String message) {
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(
      SnackBar(content: Text(message.toString())),
    );
  }

  /// Validasi inputan
  String validateInput(String value, String namaInput) {
    if (value.isEmpty) {
      return '$namaInput tidak boleh kosong.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Container(
            padding: EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      initialValue: widget.name,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Nama Produk',
                      ),
                      onSaved: (value) {
                        widget.name = value;
                      },
                      validator: (value) => validateInput(value, 'Nama Produk'),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      initialValue: widget.price,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Harga (Rp)',
                      ),
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        widget.price = value;
                      },
                      validator: (value) => validateInput(value, 'Harga'),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      initialValue: widget.description,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Deskripsi Produk',
                      ),
                      keyboardType: TextInputType.multiline,
                      onSaved: (value) {
                        widget.description = value;
                      },
                      validator: (value) =>
                          validateInput(value, 'Deskripsi Produk'),
                    ),
                    SizedBox(height: 10),
                    Container(
                      child: Column(
                        children: <Widget>[
                          _previewImageHeight > 0
                              ? Container(
                                  height: _previewImageHeight,
                                  width: double.infinity,
                                  child: Image.file(File(imageFile.path),
                                      fit: BoxFit.cover),
                                )
                              : Container(),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.only(top: 10),
                            child: FlatButton(
                              color: Colors.transparent,
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.filter_center_focus),
                                    SizedBox(width: 10),
                                    Text('Pilih Gambar')
                                  ],
                                ),
                              ),
                              onPressed: () {
                                pilihImage(ImageSource.gallery);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      child: FlatButton(
                        onPressed: () {
                          submit(context);
                        },
                        child: Text('Simpan',
                            style: TextStyle(color: Colors.white)),
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
