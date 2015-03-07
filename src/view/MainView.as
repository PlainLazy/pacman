
package view {
	
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Debug;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.core.View;
	import alternativa.engine3d.lights.AmbientLight;
	import alternativa.engine3d.lights.DirectionalLight;
	import alternativa.engine3d.materials.StandardMaterial;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.primitives.Box;
	import alternativa.engine3d.primitives.GeoSphere;
	import alternativa.engine3d.primitives.Plane;
	import alternativa.engine3d.resources.BitmapTextureResource;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import model.CellModel;
	import model.MapModel;
	import utils.MiniLogger;
	import view.ui.UIDialog;
	
	public class MainView extends Sprite {
		
		[Embed(source="../../assets/textures/wall.jpg")] private static const EmbedWall:Class;
		
		CONFIG::debug private var lg:Function = new MiniLogger('MainView').lg;
		
		public static const EV_READY:String = 'READY';
		
		private const CELL_SIZE:int = 20;
		private const PLAYER_DISTANCE:int = 200;
		
		private var camera:Camera3D;
		private var stage3D:Stage3D;
		private var dialog:UIDialog;
		
		public var container:Object3D;
		public var player:MovableObject;
		
		public function MainView () { }
		
		public function go (scene:Sprite):void {
			CONFIG::debug { lg('go') }
			
			scene.addChild(this);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.quality = StageQuality.BEST;
			
			CONFIG::debug { lg('stage3Ds list: ' + stage.stage3Ds.join(',')); }
			
			stage3D = stage.stage3Ds[0];
			stage3D.addEventListener(Event.CONTEXT3D_CREATE, content3dCreateHr);
			stage3D.requestContext3D();
			
			stage.addEventListener(Event.RESIZE, resizeHr);
			
		}
		
		private function planeCreate (map:MapModel):void {
			var w:int = CELL_SIZE * (map.max_x + 5);
			var h:int = CELL_SIZE * (map.max_y + 5);
			var plane:Plane = new Plane(w, h, 1, 1, false, false, null, makeStdPlainM(0x222222));
				plane.x = w/2 - CELL_SIZE*2;
				plane.y = h/2 - CELL_SIZE*2;
				plane.z = -CELL_SIZE / 2;
			container.addChild(plane);
		}
		
		public function gameOverDialogShow (text:String, restartHr:Function):void {
			dialog = new UIDialog(text);
			dialog.addAction('Рестарт', restartHr);
			dialog.done();
			addChild(dialog);
		}
		public function gameOverDialogHide ():void {
			removeChild(dialog);
			dialog = null;
		}
		
		public function clear ():void {
			player = null;
			while (container.numChildren > 0) {
				container.removeChildAt(0);
			}
		}
		
		public function playerCreate (x:uint, y:uint, map:MapModel):void {
			if (player != null) { return; }
			player = new MovableObject();
			player.cell_size = CELL_SIZE;
			player.map = map;
			player.inst = new GeoSphere(CELL_SIZE * 0.8 * 0.5, 4, false, makeStdPlainM(0xFFFF00));
			player.inst.x = x * CELL_SIZE + CELL_SIZE / 2;
			player.inst.y = y * CELL_SIZE + CELL_SIZE / 2;
			container.addChild(player.inst);
			player.cur_x = x;
			player.cur_y = y;
			player.dest_x = x;
			player.dest_y = y;
		}
		
		public function monsterCreate (x:uint, y:uint, type:String, speed:int, map:MapModel):Monster {
			var monster:Monster = new Monster();
			monster.type = type;
			monster.speed = speed;
			monster.cell_size = CELL_SIZE;
			monster.map = map;
			monster.inst = new Box(CELL_SIZE * 0.8, CELL_SIZE * 0.8, CELL_SIZE * 0.8);
			monster.inst.x = x * CELL_SIZE + CELL_SIZE / 2;
			monster.inst.y = y * CELL_SIZE + CELL_SIZE / 2;
			monster.inst.setMaterialToAllSurfaces(makeStdPlainM(0x990000));
			container.addChild(monster.inst);
			monster.cur_x = x;
			monster.cur_y = y;
			return monster;
		}
		
		public function createWorld (map:MapModel):void {
			CONFIG::debug { lg('createWorld'); }
			
			planeCreate(map);
			
			var mat:StandardMaterial = makeStdBdM(new EmbedWall());
				mat.glossiness = 0;
				mat.specularPower = 0;
			
			var cell:CellModel;
			var box:Box;
			
			var walls:Vector.<Mesh> = new Vector.<Mesh>();
			for (var x:uint = 0, xl:uint = map.max_x; x <= xl; x++) {
				for (var y:uint = 0, yl:uint = map.max_y; y <= yl; y++) {
					cell = map.cellGet(x, y);
					if (!cell) { continue; }
					if (cell.isWall) {
						box = new Box(CELL_SIZE, CELL_SIZE, 10);
						box.x = x * CELL_SIZE + CELL_SIZE / 2;
						box.y = y * CELL_SIZE + CELL_SIZE / 2;
						box.setMaterialToAllSurfaces(mat);
						container.addChild(box);
						walls.push(box);
					} else if (cell.isDot) {
						cell.dot = new GeoSphere(CELL_SIZE * 0.1, 4, false, makeStdPlainM(0xFF9900));
						cell.dot.x = x * CELL_SIZE + CELL_SIZE / 2;
						cell.dot.y = y * CELL_SIZE + CELL_SIZE / 2;
						container.addChild(cell.dot);
					}
				}
			}
			
			var ambient:AmbientLight = new AmbientLight(0xFFFFFF);
				ambient.intensity = 0.5;
				container.addChild(ambient);
			
			var directional:DirectionalLight = new DirectionalLight(0xFFFF60);
				directional.rotationX = Math.PI * 1.2;
				container.addChild(directional);
			
			for each (var resource:Resource in container.getResources(true)) {
				//CONFIG::debug { lg('upload ' + resource); }
				resource.upload(stage3D.context3D);
			}
			
			container.addChild(camera);
			
		}
		
		private function content3dCreateHr (e:Event):void {
			CONFIG::debug { lg('content3dCreateHr ' + stage3D.context3D.driverInfo); }
			
			camera = new Camera3D(0.1, 10000);
			camera.view = new View(checkSize(stage.stageWidth), checkSize(stage.stageHeight), false, 0, 0, 4);
			addChild(camera.view);
			//camera.view.hideLogo();
			
			CONFIG::debug {
				if (0) {
					camera.debug = true;
					camera.addToDebug(Debug.BOUNDS, Object3D);
				}
				addChild(camera.diagram);
			}
			
			container = new Object3D();
			
			dispatchEvent(new Event(EV_READY));
			
		}
		
		private function resizeHr (e:Event):void {
			CONFIG::debug { lg('resizeHr'); }
			if (camera) {
				camera.view.width = checkSize(stage.stageWidth);
				camera.view.height = checkSize(stage.stageHeight);
			}
		}
		
		public function frameCamera ():void {
			var cx:Number = player.inst.x + Math.cos(-Math.PI / 24) * PLAYER_DISTANCE;
			var cy:Number = player.inst.y + Math.sin(-Math.PI / 24) * PLAYER_DISTANCE;
			var cz:Number = player.inst.z + PLAYER_DISTANCE;
			camera.setPosition(cx, cy, cz);
			camera.lookAt(player.inst.x, player.inst.y, player.inst.z);
			camera.render(stage3D);
		}
		
		private function checkSize (val:int):int {
			//return Math.max(50, Math.min(2048, val));  // todo: software mode only
			return Math.max(50, val);
		}
		
		private function makeBTR (color:uint):BitmapTextureResource {
			return new BitmapTextureResource(new BitmapData(1, 1, false, color));
		}
		private function makeStdPlainM (color:int):StandardMaterial {
			return new StandardMaterial(makeBTR(color), makeBTR(0x7F7FFF));
		}
		private function makeStdBdM (b:Bitmap):StandardMaterial {
			return new StandardMaterial(new BitmapTextureResource(b.bitmapData), makeBTR(0x7F7FFF));
		}
		
		private function now ():Number {
			var d:Date = new Date();
			return d.getTime();
		}
		
	}

}
