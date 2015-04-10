/*
 * Copyright 2007-2015 the original author or authors.
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
package org.haxecommons.async.task.impl;
import org.haxecommons.async.task.ICountProvider;

/**
 * Base class for <code>ICountProvider</code> implementations.
 * @inheritDoc
 */
class CountProvider implements ICountProvider {

	/**
	 * Creates a new <code>CountProvider</code> instance.
	 * @param count The specified count.
	 */
	public function new(count:Int = 0) _count = count;
	
	var _count:Int;
	
	/**
	 * @inheritDoc
	 */
	public function getCount():Int return _count;
}