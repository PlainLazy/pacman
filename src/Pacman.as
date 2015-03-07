
package {
	
	import controller.MainControl;
	import flash.display.Sprite;
	import flash.events.Event;
	import utils.MiniLogger;
	
	[SWF(backgroundColor="#888888")]
	public class Pacman extends Sprite {
		
		private var main_con:MainControl;
		
		public function Pacman () {
			CONFIG::debug { MiniLogger.me.lg('Pacman.init'); }
			if (stage) {
				addedToStageHr(null);
				return;
			}
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHr);
		}
		
		private function addedToStageHr (e:Event):void {
			CONFIG::debug { MiniLogger.me.lg('Pacman.addedToStageHr'); }
			main_con = new MainControl();
			main_con.go(this);
		}
		
	}

}
