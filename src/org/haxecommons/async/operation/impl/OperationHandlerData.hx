/*
 * Copyright 2007-2011 the original author or authors.
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
package org.haxecommons.async.operation.impl;

/**
 * Internal data structure used by the <code>OperationHandler</code> class.
 * @author Roland Zwaga
 */
class OperationHandlerData {
	
	/**
	 * Creates a new <code>OperationHandlerData</code> instance.
	 * @param resultPropertyName
	 * @param resultTargetObject
	 * @param resultMethod
	 * @param errorMethod
	 */
	public function new(?resultPropertyName:String, ?resultTargetObject:Map<String, Dynamic>, ?resultMethod:Dynamic -> Dynamic, ?errorMethod:Dynamic -> Void) {
		initOperationHandler(resultPropertyName, resultTargetObject, resultMethod, errorMethod);
	}
	
	public var resultPropertyName(default, null):String;
	public var resultTargetObject(default, null):Map<String, Dynamic>;
	public var errorMethod(default, null):Dynamic -> Void;
	public var resultMethod(default, null):Dynamic -> Dynamic;

	function initOperationHandler(resultPropertyName:String, resultTargetObject:Map<String, Dynamic>, resultMethod:Dynamic -> Dynamic, errorMethod:Dynamic -> Void) {
		this.resultPropertyName = resultPropertyName;
		this.resultTargetObject = resultTargetObject;
		this.resultMethod = resultMethod;
		this.errorMethod = errorMethod;
	}
}