﻿package model.avatar{
	import view.entity.GameEntity;

    public class Tile{
		private var _gridX:int;
		private var _gridY:int;
        public function Tile(_arg1:int, _arg2:int,map:Map){
            this._gridX = _arg1;
            this._gridY = _arg2;
        }
		
		public var owner:GameEntity;
		
	}
}