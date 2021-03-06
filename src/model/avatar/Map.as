package model.avatar
{
	import flash.geom.Point;
	
	import controller.GameController;
	
	import gameconfig.Configrations;
	
	import model.player.GamePlayer;
	
	import view.entity.GameEntity;

	public class Map
	{
		private var _gridWidth :int;
		private var _gridLength:int;
		private var startX:Number;
		private var startY:Number;
		protected var _tileGrid:Vector.<Vector.<Tile>>;
		protected var _tiles:Vector.<Tile>;
		
		private static var _map:Map;
		public static function get intance():Map
		{
			if(!_map){
				_map = new Map();
			}
			return _map;
		}
		public function Map()
		{
			
		}
		public function init(_startX:Number,_startY:Number):void
		{
			startX = _startX;
			startY = _startY;
			this._gridWidth = this._gridLength = player.wholeSceneLength;
			this.buildTileGrid();
		}
		
		//铺设方格
		private function buildTileGrid():void{
			var _local3:int;
			var _local4:int;
			var _local6:Tile;
			var _local1:int = (this._gridWidth * this._gridLength);
			this._tiles = new Vector.<Tile>(_local1);
			var _local2:Vector.<Vector.<Tile>> = new Vector.<Vector.<Tile>>(this._gridWidth);
			var _local5:int;
			_local3 = 0;
			while (_local3 < this._gridWidth) {
				_local2[_local3] = new Vector.<Tile>(this._gridLength);
				_local4 = 0;
				while (_local4 < this._gridLength) {
					if (((((this._tileGrid) && ((_local3 < this._tileGrid.length)))) && ((_local4 < this._tileGrid[_local3].length)))){
						_local6 = this._tileGrid[_local3][_local4];
					} else {
						_local6 = new Tile(_local3, _local4);
					};
					_local2[_local3][_local4] = _local6;
					this._tiles[_local5] = _local6;
					_local5++;
					_local4++;
				}
				_local3++;
			}
			this._tileGrid = _local2;
		}
		public function get tiles():Vector.<Tile>
		{
			return _tiles;
		}
		public function getEntity(sceneX:Number,sceneY:Number):GameEntity
		{
			
			return null;
		}
		public function getTileByIndex(index:Number):Tile
		{
			if(index<0 ||index>=_tiles.length){
				return null;
			}
			return _tiles[index];
		}
		public function getRandom():Tile
		{
			return _tiles[Math.floor(Math.random()*_tiles.length)];
		}
		public function getTileByIos(x:int,y:int):Tile
		{
			if(x < 0 || x>=_gridWidth ||y < 0 || y>=_gridLength ){
				return null;
			}
			return _tiles[x*_gridLength + y];
		}
		public function sceneToIso(sceneP:Point):Tile
		{
			var lengthx:int = Math.floor((sceneP.x -startX)/ Configrations.Tile_Width + (sceneP.y -startY) / Configrations.Tile_Height);
			var lengthy:int = Math.floor(-(sceneP.x -startX)/ Configrations.Tile_Width  + (sceneP.y-startY) / Configrations.Tile_Height);
			return getTileByIos(lengthx,lengthy);
		}
		
		public function sceneToCurIso(sceneP:Point):Tile
		{
			var lengthx:int = Math.floor((sceneP.x -startX)/ Configrations.Tile_Width + (sceneP.y -startY) / Configrations.Tile_Height);
			var lengthy:int = Math.floor(-(sceneP.x -startX)/ Configrations.Tile_Width  + (sceneP.y-startY) / Configrations.Tile_Height);
			return new Tile(lengthx,lengthy);
		}
		public function sceneToNearIso(sceneP:Point,boundx:int = 1,boundy:int=1):Tile
		{
			var lengthx:int = Math.floor((sceneP.x -startX)/ Configrations.Tile_Width + (sceneP.y -startY) / Configrations.Tile_Height);
			lengthx = Math.max(0,Math.min(lengthx,_gridWidth-boundx));
			var lengthy:int = Math.floor(-(sceneP.x -startX)/ Configrations.Tile_Width  + (sceneP.y-startY) / Configrations.Tile_Height);
			lengthy = Math.max(0,Math.min(lengthy,_gridLength-boundy));
			return getTileByIos(lengthx,lengthy);
		}
		
		public function iosToScene(iosx:Number,iosy:Number):Point
		{
			return new Point(startX +(iosx-iosy)*Configrations.Tile_Width/2,startY + (iosx+iosy)*Configrations.Tile_Height/2);
		}
		public function getBottomPoint():Point
		{
			return iosToScene(_gridWidth,_gridLength);
		}
		
		public function get rectPoints():Array
		{
			return [iosToScene(0,0),iosToScene(_gridWidth,0),iosToScene(_gridWidth,_gridLength),iosToScene(0,_gridLength)];
		}
		public function getRightPoint():Point
		{
			return iosToScene(_gridWidth-1,0);
		}
		
		private function get player():GamePlayer
		{
			return GameController.instance.currentPlayer;
		}
		
	}
}