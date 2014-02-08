package controller
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import gameconfig.Configrations;
	import gameconfig.SystemDate;
	
	import model.MessageData;
	import model.UpdateData;
	import model.player.GamePlayer;
	
	import service.command.crop.UpdateFarmCommand;
	import service.command.user.UpdateMessagesCommand;
	

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
		private var timer:Timer;
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
			if(!timer){
				timer = new Timer(5000);
				timer.addEventListener(TimerEvent.TIMER,update,false,0,true);
				timer.start();
			}
			listData.push(data);
		}
		
		private function laterSend():void
		{
			sendUpdateList();
		}
		
		public function update(e:TimerEvent):void
		{
			laterSend();
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
			GameController.instance.start();
		}
		
		//MES
		public function checkMes():void
		{
			var player:GamePlayer = GameController.instance.currentPlayer;
			var mesData:MessageData;
			var mesArr:Array = [];
			var infoArr:Array =[];
			var delArr:Array = [];
			for each(mesData in player.user_mes_vec){
				if((SystemDate.systemTimeS - mesData.updatetime) > 5*3600*24){
					delArr.push(mesData);
					continue;
				}
				if(mesData.type == Configrations.MESSTYPE_MES){
					mesArr.push(mesData);
				}else{
					infoArr.push(mesData);
				}
			}
			mesArr.sortOn("updatetime",Array.NUMERIC);
			infoArr.sortOn("updatetime",Array.NUMERIC);
			if(mesArr.length> 20 ){
				delArr = delArr.concat(mesArr.splice(0,mesArr.length-20));
			}
			if(infoArr.length> 20 ){
				delArr = delArr.concat(infoArr.splice(0,infoArr.length-20));
			}
			
			if(delArr.length>0){
				new UpdateMessagesCommand([],delArr,function():void{
					for each(var data:MessageData in delArr){
						player.delMessage(data);
					}
				});
			}
		}
		
		
	}
}