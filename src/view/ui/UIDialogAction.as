
package view.ui {
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import utils.MiniLogger;
	
	public class UIDialogAction extends Sprite {
		
		public var caption:String;
		
		public function UIDialogAction (caption:String, clickHandler:Function) {
			CONFIG::debug { MiniLogger.me.lg('UIDialogAction.init ' + caption + ' ' + clickHandler); }
			var b:UIButton = new UIButton(caption);
			b.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
			addChild(b);
		}
		
	}

}