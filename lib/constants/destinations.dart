import 'package:latlong2/latlong.dart';

enum BhawanCode {
  ab, cb, gb, jb, rjb, rkb, rb, rvb, sb, kb, vk
}

class Bhawan {
  late final BhawanCode ID;
  late final LatLng pos;
  Bhawan(this.ID, this.pos);
}

final Bhawans = [
  Bhawan(BhawanCode.ab, const LatLng(29.865589, 77.891750)),
  Bhawan(BhawanCode.cb, const LatLng(29.870297, 77.895220)),
  Bhawan(BhawanCode.gb, const LatLng(29.862378, 77.894652)),
  Bhawan(BhawanCode.jb, const LatLng(29.864622, 77.900300)),
  Bhawan(BhawanCode.rjb,  const LatLng(29.870915, 77.895081)),
  Bhawan(BhawanCode.rkb, const LatLng(29.871093, 77.895043)),
  Bhawan(BhawanCode.rb, const LatLng(29.869867, 77.895560)),
  Bhawan(BhawanCode.rvb,const LatLng(29.865066, 77.892200)),
  Bhawan(BhawanCode.sb, const LatLng(29.864622, 77.900300)),
  Bhawan(BhawanCode.kb, const LatLng(29.866588, 77.900222)),
  Bhawan(BhawanCode.vk, const LatLng(29.861093, 77.896730)),
];
