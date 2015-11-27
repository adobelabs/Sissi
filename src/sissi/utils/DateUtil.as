package sissi.utils
{
	public class DateUtil
	{
		public function DateUtil()
		{
			
		}
		
		/**
		 * 获得偏移的时间，以天数为参数
		 * @param value 时间
		 * @param amount 偏移的天数
		 * @return 偏移时间
		 */			 
		public static function incrementDate(value:Date, amount:int = 1):Date
		{
			var newDate:Date = new Date(value);
			var time:Number = newDate.getTime();
			//86400000 1Day millisecond
			newDate.setTime(time + amount * 86400000);
			return newDate;
		}
		
		/**
		 * 获得偏移的时间，以年和月作为参数
		 * @param oldYear 原来的年
		 * @param oldMonth 原来的月
		 * @param deltaYear 偏移的年
		 * @param deltaMonth 偏移的月
		 * @return 获得偏移的年月
		 */		
		public static function getNewIncrementDate(oldYear:int, oldMonth:int, deltaYear:int, deltaMonth:int):Object
		{
			var newYear:int = oldYear + deltaYear;
			var newMonth:int = oldMonth + deltaMonth;
			
			while (newMonth < 0)
			{
				newYear--;
				newMonth += 12;
			}
			
			while (newMonth > 11)
			{
				newYear++;
				newMonth -= 12;
			}
			
			return {year: newYear, month: newMonth};
		}
		
		/**
		 * 月的天数
		 * @param year 年
		 * @param month 月，注意month是0-11
		 * @return 月的天数
		 */		
		public static function getNumberOfDaysInMonth(year:int, month:int):int
		{
			// "Thirty days hath September..."
			var n:int;
			
			if (month == 1) // Feb
			{
				if (((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0)) // leap year
					n = 29;
				else
					n = 28;
			}
				
			else if (month == 3 || month == 5 || month == 8 || month == 10)
				n = 30;
				
			else
				n = 31;
			
			return n;
		}
	}
}