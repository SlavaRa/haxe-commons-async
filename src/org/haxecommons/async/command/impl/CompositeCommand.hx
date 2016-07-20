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
package org.haxecommons.async.command.impl;
import haxe.Log;
import org.haxecommons.async.command.CompositeCommandKind;
import org.haxecommons.async.command.ICommand;
import org.haxecommons.async.command.ICompositeCommand;
import org.haxecommons.async.command.event.CommandEvent;
import org.haxecommons.async.command.event.CompositeCommandEvent;
import org.haxecommons.async.operation.IOperation;
import org.haxecommons.async.operation.event.OperationEvent;
import org.haxecommons.async.operation.impl.AbstractProgressOperation;

/**
 * Basic implementation of the <code>ICompositeCommand</code> that executes a list of <code>ICommand</code> instances
 * that were added through the <code>addCommand()</code> method. The commands are executed in the order in which
 * they were added.
 * @author Christophe Herreman
 * @author Roland Zwaga
 */
class CompositeCommand extends AbstractProgressOperation implements ICompositeCommand {
	
	/**
	 * Creates a new <code>CompositeCommand</code> instance.
	 * @default CompositeCommandKind.SEQUENCE
	 */
	public function new(?kind:CompositeCommandKind) {
		super();
		this.kind = kind != null ? kind : CompositeCommandKind.SEQUENCE;
		commands = [];
	}
	
	/**
	 * Determines if the execution of all the <code>ICommands</code> should be aborted if an
	 * <code>IAsyncCommand</code> instance dispatches an <code>AsyncCommandFaultEvent</code> event.
	 * @default false
	 * @see org.haxecommons.async.command.IAsyncCommand IAsyncCommand
	 */
	public var failOnFault:Bool;
	public function setFailOnFault(value:Bool):ICompositeCommand {
		failOnFault = value;
		return this;
	}
	
	public var commands(default, default):Array<ICommand>;
	public var kind(default, default):CompositeCommandKind;
	
	/**
	 * @inheritDoc
	 */
	public var numCommands(get, null):Int;
	inline function get_numCommands() return commands.length;
	
	/**
	 * The <code>ICommand</code> that is currently being executed.
	 */
	public var currentCommand(default, null):ICommand;

	/**
	 * @inheritDoc
	 */
	public function execute():Dynamic {
		if(commands != null) {
			if(kind == CompositeCommandKind.SEQUENCE) {
				#if debug
				Log.trace('Executing composite command $this in sequence.');
				#end
				executeNextCommand();
			} else if(kind == CompositeCommandKind.PARALLEL) {
				#if debug
				Log.trace('Executing composite command $this in parallel.');
				#end
				executeCommandsInParallel();
			}
		} else {
			#if debug
			Log.trace("No commands were added to this composite command. Dispatching complete event.");
			#end
			dispatchCompleteEvent();
		}
		return null;
	}

