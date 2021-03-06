import 'package:bonfire/decoration/decoration.dart';
import 'package:bonfire/enemy/enemy.dart';
import 'package:bonfire/joystick/joystick_controller.dart';
import 'package:bonfire/map/map_game.dart';
import 'package:bonfire/player/player.dart';
import 'package:bonfire/rpg_game.dart';
import 'package:bonfire/util/game_component.dart';
import 'package:bonfire/util/game_controller.dart';
import 'package:bonfire/util/game_intercafe/game_interface.dart';
import 'package:flutter/material.dart';

class BonfireWidget extends StatefulWidget {
  final JoystickController joystick;
  final Player player;
  final GameInterface interface;
  final MapGame map;
  final List<Enemy> enemies;
  final List<GameDecoration> decorations;
  final GameComponent background;
  final bool constructionMode;
  final bool showCollisionArea;
  final GameController gameController;
  final Color constructionModeColor;
  final Color collisionAreaColor;

  const BonfireWidget({
    Key key,
    @required this.joystick,
    @required this.map,
    this.player,
    this.interface,
    this.enemies,
    this.decorations,
    this.gameController,
    this.background,
    this.constructionMode = false,
    this.showCollisionArea = false,
    this.constructionModeColor,
    this.collisionAreaColor,
  }) : super(key: key);

  @override
  _BonfireWidgetState createState() => _BonfireWidgetState();
}

class _BonfireWidgetState extends State<BonfireWidget>
    with TickerProviderStateMixin {
  RPGGame _game;

  @override
  void didUpdateWidget(BonfireWidget oldWidget) {
    if (widget.constructionMode) {
      if (_game.map != null) _game.map.updateTiles(widget.map.tiles);

      if (_game.decorations != null) {
        _game.decorations.forEach((d) => d.remove());
        _game.decorations.clear();
      }
      if (widget.decorations != null)
        widget.decorations.forEach((d) => _game.addDecoration(d));

      if (_game.enemies != null) {
        _game.enemies.forEach((e) => e.remove());
        _game.enemies.clear();
      }

      if (widget.enemies != null)
        widget.enemies.forEach((e) => _game.addEnemy(e));
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _game = RPGGame(
      context: context,
      vsync: this,
      joystickController: widget.joystick,
      player: widget.player,
      interface: widget.interface,
      map: widget.map,
      decorations: widget.decorations,
      enemies: widget.enemies,
      background: widget.background,
      constructionMode: widget.constructionMode,
      showCollisionArea: widget.showCollisionArea,
      gameController: widget.gameController,
      constructionModeColor:
          widget.constructionModeColor ?? Colors.cyan.withOpacity(0.5),
      collisionAreaColor:
          widget.collisionAreaColor ?? Colors.lightGreenAccent.withOpacity(0.5),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _game.onPointerDown,
      onPointerMove: _game.onPointerMove,
      onPointerUp: _game.onPointerUp,
      onPointerCancel: _game.onPointerCancel,
      child: _game.widget,
    );
  }
}
