
package view.ui {
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class UIDialog extends Sprite {
		
		private var wi:int;
		private var he:int = 20;
		private var actions:Vector.<UIDialogAction>;
		
		public function UIDialog (note:String, wi:int = 500) {
			if (wi < 100) { wi = 100; }
			this.wi = wi;
			var l:UILabel = new UILabel(note, 'center', wi-40, null, 16, 0xFFFFFF);
			l.x = (wi>>1) - (l.width>>1);
			l.y = he;
			addChild(l);
			he += l.height + 20;
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHr, false, 0, true);
		}
		
		public function addAction (caption:String, handler:Function):void {
			trace('addAction ' + caption);
			var action:UIDialogAction = new UIDialogAction(caption, handler);
			action.x = (wi>>1) - (action.width>>1);
			action.y = he;
			addChild(action);
			he += action.height + 20;
		}
		
		public function done ():void {
			graphics.beginFill(0x888888, 0.8);
			graphics.drawRect(0, 0, wi, he);
			graphics.endFill();
			resizeHr(null);
		}
		
		private function addedToStageHr (e:Event):void {
			stage.addEventListener(Event.RESIZE, resizeHr, false, 0, true);
			resizeHr(null);
		}
		
		private function resizeHr (e:Event):void {
			if (!stage) { return; }
			x = (stage.stageWidth >> 1) - (width >> 1);
			y = (stage.stageHeight >> 1) - (height >> 1);
		}
		
	}

}
