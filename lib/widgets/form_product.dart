import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class FormProduct extends StatefulWidget {
  final Function functionOnSubmit;
  String name;
  String price;
  String description;
  String imagePath;

  /// productId khusus untuk updata product
  final String productId;

  FormProduct({
    this.functionOnSubmit,
    this.productId,
    this.name,
    this.price,
    this.description,
    this.imagePath,
  });

  @override
  _FormProductState createState() => _FormProductState();
}

class _FormProductState extends State<FormProduct> {
  final _imageFicker = new ImagePicker();
  final _formKey = GlobalKey<FormState>();
  double _previewImageHeight = 0;
  PickedFile imageFile;

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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: widget.name,
                decoration: InputDecoration(
                  labelText: 'Nama Produk',
                ),
                onSaved: (value) {
                  widget.name = value;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: widget.price,
                decoration: InputDecoration(
                  labelText: 'Harga (Rp)',
                ),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  widget.price = value;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: widget.description,
                decoration: InputDecoration(
                  labelText: 'Deskripsi Produk',
                ),
                keyboardType: TextInputType.multiline,
                onSaved: (value) {
                  widget.description = value;
                },
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
                    Center(
                      child: Container(
                        padding: EdgeInsets.only(top: 10),
                        child: FlatButton(
                          color: Colors.yellow,
                          child: Icon(Icons.cloud_upload),
                          onPressed: () {
                            pilihImage(ImageSource.gallery);
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Container(
                  child: FlatButton(
                    onPressed: () {
                      widget.functionOnSubmit(
                        widget.name,
                        widget.price,
                        widget.description,
                        widget.imagePath,
                      );
                    },
                    child:
                        Text('Simpan', style: TextStyle(color: Colors.white)),
                    color: Colors.teal,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
