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
package org.haxecommons.async.task;
import org.haxecommons.async.command.ICommand;
import org.haxecommons.async.operation.IOperation;

/**
 * Describes an object that is enable to execute a collection of <code>ICommands</code>, both
 * in sequence and in parallel, including simple flowcontrol logic such as if, else, while and for.
 * <p>This is a so-called 'fluent' interface allowing method calls to be 'chained', like this:</p>
 * <pre>
 * var task:ITask = new Task();
 * task.next(new Command1()).next(new Command2()).and(new Command3()).and(new Command4()).execute();
 * </pre>
 * <p>Because <code>ITask</code> itself is an extension of the <code>ICommand</code> interface it is
 * possible to nest task executions, like this:</p>
 * <pre>
 * var task1:ITask = new Task();
 * task1.next(new Command1()).next(new Command2()).and(new Command3()).and(new Command4());
 * var task2:ITask = new Task();
 * task2.next(task1).next(new Command5()).execute();
 * </pre>
 * <p>Note: An <code>ITask</code> can only be nested in one other execution chain. Do not re-use instances
 * among different <code>ITasks</code>.</p>
 * @author Roland Zwaga
 */
interface ITask extends ICommand extends IOperation {
	
	/**
	 * An anonymous object that can be used to store values that can be accessed by other client code
	 * to pass around these values between commands.
	 */
	var context(default, default):Dynamic;
	
	/**
	 * If the current <code>ITask</code> is part of the execution chain of another <code>ITask</code>,
	 * this property will have a reference to that instance.
	 * @return The <code>ITask</code> to whose execution chain the current <code>ITask</code> belongs.
	 */
	var parent(default, null):ITask;
	
	/**
	 * If <code>true</code> no more <code>ICommands</code> can be added to the current <code>ITask</code>.
	 */
	var isClosed(default, null):Bool;
	
	/**
	 * Adds an <code>ICommand</code> that will be executed in sequence.
	 * @param command The specified <code>ICommand</code>
	 * @return A reference to the current <code>ITask</code>
	 */
	function next(item:Dynamic, ?constructorArgs:Array<Dynamic>):ITask;
	
	/**
	 * Adds an <code>ICommand</code> that will be executed in parallel.
	 * @param command The specified <code>ICommand</code>
	 * @return A reference to the current <code>ITask</code>
	 */
	function and(item:Dynamic, ?constructorArgs:Array<Dynamic>):ITask;
	
	/**
	 * Adds a conditional execution block to the current <code>ITask</code> which will only
	 * be executed if the specified <code>IConditionProvider</code> return <code>true</code>.
	 * @param condition The specified <code>IConditionProvider</code>. This argument is ignored if the <code>ifElseBlock</code> argument is not null.
	 * @param ifElseBlock Optional <code>IIfElseBlock</code> instance, if this is <code>null</code> a new instance will be created.
	 * @return The new <code>IIfElseBlock</code> instance.
	 */
	function if_(?condition:IConditionProvider, ?ifElseBlock:IIfElseBlock):IIfElseBlock;
	
	/**
	 * Switches the current <code>IIfElseBlock</code> control flow to its else block.
	 * @return The current <code>IIfElseBlock</code> instance.
	 */
	function else_():IIfElseBlock;
	
	/**
	 * Adds a repeating execution block which will be executed until the specified <code>IConditionProvider</code> returns false.
	 * @param condition The specified <code>IConditionProvider</code>. This argument is ignored if the <code>whileBlock</code> argument is not null.
	 * @param whileBlock Optional <code>IWhileBlock</code> instance, if this is <code>null</code> a new instance will be created.
	 * @return The new <code>IWhileBlock</code> instance.
	 */
	function while_(?condition:IConditionProvider, ?whileBlock:IWhileBlock):IWhileBlock;
	
	/**
	 * Adds a repeating execution block which will be executed a specified number of times, determined by the specified <code>count</code> or <code>ICountProvider</code> parameters.
	 * @param count The specified <code>ICountProvider</code>. This argument is ignored if the <code>forBlock</code> argument is not null.
	 * @param forBlock Optional <code>IForBlock</code> instance, if this is <code>null</code> a new instance will be created.
	 * @return The new <code>IForBlock</code> instance.
	 */
	function for_(count:Int, ?countProvider:ICountProvider, ?forBlock:IForBlock):IForBlock;
	
	/**
	 * Stops the execution chain completely.
	 * @return The current <code>ITask</code>.
	 */
	function exit():ITask;
	
	/**
	 * Restarts the execution of the current <code>ITask</code>.
	 * @param doHardReset
	 * @return The current <code>ITask</code>.
	 */
	function reset(?doHardReset:Bool):ITask;
	
	/**
	 * Pauses the current <code>ITask</code> for the specified amount of milliseconds.
	 * @param duration The specified amount of milliseconds
	 * @param pauseCommand <code>ICommand</code> instance to be used as a pause command, if this parameter is not null the <code>duration</code> parameter is ignored.
	 * @return The current <code>ITask</code>.
	 */
	function pause(duration:Int, ?pauseCommand:ICommand):ITask;
	
	/**
	 * Closes the current <code>ITask</code> if its part of continuous block.
	 * @return The current <code>ITask</code>.
	 */
	function end():ITask;
	
	/**
	 * Interupts the current <code>ITask</code> if its part of a loop construct.
	 * @return The current <code>ITask</code>'s parent task;
	 */
	function break_():ITask;
	
	/**
	 * Continues the current <code>ITask</code> if its part of a loop construct.
	 * @return The current <code>ITask</code>'s parent task;
	 */
	function continue_():ITask;
}