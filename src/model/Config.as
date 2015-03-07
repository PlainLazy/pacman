
package model {
	
	public class Config {
		
		public static const me:Config = new Config();
		
		public var source:Object;
		
		public function Config () { }
		
		public function getPlayerMark ():String {
			var r:Object = extract('player', 'mark');
			return r != null ? r as String : 'p';
		}
		public function getPlayerSpeed ():int {
			var r:Object = extract('player', 'speed');
			return r != null ? int(r) : 100;
		}
		
		public function getMonstersMarks ():Array {
			var marks:Array = [];
			var l:Object = extract('monsters') as Array;
			if (l) {
				for each (var m:Object in l) {
					if (m['mark'] != null) {
						marks.push(m['mark']);
					}
				}
			}
			return marks;
		}
		public function getMonsterObj (mark:String):Object {
			var l:Array = source['monsters'] as Array;
			if (l) {
				for each (var m:Object in l) {
					if (m['mark'] == mark) { return m; }
				}
			}
			return null;
		}
		public function getMonsterSpeed (mark:String):int {
			var o:Object = getMonsterObj(mark);
			return o && o['speed'] != null ? int(o['speed']) : getPlayerSpeed();
		}
		public function getMonsterType (mark:String):String {
			var o:Object = getMonsterObj(mark);
			return o ? o['type'] as String : null;
		}
		
		public function getMap ():Array {
			var r:Object = extract('map');
			return r != null ? r as Array : null;
		}
		
		public function extract (... path:Array):Object {
			if (!path) { return null; }
			var result:Object = source;
			while (result != null && path.length > 0) {
				result = result[path.shift()];
			}
			return result;
		}
		
	}

}
