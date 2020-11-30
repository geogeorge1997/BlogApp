import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as Path;

class ProfilePictureUpload extends StatefulWidget {
  ProfilePictureUpload({Key key, this.user}) : super(key: key);

  final FirebaseUser user;

  @override
  _ProfilePictureUploadState createState() => _ProfilePictureUploadState();
}

class _ProfilePictureUploadState extends State<ProfilePictureUpload> {

  File _image;
  String _uploadedFileURL;
  final picker = ImagePicker();

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path, targetPath,
      quality: 88,
      rotate: 0,
    );

    print(file.lengthSync());
    print(result.lengthSync());

    return result;
  }

  @override
  Widget build(BuildContext context) {

    Future chooseFile() async {

      final pickedFile = await picker.getImage(source: ImageSource.gallery,maxHeight: 448,maxWidth: 280,imageQuality: 100);

      setState(() {
        _image = File(pickedFile.path);
        print('Image Path $_image');
      });

      var decodedImage = await decodeImageFromList(_image.readAsBytesSync());
      print(decodedImage.width);
      print(decodedImage.height);

    }

    //ResizeImage(_image,{100,100});

    Future uploadFile() async {
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child('ProfilePicture/'+widget.user.uid+'/${'ProfilePicture'}');
      StorageUploadTask uploadTask = storageReference.putFile(_image);
      await uploadTask.onComplete;
      print('File Uploaded');
      storageReference.getDownloadURL().then((fileURL) {
        setState(() {
          _uploadedFileURL = fileURL;
          print('Url = $fileURL');
          Navigator.pop(context, fileURL);
        });
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        title: Text("Upload Picture"),
        textTheme:Theme.of(context).textTheme.apply(
          fontFamily: 'Bebas Neue Regular',
          bodyColor: Colors.black,
          displayColor: Colors.black,
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text('Selected Image'),
            _image != null
                ? Image.asset(
              _image.path,
              height: 150,
            )
                : Container(height: 150),
            _image == null
                ? RaisedButton(
              child: Text('Choose File'),textColor: Colors.white,
              onPressed: chooseFile,
              color: Colors.black,
            )
                : Container(),
            _image != null
                ? RaisedButton(
              child: Text('Upload File'),textColor: Colors.white,
              onPressed: uploadFile,
              color: Colors.black,
            )
                : Container(),
            _image != null
                ? RaisedButton(
              child: Text('Clear Selection'),

            )
                : Container(),
            Text('Uploaded Image'),
            _uploadedFileURL != null
                ? Image.network(
              _uploadedFileURL,
              height: 150,
            )
                : Container(),
          ],
        ),
      ),
    );

  }
}