import './const.dart';
import './lib.dart';

class Border {
  List box, move;

  Border() {
    box = [];
    move = [];
    init();
  }

  Border.copy(this.box, this.move);

  String draw() {
    String str = "";
    GAME_HTML_NODE.style.height = "${W}px";
    GAME_HTML_NODE.style.width = "${W}px";

    final double offset = W / SIZE;

    // add dot
    for (int i = 0; i <= SIZE; i++) {
      for (int j = 0; j <= SIZE; j++) {
        str += """
        <div
          class="dot"
          style="
              top:${(i * offset).toInt()}px;
              left:${(j * offset).toInt()}px;
              width:${(DOT_SIZE).toInt()}px ;
              height:${(DOT_SIZE).toInt()}px">
        </div>
         """;
      }
    }

    //add box
    for (int i = 0; i < SIZE; i++) {
      for (int j = 0; j < SIZE; j++) {
        int index = i * SIZE + j;
        str += """
        <div
          class="box "
          style="
            top:${(i * offset + DOT_SIZE).toInt()}px;
            left:${(j * offset + DOT_SIZE).toInt()}px;
            width:${(offset - DOT_SIZE).toInt()}px ;
            height:${(offset - DOT_SIZE).toInt()}px ;"
          data-id="${index}">
        </div>
        """;
      }
    }

    for (int i = 0; i <= SIZE; i++) {
      for (int j = 0; j < SIZE; j++) {
        str += """
        <div
          class ="line-parent open"
          style="
            top:${(i * offset - VIEW_PLAY).toInt()}px;
            left:${(j * offset + DOT_SIZE).toInt()}px;
            width:${(offset - DOT_SIZE).toInt()}px ;
            height:${(DOT_SIZE + 2 * VIEW_PLAY).toInt()}px ;
            padding:${(VIEW_PLAY + DOT_SIZE / 4).toInt()}px 0"
          data-id="${getId(i, j, 'x')}"
        >
           <div class="line" data-id="${getId(i, j, 'x')}" style="height:${((1 * DOT_SIZE) / 2).toInt()}px;"></div>
        </div>
        """;
      }
    }

    //add col
    for (int i = 0; i < SIZE; i++) {
      for (int j = 0; j <= SIZE; j++) {
        str += """
        <div
          class ="line-parent open"
          style="
            top:${(i * offset + DOT_SIZE).toInt()}px;
            left:${(j * offset - VIEW_PLAY).toInt()}px;
            height:${(offset - DOT_SIZE).toInt()}px ;
            width:${(DOT_SIZE + 2 * VIEW_PLAY).toInt()}px ;
            padding:0 ${(VIEW_PLAY + DOT_SIZE / 4).toInt()}px "
          data-id="${getId(i, j, 'y')}"
        >
           <div class="line "   data-id="${getId(i, j, 'y')}" style=" height:${100}% ;"></div>
        </div>


        """;
      }
    }

    return str;
  }

  void init() {
    for (int i = 0; i < SIZE * SIZE; i++) {
      box.add(0);
    }
    //init row
    for (int i = 0; i <= SIZE; i++) {
      for (int j = 0; j < SIZE; j++) {
        String id = getId(i, j, 'x');
        move.add(id);
      }
    }

    //init col
    for (int i = 0; i < SIZE; i++) {
      for (int j = 0; j <= SIZE; j++) {
        String id = getId(i, j, 'y');
        move.add(id);
      }
    }
  }

  bool isFull() {
    return move.length == 0;
  }

  int score() {
    int num0, num1, num2, num3, h, c;
    num0 = num1 = num2 = num3 = h = c = 0;
    for (var item in box) {
      if (item == 0)
        num0++;
      else if (item == 1)
        num1++;
      else if (item == 2)
        num2++;
      else if (item == 3)
        num3++;
      else if (item == 'h')
        h++;
      else if (item == 'c') c++;
    }
    ;

    //if (c > (SIZE * SIZE) / 2) return 1000000;
    //if (h > (SIZE * SIZE) / 2) return -1000000;

    return (c - h) * 1000;
  }

  bool isFinished(depth) {
    return depth == 0 || isFull();
  }

  Border getCopy() {
    List newBox = List.from(box);
    List newMove = List.from(move);

    return new Border.copy(newBox, newMove);
  }

  int place(id, player) {

    int numBoxFull = 0;
    int index = move.indexOf(id);


    //in falet move
    if (index == -1) return -1;

    move.remove(id);

    List array = id.split("_");

    var first = int.tryParse(array[0]);
    var secand = int.tryParse(array[1]);
    int res;

    if (first != null) {
      res = ++box[first];
      if (res == 4) {
        box[first] = player;
        numBoxFull++;
      }
    }
    if (secand != null) {
      res = ++box[secand];
      if (res == 4) {
        box[secand] = player;
        numBoxFull++;
      }
    }

    return numBoxFull;
  }

  Map<String, List> getRes() {
    List arrayH = [];
    List arrayC = [];
    for (int i = box.length - 1; i >= 0; i -= 1) {

      if (box[i] == "h") {
        arrayH.add(i);
      } else if (box[i] == "c") {
        arrayC.add(i);
      }
    }
    Map<String, List> res = new Map<String, List>();

    res["c"] = arrayC;
    res["h"] = arrayH;
    return res;
  }
}
