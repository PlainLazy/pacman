
package model {
	
	import model.CellModel;
	
	public class WayModel {
		
		public var way:Vector.<CellModel> = new Vector.<CellModel>();
		public var last_cell:CellModel;
		
		public function WayModel () { }
		
		public function append (cell:CellModel):void {
			way.push(cell);
			last_cell = cell;
		}
		
		CONFIG::debug
		public function toString ():String {
			return '{WayStruct way=' + (way != null ? '(' + way.length + ')[' + way.join(',') + ']' : null) + ' last_cell=' + last_cell + '}';
		}
		
	}
	
}
