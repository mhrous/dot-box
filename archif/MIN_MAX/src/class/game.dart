import "./const.dart";
import "./border.dart";

import "dart:html";
import "dart:js";

// html with dart

final NodeValidatorBuilder _htmlValidator = new NodeValidatorBuilder.common()
  ..allowElement('div', attributes: ['data-id', 'style']);

class Game {
  Border border;
  int round;
  int iterations;
  Game() {
    round = 0;
    iterations = 0;

    init();
  }

  void init() {
    border = new Border();
    String str = border.draw();
    GAME_HTML_NODE.setInnerHtml(str, validator: _htmlValidator);
    GAME_HTML_NODE.classes.add(getMy());
    addEvent();
  }

  void addEvent() {
    List arry = querySelectorAll(".line-parent.open");
    for (Element e in arry) {
      e.onClick.listen((e) => play(e));
    }
  }

  void play(MouseEvent event) {
    if (border.isFull()) return;
    Element e = event.target;
    String id = e.dataset["id"];
    int res = border.place(id, getMy());
    if (res == -1) return;

    if (e.classes.contains("line")) e = e.parent;
    e.classes.remove("open");
    e.classes.add(getMy());
    updateStatus();
    if (res > 0) return;

    GAME_HTML_NODE.classes.remove(getMy());
    switchRound();
    GAME_HTML_NODE.classes.add(getMy());
    generateComputerDecision();
  }

  String getMy() {
    return ROUND[round];
  }

  String getOther() {
    return ROUND[round ^ 1];
  }

  void generateComputerDecision() {
    int res = 1;
    while (res != 0 && !border.isFull()) {
      iterations = 0;
      List ai_move = maximizePlay(border, DEPTH);
      res = border.place(ai_move[0], "c");

      querySelector('div[data-id="${ai_move[0]}"]').classes.remove("open");
      querySelector('div[data-id="${ai_move[0]}"]').classes.add(getMy());
      updateStatus();
    }

    GAME_HTML_NODE.classes.remove(getMy());
    switchRound();
    GAME_HTML_NODE.classes.add(getMy());
  }

  List maximizePlay(newBorder, depth) {
    print("max1");

    int score = newBorder.score();

    if (newBorder.isFinished(depth)) return [null, score];

    List possibleMovements = newBorder.move;

    List max = [null, -999999];
    print("max2");
    for (String move in possibleMovements) {
      Border new_board = newBorder.getCopy();

      int res = new_board.place(move, 'c');

      if (res != -1) {
        iterations++;
        List next_move;

        if (res > 0) {
          next_move = maximizePlay(new_board, depth - 1);
        } else {
          next_move = minimizePlay(new_board, depth - 1);
        }

        if (max[0] == null || next_move[1] > max[1]) {
          max[0] = move;
          max[1] = next_move[1];
        }
      }
    }

    return max;
  }

  List minimizePlay(newBorder, depth) {
    print("min1");

    int score = newBorder.score();

    if (newBorder.isFinished(depth)) return [null, score];

    List possibleMovements = newBorder.move;

    List min = [null, 999999];
    print("min2");

    for (String move in possibleMovements) {
      Border new_board = newBorder.getCopy();

      int res = new_board.place(move, 'h');

      if (res != -1) {
        iterations++;
        List next_move;
        if (res > 0) {
          next_move = minimizePlay(new_board, depth - 1);
        } else {
          next_move = maximizePlay(new_board, depth - 1);
        }
        if (min[0] == null || next_move[1] < min[1]) {
          min[0] = move;
          min[1] = next_move[1];
        }
      }
    }
    return min;
  }

  void switchRound() {
    round ^= 1;
  }

  void updateStatus() {
    Map<String, List> res = border.getRes();

    RES_HUMAN_HTML_NODE.text = "${res["h"].length}";
    RES_COMPUTER_HTML_NODE.text = "${res["c"].length}";

    for (int i in res["c"]) {
      querySelector('div[data-id="$i"]').classes.add('c');
    }
    for (int i in res["h"]) {
      querySelector('div[data-id="$i"]').classes.add('h');
    }
    if (res["c"].length + res["h"].length == SIZE * SIZE) {
      if (res["c"].length < res["h"].length) {
        context.callMethod('swal', ["You have won!", '', "success"]);
      } else if (res["c"].length > res["h"].length) {
        context.callMethod('swal', ['You have lost!', '', "error"]);
      } else {
        context.callMethod('swal', ['opps .. tie', '', "info"]);
      }
      print(6);
    }
  }
}
