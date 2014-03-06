package service.command.friend
{
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class FindFriendCommand extends AbstractCommand
	{
		public function FindFriendCommand(id:int,callBack:Function,error:Function)
		{
			onSuccess = callBack;
			onerror  = error;
			super(Command.GETUSERINFO,onResult,{friends:[id]});
		}
		private var onSuccess:Function;
		private var onerror:Function;
		private function onResult(result:Object):void
		{
			if(Command.isSuccess(result)){
				if(result.friends){
					onSuccess(result.friends[0]);
				}else{
					onerror();
				}
			}else{
				onerror();
			}
		}
	}
}


