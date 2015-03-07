
package view {
	
	import flash.events.Event;
	import flash.ui.Keyboard;
	import model.Config;
	import utils.MiniLogger;
	
	public class Monster extends MovableObject {
		
		private const POSSIBLE_DIRECTIONS:Array = [
			Keyboard.LEFT,
			Keyboard.RIGHT,
			Keyboard.UP,
			Keyboard.DOWN
		];
		
		private const TYPE_STUPID:String    = 'stupid';
		private const TYPE_LINEAR:String    = 'linear';
		private const TYPE_ASSASSIN:String  = 'assassin';
		
		public var type:String;
		public var speed:int;
		public var player:MovableObject;
		
		public function Monster () {
			CONFIG::debug { lg = new MiniLogger('Monster').lg; }
		}
		
		public function start ():void {
			//CONFIG::debug { lg('start'); }
			move_dtime = BASE_STEP_TIME * Config.me.getPlayerSpeed() / speed;
			addEventListener(MovableObject.EV_MOVED, movedHr, false, 0, true);
			movedHr(null);
		}
		
		private function randomStep ():void {
			var dirs:Array = POSSIBLE_DIRECTIONS.concat();
			while (true) {
				var rnd_index:int = int(dirs.length * Math.random());
				//CONFIG::debug { lg(' rnd_index=' + rnd_index); }
				moveStart(dirs[rnd_index]);
				if (direction_curr != 0 || dirs.length <= 1) {
					break;
				}
				dirs.splice(rnd_index, 1);
			}
		}
		
		private function randomTurnOrForward ():void {
			var rnd:Number = Math.random();
			if (rnd < 1/3) {  // lets go left
				switch (direction_prev) {
					case Keyboard.LEFT:  { moveStart(Keyboard.DOWN);  break; }
					case Keyboard.DOWN:  { moveStart(Keyboard.RIGHT); break; }
					case Keyboard.RIGHT: { moveStart(Keyboard.UP);    break; }
					case Keyboard.UP:    { moveStart(Keyboard.LEFT);  break; }
				}
			} else if (rnd < 2/3) {  // lets go right
				switch (direction_prev) {
					case Keyboard.LEFT:  { moveStart(Keyboard.UP);    break; }
					case Keyboard.UP:    { moveStart(Keyboard.RIGHT); break; }
					case Keyboard.RIGHT: { moveStart(Keyboard.DOWN);  break; }
					case Keyboard.DOWN:  { moveStart(Keyboard.LEFT);  break; }
				}
			}
			if (direction_curr == 0) { moveStart(direction_prev); }  // lets go forward
			if (direction_curr == 0) { randomStep(); }  // okay, random
		}
		
		private function playerMustDie ():void {
			map.searchWay(cur_x, cur_y, player.dest_x, player.dest_y);
			//CONFIG::debug { lg('map.founded_way=' + map.founded_way); }
			if (map.founded_way != null && map.founded_way.way.length > 1) {
				var dx:int = map.founded_way.way[1].x - cur_x;
				var dy:int = map.founded_way.way[1].y - cur_y;
				moveStart(dx < 0 ? Keyboard.UP : (dx > 0 ? Keyboard.DOWN : (dy < 0 ? Keyboard.LEFT : Keyboard.RIGHT)));
			}
		}
		
		private function movedHr (e:Event):void {
			//CONFIG::debug { lg('monster movedHr'); }
			switch (type) {
				case TYPE_STUPID:   { randomStep();          break; }
				case TYPE_LINEAR:   { randomTurnOrForward(); break; }
				case TYPE_ASSASSIN: { playerMustDie();       break; }
			}
		}
		
	}
	
}
