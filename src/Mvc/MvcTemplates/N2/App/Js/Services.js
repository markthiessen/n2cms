﻿(function (module) {
	module.factory('Interface', function ($resource) {
		var res = $resource('Api/Interface.ashx', {}, {});
		return res;
	});

	module.factory('FrameManipulatorFactory', function () {
		var frameManipulator = {
			click: function (selector) {
				console.log("click", selector);
				window.frames.preview.window.location = window.frames.preview.window.jQuery(selector, window.frames.preview.window.document).attr("href");
			},
			hideToolbar: function (force) {
				console.log("HIDE", window.frames.preview.window.jQuery("#toolbar .inner > .command, #toolbar .rightAligned > .command, #toolbar .inner > .commandOptions > .command, #toolbar .rightAligned > .commandOptions >.command").not(".primary-action, .cancel, .globalize").length);
				if (force || window.frames.preview.window.jQuery("#toolbar .inner > .command, #toolbar .rightAligned > .command, #toolbar .inner > .commandOptions > .command, #toolbar .rightAligned > .commandOptions >.command").not(".primary-action, .cancel, .globalize").length == 0)
					window.frames.preview.window.jQuery(".toolbar").hide();
			}
		};

		function manipulator(scope) {
			window.frameManipulator = this;

			this.scope = scope;

			scope.$on("$destroy", function () {
				delete window.frameManipulator;
			});
			return this;
		};
		manipulator.prototype = frameManipulator;

		return manipulator;
	});
	module.factory('FrameContext', function () {
		window.top.n2ctx = {
			refresh: function (ctx) {
				console.log("select", arguments);
			},
			select: function () {
				//console.log("select", arguments);
			},
			unselect: function(){
				//console.log("unselect", arguments);
			},
			update: function () {
				//console.log("update", arguments);
			},
			hasTop: function () {
				//console.log("hasTop", arguments);
				return true;
			}
		};
		return window.top.n2ctx;
	});

	module.factory('Content', function ($resource) {
		var res = $resource('Api/Content.ashx/:target', { target: '' }, {
			children: { method: 'GET', params: { target: 'children' } },
			search: { method: 'GET', params: { target: 'search' } },
			move: { method: 'POST', params: { target: 'move' } },
			sort: { method: 'POST', params: { target: 'sort' } }
		});

		res.loadChildren = function (node, callback) {callback
			if (!node)
				return;

			node.Loading = true;
			res.children({ selected: node.Current.Path }, function (data) {
				node.Children = data.Children;
				delete node.Loading;
				node.IsPaged = data.IsPaged;
				callback && callback(node);
			});
		};

		res.states = {
			None: 0,
			New: 1,
			Draft: 2,
			Waiting: 4,
			Published: 16,
			Unpublished: 32,
			Deleted: 64,
			All: 2 + 4 + 8 + 16 + 32 + 64,
			is: function (actual, expected) {
				return (actual & expected) == expected;
			}
		};
		
		return res;
	});

	module.factory('Translations', function ($resource) {
		var res = $resource('Api/Translations.ashx', {}, {});
		return res;
	});

	module.factory('Context', function ($resource) {
		var res = $resource('Api/Context.ashx', {}, {});

		return res;
	});

	module.factory('Versions', function ($resource) {
		var res = $resource('Api/Versions.ashx', {}, {});
		return res;
	});

	module.factory('Security', function ($resource) {
		var res = $resource('Api/Security.ashx', {}, {});
		res.permissions = {
			None: 0,
			Read: 1,
			Write: 2,
			Publish: 4,
			Administer: 8,
			ReadWrite: 3,
			ReadWritePublish: 7,
			Full: 13,
			is: function (actual, expected) {
				return actual <= expected;
			}
		};
		return res;
	});

	module.factory('Definitions', function ($resource) {
		var res = $resource('Api/Definitions.ashx', {}, {});
		return res;
	});

	module.factory('Notify', function () {
		var callbacks = [];
		var notify = {
			subscribe: function (callback) {
				callbacks.push(callback);
			},
			unsubscribe: function (callback) {
				callbacks.slice(callbacks.indexOf(callback), 1);
			},
			show: function (options) {
				angular.forEach(callbacks, function (cb) { cb(options); });
			}
		};
		return notify;
	});

	module.factory('ContextMenuFactory', function () {
		return function (scope) {
			var contextMenu = this;
			contextMenu.show = function (node) {
				scope.select(node);
				scope.ContextMenu.node = node;
				scope.ContextMenu.options = [];

				for (var i in scope.Interface.ContextMenu.Children) {
					var cm = scope.Interface.ContextMenu.Children[i];
					scope.ContextMenu.options.push(cm.Current);
				}

				console.log("showing", node.Current.Title, scope.ContextMenu);
			};
			contextMenu.hide = function () {
				console.log("hide", scope.ContextMenu.node);

				delete scope.ContextMenu.node;
				delete scope.ContextMenu.options;
				delete scope.ContextMenu.memory;
				delete scope.ContextMenu.action;
			};
			contextMenu.cut = function (node) {
				contextMenu.memory = node.Current;
				contextMenu.action = "cut";
				
			};
			contextMenu.copy = function (node) {
				contextMenu.memory = node.Current;
				contextMenu.action = "copy";
			};
		}
	});

	module.factory('SortHelperFactory', function (Content, Notify) {
		var context = {}
		return function (scope) {
			function reload(ctx) {
				var node = ctx.scopes.to && ctx.scopes.to.node;
				if (!node) return;

				node.HasChildren = true;
				node.Loading = true;
				Content.children({ selected: node.Current.Path }, function (data) {
					node.Children = data.Children;
					node.Expanded = true;
					node.Loading = false;
					if (data.IsPaged)
						node.IsPaged = true;
				});
			}
			this.move = function (ctx) {
				console.log("moving", ctx);
				Content.move(ctx.paths, function () {
					console.log("moved", ctx);

					reload(ctx);
					Notify.show({ message: "Successfully noved " + (ctx.scopes.selected && ctx.scopes.selected.node && ctx.scopes.selected.node.Current.Title), type: "success", timeout: 3000 });
				}, function () {
					Notify.show({ message: "Failed moving " + (ctx.scopes.selected && ctx.scopes.selected.node && ctx.scopes.selected.node.Current.Title), type: "error" });
				});
			};
			this.sort = function (ctx) {
				console.log("sorting", ctx);
				Content.sort(ctx.paths, function () {
					console.log("sorted", ctx);

					reload(ctx);
					Notify.show({ message: "Successfully sorted " + (ctx.scopes.selected && ctx.scopes.selected.node && ctx.scopes.selected.node.Current.Title), type: "success", timeout: 3000 });
				}, function () {
					Notify.show({ message: "Failed sorting " + (ctx.scopes.selected && ctx.scopes.selected.node && ctx.scopes.selected.node.Current.Title), type: "error" });
				});
			};

			return this;
		};
	});

})(angular.module('n2.services', ['ngResource']));