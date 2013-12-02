package controller
{
	import flash.utils.setTimeout;
	
	import model.UpdateData;
	
	import service.command.crop.UpdateFarmCommand;
	
	import starling.animation.Tween;
	

	public class UpdateController
	{
		private static var _controller:UpdateController;
		public static function get instance():UpdateController
		{
			if(!_controller){
				_controller = new UpdateController();
			}
			return _controller;
		}
		public function UpdateController()
		{
			
		}
		private var listData:Vector.<UpdateData> = new Vector.<UpdateData>; 
		public function pushActionData(data:UpdateData):void
		{
			if(listData.length>0){
				if(listData[0].gameuid == data.gameuid && listData[0].type == data.type){
					
				}else{
					sendUpdateList();
				}
			}
			listData.push(data);
			setTimeout(laterSend,500);
		}
		
		private function laterSend():void
		{
			sendUpdateList();
		}
		
		public function sendUpdateList():void{
			if(listData.length>0){
				new UpdateFarmCommand(listData,onsuccess,onerror);
			}
			listData = new Vector.<UpdateData>;
		}
		
		private function onsuccess(result:Object):void
		{
			
		}
		
		private function onerror():void
		{
			
		}
	}
}