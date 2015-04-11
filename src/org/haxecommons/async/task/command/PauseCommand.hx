/*
* Copyright 2007 - 2015 the original author or authors.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*      http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
package org.haxecommons.async.task.command;
import openfl.events.TimerEvent;
import openfl.utils.Timer;
import org.haxecommons.async.command.ICommand;
import org.haxecommons.async.operation.impl.AbstractOperation;

/**
 * @author Roland
 */
class PauseCommand extends AbstractOperation implements ICommand {
	
	public function new(duration:Int) {
		super();
		_duration = duration;
	}
	
	var _duration:Int;

	public function execute():Dynamic {
		var timer = new Timer(_duration);
		timer.addEventListener(TimerEvent.TIMER, onTimerTimer);
		timer.start();
		return null;
	}

	function onTimerTimer(event:TimerEvent) {
		var timer = event.target;
		timer.removeEventListener(TimerEvent.TIMER, onTimerTimer);
		timer.stop();
		dispatchCompleteEvent(null);
	}
}