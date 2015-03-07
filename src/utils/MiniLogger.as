
package utils {
	
	import flash.external.ExternalInterface;
	
	public class MiniLogger {
		
		public static const me:MiniLogger = new MiniLogger(null);
		public var prefix:String;
		
		public function MiniLogger (prefix:String) {
			this.prefix = prefix;
		}
		
		public function lg (text:String):void {
			if (prefix) {
				text = prefix + ' ' + text;
			}
			trace(text);
			if (ExternalInterface.available) {
				ExternalInterface.call('console.log("[fl] ' + text.replace(/"/g, '\\"') + '")');
			}
		}
		
	}

}
