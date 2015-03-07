
package controller {
	
	import controller.MainControl;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	import model.CellModel;
	import model.Config;
	import model.MapModel;
	import utils.MiniLogger;
	import view.MainView;
	import view.Monster;
	import view.MovableObject;
	import view.ui.UILabel;
	
	public class MainControl {
		
		CONFIG::debug private var lg:Function = new MiniLogger('MainControl').lg;
		
		private const CONFIG_URI:String = 'pacman.cnf';
		
		private var scene:Sprite;
		private var stage:Stage;
		private var main_view:MainView;
		
		private var map1:MapModel;
		private var is_started:Boolean;
		private var monsters:Vector.<Monster> = new Vector.<Monster>();
		private var cells_count:int;
		
		private var player_direction_strain_queue:Vector.<int> = new Vector.<int>();
		
		public function MainControl () { }
		
		public function go (scene:Sprite):void {
			CONFIG::debug { lg('go'); }
			
			this.scene = scene;
			stage = scene.stage;
			
			var ldr:URLLoader = new URLLoader();
			ldr.addEventListener(Event.COMPLETE, ldrCompleteHr);
			ldr.addEventListener(IOErrorEvent.IO_ERROR, ldrErrorHr);
			ldr.addEventListener(SecurityErrorEvent.SECURITY_ERROR, ldrErrorHr);
			ldr.load(new URLRequest(CONFIG_URI));
			
		}
		
		private function ldrCompleteHr (e:Event):void {
			CONFIG::debug { lg('ldrCompleteHr'); }
			try {
				Config.me.source = JSON.parse(e.target.data);
			} catch (e:Error) {
				initFailed('invalid config file format');
				return;
			}
			// todo: check some Config content
			main_view = new MainView();
			main_view.addEventListener(MainView.EV_READY, viewReadyHr);
			main_view.go(scene);
		}
		private function ldrErrorHr (e:Event):void {
			CONFIG::debug { lg('ldrErrorHr ' + e); }
			initFailed('"' + CONFIG_URI + '" loading failed');
		}
		
		private function initFailed (reason:String):void {
			var l:UILabel = new UILabel(reason, null, 0, null, 16, 0xCC0000);
			l.x = 10;
			l.y = 10;
			stage.addChild(l);
		}
		
		private function viewReadyHr (e:Event):void {
			CONFIG::debug { lg('viewReadyHr'); }
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHr);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHr);
			stage.addEventListener(Event.ENTER_FRAME, frameHr);
			
			start();
			
		}
		
		private function start ():void {
			CONFIG::debug { lg('start'); }
			
			map1 = new MapModel();
			
			var r:uint, rl:int;
			var c:uint, cl:int;
			var mark:String;
			var cell:CellModel;
			var rows:Array;
			var m:Monster;
			
			var player_mark:String = Config.me.getPlayerMark();
			var monsters_marks:Array = Config.me.getMonstersMarks();
			
			rows = Config.me.getMap() || [];
			for (r = 0, rl = rows.length; r < rl; r++) {
				for (c = 0, cl = rows[r].length; c < cl; c++) {
					mark = rows[r].charAt(c);
					if (mark == player_mark) {
						main_view.playerCreate(r, c, map1);
						main_view.player.addEventListener(MovableObject.EV_MOVED, playerMovedHr);
						player_direction_strain_queue = new Vector.<int>();
						mark = ' ';
					} else if (monsters_marks.indexOf(mark) != -1) {
						m = main_view.monsterCreate(
							r,
							c,
							Config.me.getMonsterType(mark),
							Config.me.getMonsterSpeed(mark),
							map1
						);
						monsters.push(m);
						mark = ' ';
					}
					cell = new CellModel(r, c, mark);
					if (cell.isDot) {
						cells_count++;
					}
					map1.cellSet(cell);
				}
			}
			
			main_view.createWorld(map1);
			
			for each (m in monsters) {
				m.player = main_view.player;
				m.start();
			}
			
			is_started = true;
			
		}
		
		private function playerControlCheck ():void {
			if (!main_view.player || main_view.player.direction_curr != 0) { return; }
			var ds:int = get_current_player_direction_strain();
			if (ds != 0) {
				main_view.player.moveStart(ds);
			}
		}
		
		private function playerMovedHr (e:Event):void {
			//CONFIG::debug { lg('playerMovedHr'); }
			var cell:CellModel = map1.cellGet(main_view.player.cur_x, main_view.player.cur_y);
			if (cell && cell.dot) {
				main_view.container.removeChild(cell.dot);
				cell.dot = null;
				cell.isDot = false;
				cells_count--;
				if (cells_count == 0) {
					gameOver('Ура!\nВсе желтые точки съедены!\nНо принцесса в другм замке ;)');
				}
			}
		}
		
		private function gameOver (text:String):void {
			CONFIG::debug { lg('gameOver'); }
			is_started = false;
			main_view.gameOverDialogShow(text, restartHr);
		}
		
		private function restartHr (e:Object):void {
			trace('restartHr');
			main_view.gameOverDialogHide();
			main_view.clear();
			monsters = new Vector.<Monster>();
			start();
		}
		
		private function keyDownHr (e:KeyboardEvent):void {
			CONFIG::debug { lg('keyDownHr'); }
			if (!is_started) { return; }
			switch (e.keyCode) {
				case Keyboard.LEFT: case Keyboard.RIGHT: case Keyboard.UP: case Keyboard.DOWN: {
					remove_value_from_vector(player_direction_strain_queue, e.keyCode);
					player_direction_strain_queue.push(e.keyCode);
					playerControlCheck();
					break;
				}
			}
		}
		
		private function keyUpHr (e:KeyboardEvent):void {
			CONFIG::debug { lg('keyUpHr'); }
			switch (e.keyCode) {
				case Keyboard.LEFT: case Keyboard.RIGHT: case Keyboard.UP: case Keyboard.DOWN: {
					remove_value_from_vector(player_direction_strain_queue, e.keyCode);
					break;
				}
			}
		}
		
		private function remove_value_from_vector (source:Vector.<int>, value:int):void {
			var i:int = source.indexOf(value);
			if (i !== -1) { source.splice(i, 1); }
		}
		
		private function frameHr (e:Event):void {
			if (!is_started) { return; }
			playerControlCheck();
			if (main_view.player) {
				main_view.player.frameHr();
				main_view.frameCamera();
			}
			for each (var m:Monster in monsters) {
				m.frameHr();
				if (
					main_view.player
					&& Math.abs(m.inst.x - main_view.player.inst.x) < 10
					&& Math.abs(m.inst.y - main_view.player.inst.y) < 10
				) {
					gameOver('Игра окончена.\nВас сожрал мостр.\nВставьте в флоповод 10р для продожения ;)');
					return;
				}
			}
		}
		
		private function get_current_player_direction_strain ():int {
			return player_direction_strain_queue.length > 0 ? player_direction_strain_queue[player_direction_strain_queue.length - 1] : 0;
		}
		
	}

}
