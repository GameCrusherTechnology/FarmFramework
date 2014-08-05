package service.command.friend
{
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class HelpFriendCommand extends AbstractCommand
	{
		public function HelpFriendCommand(friend_gameuid:String,speedArr:Array,dataid:int,callBack:Function)
		{
			onSuccess =callBack;
			super(Command.HELPFRIEND,onResult,{target:friend_gameuid,speed:speedArr,data_id:dataid});
		}
		private var onSuccess:Function;
		private function onResult(result:Object):void
		{
			if(Command.isSuccess(result)){
				onSuccess(result.dog);
			}else{
				
			}
		}
	}
}


