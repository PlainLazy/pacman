
package view.ui {
	
	import flash.display.Sprite;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;
	
	public class UILabel extends Sprite {
		
		private const MAX_WI:int = 1000000;
		
		public function UILabel (text:String, align:String = 'left', width:int = 0, face:String = null, size:int = 16, color:uint = 0, alpha:Number = 1) {
			
			if (!text) { text = ''; }
			
			switch (align) {
				case 'center': case 'right': case 'left': { break; }
				default: { align = 'left'; }
			}
			
			if (width <= 0 || width > MAX_WI) { width = MAX_WI; }
			
			if (!face || face == '') { face = 'Tahoma'; }
			
			var element:TextElement = new TextElement(
				text,
				new ElementFormat(
					new FontDescription(face),
					size,
					color,
					alpha
				)
			);
			
			var block:TextBlock = new TextBlock(element);
			
			var line:TextLine;
			var he:int;
			var lines:Vector.<TextLine> = new Vector.<TextLine>();
			var max_w:int;
			
			while (true) {
				line = block.createTextLine(line, width);
				if (!line) { break; }
				lines.push(line);
				if (he == 0) { he = line.height; }
				line.y = he;
				max_w = Math.max(max_w, line.width);
				he += line.height;
				addChild(line);
			}
			
			if (align != 'left') {
				for each (line in lines) {
					switch (align) {
						case 'center': { line.x = (max_w >> 1) - (line.width >> 1); break; }
						case 'right': { line.x = max_w - line.width; break; }
					}
				}
			}
			
		}
		
	}

}
