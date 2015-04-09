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
import openfl.events.ErrorEvent;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.events.ProgressEvent;
import openfl.events.SecurityErrorEvent;
import openfl.net.URLLoader;
import openfl.net.URLLoaderDataFormat;
import openfl.net.URLRequest;

/**
 * An <code>IOperation</code> implementation that can load arbitrary data from a specified URL.
 * @author Roland Zwaga
 */
class LoadURLOperation extends AbstractProgressOperation {

	/**
	 * Creates a new <code>LoadURLOperation</code> instance.
	 * @param url The specified URL from which the data will be loaded.
	 * @param dataFormat Optional argument that specifies the data format of the expected data.
	 * Use the <code>openfl.net.URLLoaderDataFormat</code> enumeration for this.
	 * @see openfl.net.URLLoaderDataFormat
	 */
	public function new(url:String, ?dataFormat:String, ?request:URLRequest) {
		#if debug
		if(url == null || url.length == 0) throw "url argument must not be null or empty";
		#end
		
		super();
		
		if (dataFormat == null || dataFormat.length == 0) {
			dataFormat = URLLoaderDataFormat.TEXT;
		}
		
		createLoader(url, dataFormat, request);
	}

	public var url(default, null):String;
	
	/**
	 * Internal <code>URLLoader</code> instance that is used to do the actual loading of the data.
	 */
	var _urlLoader:URLLoader;

	public override function toString():String return "[LoadURLOperation(url:'" + url + "')]";
	
	/**
	 * @private
	 */
	function createLoader(url:String, dataFormat:String, request:URLRequest) {
		this.url = url;
		
		_urlLoader = new URLLoader();
		_urlLoader.dataFormat = dataFormat;
		_urlLoader.addEventListener(Event.COMPLETE, urlLoaderCompleteHandler);
		_urlLoader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, urlLoaderErrorHandler);
		_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, urlLoaderErrorHandler);
		
		var request = (request == null) ? new URLRequest(url) : request;
		_urlLoader.load(request);
	}

	/**
	 * Handles the <code>ProgressEvent.PROGRESS</code> event of the internally created <code>URLLoader</code>.
	 * @param event The specified <code>ProgressEvent.PROGRESS</code> event.
	 */
	function progressHandler(event:ProgressEvent) {
		progress = event.bytesLoaded;
		total = event.bytesTotal;
		dispatchProgressEvent();
	}
	
	/**
	 * Removes all the registered event handlers from the internally created <code>URLLoader</code> and
	 * sets it to <code>null</code> afterwards.
	 */
	function removeEventListeners() {
		if (_urlLoader == null) {
			return;
		}
		
		_urlLoader.removeEventListener(Event.COMPLETE, completeHandler);
		_urlLoader.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
		_urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
		_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		_urlLoader = null;
	}
	
	/**
	 * Handles the <code>Event.COMPLETE</code> event of the internally created <code>URLLoader</code>.
	 * @param event The specified <code>Event.COMPLETE</code> event.
	 */
	function urlLoaderCompleteHandler(?event:Event) {
		result = _urlLoader.data;
		removeEventListeners();
		dispatchCompleteEvent();
	}
	
	/**
	 * Handles the <code>SecurityErrorEvent.SECURITY_ERROR</code> and <code>IOErrorEvent.IO_ERROR</code> events of the internally created <code>URLLoader</code>.
	 * @param event The specified <code>SecurityErrorEvent.SECURITY_ERROR</code> or <code>IOErrorEvent.IO_ERROR</code> event.
	 */
	function urlLoaderErrorHandler(event:ErrorEvent) {
		removeEventListeners();
		dispatchErrorEvent(event.text);
	}
}