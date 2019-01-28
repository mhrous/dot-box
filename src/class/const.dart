import 'dart:html';

// size for border
final int SIZE = 6;

// cs
final int W = 500;
final int DOT_SIZE = 15;
final int VIEW_PLAY = 20;

//html

final DivElement GAME_HTML_NODE = querySelector('.game');
final List ROUND = ['h', 'c'];
final Node RES_HUMAN_HTML_NODE = querySelector('#res_h');
final Node RES_COMPUTER_HTML_NODE = querySelector('#res_c');

int DEPTH = 1;
