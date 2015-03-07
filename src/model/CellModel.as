
package model {
	
	import alternativa.engine3d.primitives.GeoSphere;
	
	public class CellModel {
		
		public var x:uint;
		public var y:uint;
		public var k:uint;
		public var isWall:Boolean;
		public var isDot:Boolean;
		public var dot:GeoSphere;
		
		public function CellModel (x:uint, y:uint, init_char:String) {
			this.x = x;
			this.y = y;
			k = calcKey(x, y);
			switch (init_char) {
				case null: case '0': { isWall = true; break; }
				case '*': { isDot  = true; break; }
				case ' ': { break; }
				default: { isWall = true; }
			}
		}
		
		public static function calcKey (x:uint, y:uint):uint {
			return (x << 16) + y;
		}
		
		CONFIG::debug
		public function toString ():String {
			return '{CellModel ' + x + ',' + y + '}';
		}
		
	}
	
}
