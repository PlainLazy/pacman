
package model {
	
	import flash.external.ExternalInterface;
	import flash.utils.Dictionary;
	import utils.MiniLogger;
	
	public class MapModel {
		
		private var map:Dictionary = new Dictionary(true);
		public var max_x:uint;
		public var max_y:uint;
		public var founded_way:WayModel;
		
		public function MapModel () { }
		
		public function cellSet (cell:CellModel):void {
			if (map[cell.k] != null) { return; }
			map[cell.k] = cell;
			if (max_x < cell.x) { max_x = cell.x; }
			if (max_y < cell.y) { max_y = cell.y; }
		}
		
		public function cellGet (x:uint, y:uint):CellModel {
			return map[CellModel.calcKey(x, y)];
		}
		
		public function isWall (x:uint, y:uint):Boolean {
			var c:CellModel = cellGet(x, y);
			return c != null && c.isWall;
		}
		
		public function searchWay (x_from:uint, y_from:uint, x_to:uint, y_to:uint):void {
			//CONFIG::debug { MiniLogger.me.lg('MapModel.searchWay ' + x_from + ' ' + y_from + ' ' + x_to + ' ' + y_to); }
			
			founded_way = null;
			
			if (x_from == x_to && y_from == y_to) { return; }
			
			var start_cell:CellModel = cellGet(x_from, y_from);
			if (start_cell == null) { return; }
			
			var steps:Array = [[0,1],[0,-1],[1,0],[-1,0]];
			var steps_len:int = steps.length;
			
			var ways:Dictionary = new Dictionary(true);
			
			var start_way:WayModel = new WayModel();
			start_way.append(start_cell);
			ways[start_way] = start_way;
			
			var touched_cells:MapModel = new MapModel();
			
			var some_cell_touched:Boolean = true;
			while (some_cell_touched) {
				some_cell_touched = false;
				for each (var cw:WayModel in ways) {
					for (var r:int = 0; r < steps_len; r++) {
						var tx:int = cw.last_cell.x + steps[r][0];
						var ty:int = cw.last_cell.y + steps[r][1];
						if (tx < 0 || ty < 0) { continue; }  // out of bounds
						if (touched_cells.cellGet(tx, ty) != null) { continue; }  // cell already touched
						var tcell:CellModel = cellGet(tx, ty);
						if (tcell == null) { continue; }
						some_cell_touched = true;
						touched_cells.cellSet(tcell);
						if (tcell.isWall) { continue; }
						if (tcell.x == x_to && tcell.y == y_to) {
							cw.append(tcell);
							founded_way = cw;
							return;
						}
						var child_way:WayModel = new WayModel();
						child_way.way = cw.way.concat();
						child_way.append(tcell);
						ways[child_way] = child_way;
					}
					delete ways[cw];
				}
			}
			
		}
		
	}
	
}
