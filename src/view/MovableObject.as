
package view {
	
	import alternativa.engine3d.objects.Mesh;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import model.MapModel;
	import utils.MiniLogger;
	
	public class MovableObject extends EventDispatcher {
		
		public static const EV_MOVED:String = 'MOVED';
		public static const BASE_STEP_TIME:int = 300;
		
		CONFIG::debug protected var lg:Function = new MiniLogger('MovableObject').lg;
		
		public var cell_size:int;
		public var map:MapModel;
		public var inst:Mesh;
		
		public var cur_x:int;
		public var cur_y:int;
		public var direction_prev:int;
		public var direction_curr:int;
		
		public var dest_x:int;
		public var dest_y:int;
		private var p0:Point;
		private var p1:Point;
		public var move_dtime:Number = 300;
		private var move_stime:Number;
		
		public function MovableObject () { }
		
		public function frameHr ():void {
			moveStep();
		}
		
		public function moveStart (direction:int):void {
			var dx:int, dy:int;
			switch (direction) {
				case Keyboard.LEFT:  { dx =  0; dy = -1; break; }
				case Keyboard.RIGHT: { dx =  0; dy =  1; break; }
				case Keyboard.UP:    { dx = -1; dy =  0; break; }
				case Keyboard.DOWN:  { dx =  1; dy =  0; break; }
				default: { return; }
			}
			var tx:int = cur_x + dx;
			var ty:int = cur_y + dy;
			if (map.isWall(tx, ty)) { return; }
			dest_x = tx;
			dest_y = ty;
			direction_prev = direction_curr != 0 ? direction_curr : direction;
			direction_curr = direction;
			p0 = new Point(inst.x, inst.y);
			p1 = new Point(dest_x * cell_size + cell_size / 2, dest_y * cell_size + cell_size / 2);
			move_stime = now();
		}
		
		private function moveStep ():void {
			if (direction_curr == 0) { return; }
			var t:Number = now();
			var pc:Number = (t - move_stime) / move_dtime;
			if (pc >= 1) {
				//CONFIG::debug { lg(' moved from ' + cur_x + ',' + cur_y + ' to ' + dest_x + ',' + dest_y); }
				cur_x = dest_x;
				cur_y = dest_y;
				inst.x = p1.x;
				inst.y = p1.y;
				direction_curr = 0;
				dispatchEvent(new Event(EV_MOVED));
				return;
			} else {
				inst.x = p0.x + (p1.x - p0.x) * pc;
				inst.y = p0.y + (p1.y - p0.y) * pc;
			}
		}
		
		private function now ():Number {
			var d:Date = new Date();
			return d.getTime();
		}
		
	}
	
}
