
package view.ui {
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class UIButton extends Sprite {
		
		private const MARGIN:int = 10;
		
		public function UIButton (label:String) {
			
			var l:UILabel = new UILabel(label, null, 0, null, 16, 0xFFFFFF);
			l.x = MARGIN;
			l.y = MARGIN;
			addChild(l);
			
			graphics.beginFill(0x000000, 0.5);
			graphics.drawRect(0, 0, l.width + (MARGIN<<1), l.height + (MARGIN<<1));
			graphics.endFill();
			
			buttonMode = true;
			
		}
		
	}

}
