import 'dart:html';

// size for border
final int SIZE = 3;

// css
final int W = 400;
final int DOT_SIZE = 25;
final int VIEW_PLAY = 20;

//html

final DivElement GAME_HTML_NODE = querySelector('.game');
final List ROUND = ['h', 'c'];
final Node RES_HUMAN_HTML_NODE = querySelector('#res_h');
final Node RES_COMPUTER_HTML_NODE = querySelector('#res_c');

final int DEPTH = 5;
