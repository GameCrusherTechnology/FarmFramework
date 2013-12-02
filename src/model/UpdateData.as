package model
{
	public class UpdateData
	{
		public function UpdateData(_gameuid:String,_type:int,_data:Object)
		{
			gameuid = _gameuid;
			type = _type;
			data = _data;
		}
		
		public var gameuid:String;
		public var type:int;
		public var data:Object;
	}
}