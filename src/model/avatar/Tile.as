package model.avatar{
	import view.entity.GameEntity;

    public class Tile{
		private var _gridX:int;
		private var _gridY:int;
        public function Tile(_arg1:int, _arg2:int){
            this._gridX = _arg1;
            this._gridY = _arg2;
        }
		public function get x():int
		{
			return _gridX;
		}
		public function get y():int
		{
			return _gridY;
		}
		public var owner:GameEntity;
		
	}
}