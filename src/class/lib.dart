import "const.dart";
import "dart:html";

String getId(int row, int col, String dir) {
  int id_1, id_2, index;
  if (dir == "x") {
    index = row * SIZE + col;
    id_1 = index;
    id_2 = index - SIZE;
    if (row == SIZE) return "*_${id_2}_row";
    if (row == 0) return "${id_1}_*_row";
    return "${id_1}_${id_2}_row";
  } else {
    index = row * SIZE + col;
    id_1 = index;
    id_2 = index - 1;
    if (col == 0) return "${id_1}_*_col";
    if (col == SIZE) return "*_${id_2}_col";
    return "${id_1}_${id_2}_col";
  }
}

void set_DEPTH(i) {
  int d = 0;
  int res = 1;
  int maxIteroter = 500000;
  for (; i > 0 && maxIteroter > 0; i--) {
    d++;
    res *= i;
    maxIteroter -= res;
  }
  DEPTH = d >= 5 ? d : 5;
}
