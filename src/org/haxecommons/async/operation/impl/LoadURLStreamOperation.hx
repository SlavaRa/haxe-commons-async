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
package org.haxecommons.async.operation.impl;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.events.ProgressEvent;
import openfl.events.SecurityErrorEvent;
import openfl.net.URLRequest;
import openfl.net.URLStream;

/**
 * An <code>IOperation</code> implementation that can load a stream from the specified URL.
 * @author Roland Zwaga
 */
class LoadURLStreamOperation {
	
	private static var TEXT_FIELD_NAME = 'text';
	
	/**
	 * Creates a new <code>LoadURLStreamOperation</code> instance.
	 * @param url The specified URL where the stream will be laoded from.
	 */
	public function new(url:String) {
		#if debug
		if(url == null || url.length == 0) throw "url argument must not be null or empty";
		#end
		
		super();
		
		init(url);
	}

	public var urlStream(default, null):URLStream;
	
	/**
	 * Initializes the current <code>LoadURLStreamOperation</code> with the specified URL.
	 * @param url The specified URL.
	 */
	function init(url:String) {
		_urlStream = new URLStream();
		_urlStream.addEventListener(Event.COMPLETE, urlStreamCompleteHandler, false, 0, true);
		_urlStream.addEventListener(ProgressEvent.PROGRESS, progressHandler, false, 0, true);
		_urlStream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, urlStreamErrorHandler, false, 0, true);
		_urlStream.addEventListener(IOErrorEvent.IO_ERROR, urlStreamErrorHandler, false, 0, true);
		
		setTimeout(load, 0, url);
	}
	
	
	function load(url:String) _urlStream.load(new URLRequest(url));

	function urlStreamCompleteHandler(event:Event) {
		removeEventListeners();
		dispatchCompleteEvent();
	}
	
	/**
	 * Handles the <code>ProgressEvent.PROGRESS</code> event of the internally created <code>URLStream</code>.
	 * @param event The specified <code>ProgressEvent.PROGRESS</code> event.
	 */
	function progressHandler(event:ProgressEvent) {
		progress = event.bytesLoaded;
		total = event.bytesTotal;
		dispatchProgressEvent();
	}
	
	/**
	 * Handles the <code>SecurityErrorEvent.SECURITY_ERROR</code> and <code>IOErrorEvent.IO_ERROR</code> events of the internally created <code>URLStream</code>.
	 * @param event The specified <code>ProgressEvent.PROGRESS</code> or <code>IOErrorEvent.IO_ERROR</code> event.
	 */
	function urlStreamErrorHandler(event:Event) {
		removeEventListeners();
		dispatchErrorEvent(event[TEXT_FIELD_NAME]);
	}
	
	/**
	 * Removes all the registered event handlers from the internally created <code>URLStream</code> and
	 * sets it to <code>null</code> afterwards.
	 */
	function removeEventListeners() {
		if (_urlStream == null) {
			return;
		}
		
		_urlStream.removeEventListener(Event.COMPLETE, completeHandler);
		_urlStream.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
		_urlStream.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
		_urlStream.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		_urlStream = null;
	}
}