	/**
	 * @inheritDoc
	 */
	public function addCommand(command:ICommand):ICompositeCommand {
		#if debug
		if(command == null) throw "the command argument must not be null.";
		#end
		commands[commands.length] = command;
		total++;
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function addCommandAt(command:ICommand, index:Int):ICompositeCommand {
		if(index < commands.length) {
			commands.insert(index, command);
			total++;
			return this;
		}
		return addCommand(command);
	}

	/**
	 * @inheritDoc
	 */
	public function addOperation(operationClass:Class<Dynamic>, ?constructorArgs:Array<Dynamic>):ICompositeCommand {
		#if debug
		if(operationClass == null) throw "the operationClass argument must not be null.";
		#end
		return addCommand(GenericOperationCommand.createNew(operationClass, constructorArgs));
	}
	
	/**
	 * @inheritDoc
	 */
	public function addOperationAt(operationClass:Class<Dynamic>, index:Int, ?constructorArgs:Array<Dynamic>):ICompositeCommand {
		return addCommandAt(GenericOperationCommand.createNew(operationClass, constructorArgs), index);
	}

	/**
	 * If the specified <code>ICommand</code> implements the <code>IAsyncCommand</code> interface the <code>onCommandResult</code>
	 * and <code>onCommandFault</code> event handlers are added. Before the <code>ICommand.execute()</code> method is invoked
	 * the <code>CompositeCommandEvent.EXECUTE_COMMAND</code> event is dispatched.
	 * <p>When the <code>command</code> argument is <code>null</code> the <code>CompositeCommandEvent.COMPLETE</code> event is dispatched instead.</p>
	 * @see org.haxecommons.async.command.event.CommandEvent CompositeCommandEvent
	 */
	function executeCommand(command:ICommand) {
		#if debug
		if(command == null) throw "the command argument must not be null.";
		Log.trace("Executing command: " + command);
		#end
		currentCommand = command;
		addCommandListeners(cast(command, IOperation));
		dispatchEvent(new CommandEvent(CommandEvent.EXECUTE, command));
		dispatchBeforeCommandEvent(command);
		command.execute();
		if(!Std.is(command, IOperation)) {
			dispatchAfterCommandEvent(command);
		}
		if(Std.is(command, IOperation)) {
			#if debug
			Log.trace('Command $command is asynchronous. Waiting for response.');
			#end
		} else {
			progress++;
			dispatchProgressEvent();
			#if debug
			Log.trace('Command $command is synchronous and is executed. Trying to execute next command.');
			#end
			executeNextCommand();
		}
	}

	/**
	 * Retrieves and removes the next <code>ICommand</code> from the internal list and passes it to the
	 * <code>executeCommand()</code> method.
	 */
	function executeNextCommand() {
		var nextCommand = commands.shift();
		if(nextCommand != null) {
			#if debug
			Log.trace('Executing next command $nextCommand. Remaining number of commands: ${commands.length}.');
			#end
			executeCommand(nextCommand);
		} else {
			#if debug
			Log.trace('All commands in $this have been executed. Dispatching \"complete\" event.');
			#end
			dispatchCompleteEvent();
		}
	}
	
	function removeCommand(asyncCommand:IOperation) {
		#if debug
		if(asyncCommand == null) throw "the asyncCommand argument must not be null";
		#end
		if(commands == null || !Std.is(asyncCommand, ICommand)) return;
		commands.remove(cast(asyncCommand, ICommand));
		if(commands.length == 0) dispatchCompleteEvent();
	}

	function executeCommandsInParallel() {
		var containsOperations = false;
		for(command in commands) {
			if(Std.is(command, IOperation)) {
				containsOperations = true;
				addCommandListeners(cast(command, IOperation));
			}
			dispatchBeforeCommandEvent(command);
			command.execute();
			if(!Std.is(command, IOperation)) dispatchAfterCommandEvent(command);
		}
		if(!containsOperations) dispatchCompleteEvent();
	}

	/**
	 * Adds the <code>onCommandResult</code> and <code>onCommandFault</code> event handlers to the specified <code>IAsyncCommand</code> instance.
	 */
	function addCommandListeners(?asyncCommand:IOperation) {
		if(asyncCommand == null) return;
		asyncCommand.addCompleteListener(onCommandResult);
		asyncCommand.addErrorListener(onCommandFault);
	}
	
	/**
     * Removes the <code>onCommandResult</code> and <code>onCommandFault</code> event handlers from the specified <code>IAsyncCommand</code> instance.
     */
	function removeCommandListeners(?asyncCommand:IOperation) {
		if(asyncCommand == null) return;
		asyncCommand.removeCompleteListener(onCommandResult);
		asyncCommand.removeErrorListener(onCommandFault);
	}

	function onCommandResult(event:OperationEvent) {
		progress++;
		dispatchProgressEvent();
		#if debug
		Log.trace('Asynchronous command ${event.target} returned result. Executing next command.');
		#end
		removeCommandListeners(cast(event.target, IOperation));
		dispatchAfterCommandEvent(cast(event.target, ICommand));
		if(kind == CompositeCommandKind.SEQUENCE) executeNextCommand();
		else if(kind == CompositeCommandKind.PARALLEL) removeCommand(cast(event.target, IOperation));
	}

	function onCommandFault(event:OperationEvent) {
		#if debug
		Log.trace('Asynchronous command ${event.target} returned error.');
		#end
		dispatchErrorEvent(event.error);
		removeCommandListeners(cast event.target);
		if(kind == CompositeCommandKind.SEQUENCE) {
			if (failOnFault) {
				currentCommand = null;
			} else {
				executeNextCommand();
			}
		} else if(kind == CompositeCommandKind.PARALLEL) removeCommand(cast(event.target, IOperation));
	}

	function dispatchAfterCommandEvent(command:ICommand) {
		#if debug
		if(command == null) throw "the command argument must not be null";
		#end
		dispatchEvent(new CompositeCommandEvent(CompositeCommandEvent.AFTER_EXECUTE_COMMAND, command));
	}

	function dispatchBeforeCommandEvent(command:ICommand) {
		#if debug
		if(command == null) throw "the command argument must not be null";
		#end
		dispatchEvent(new CompositeCommandEvent(CompositeCommandEvent.BEFORE_EXECUTE_COMMAND, command));
	}
}