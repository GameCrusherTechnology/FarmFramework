package service.command.crop
{
	import controller.GameController;
	
	import model.UpdateData;
	
	import service.command.AbstractCommand;
	import service.command.Command;

	public class UpdateFarmCommand extends AbstractCommand
	{
		public function UpdateFarmCommand(listdata:Vector.<UpdateData>,callBack:Function,errorCall:Function)
		{
			onSuccess =callBack;
			onError = errorCall;
			if(listdata.length==0) {
				onSuccess();
			}else{
				var data:UpdateData;
				var gameuid:String = listdata[0].gameuid;
				var type:int = listdata[0].type;
				var bool:Boolean = true;
				var sendList :Array = [];
				for each(data in listdata){
					if(data.gameuid != gameuid || data.type != type){
						bool = false;
						break;
					}else{
						trace("type" + type +" data_id: "+data.data['data_id']);
						sendList.push(data.data);
					}
				}
				if(bool){
					trace("send");
					super(Command.UPDATEFAME,onResult,{target_gameuid:gameuid,method:type,list:sendList});
				}else{
					onError();
				}
			}
		}
		private var onSuccess:Function;
		private var onError:Function;
		private function onResult(result:Object):void
		{
			if(Command.isSuccess(result)){
				onSuccess(result);
			}else{
				onError();
			}
		}
	}
}