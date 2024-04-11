import 'package:bible/init/preference_manager.dart';
import 'package:bible/init/verse_installer.dart';

// lbtn as Latest Bible Title Name(ex - 마태복음)
// lbt as Latest Bible Title(ex - 0)
// lbc as Latest Bible Chapter(ex - 1)
// bt as Bible Type (HAN)

class Init {
  static Future initialize() async {
    await getPref();
    await readBibleFileHAN();
    await readBibleFileGAE();
    await readBibleFileKJV();
    //await readBibleFileCEV();
  }
}
