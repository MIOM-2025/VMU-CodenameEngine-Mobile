package funkin.options.categories;

import funkin.backend.utils.StorageUtil;

class MobileOptions extends TreeMenuScreen {
	public function new() {
		super('optionsTree.mobile-name', 'optionsTree.mobile-desc', 'MobileOptions.');

		add(new Checkbox(getNameID('invisibleHitbox'), getDescID('invisibleHitbox'), 'invisibleHitbox'));
		add(new NumOption(getNameID('hitboxOpacity'), getDescID('hitboxOpacity'), 0, 100, 5, 'hitboxOpacity'));
		// Arrow mode was removed: the mobile hitbox is always the four-lane layout.
		add(new Checkbox(getNameID('invisiblePauseButton'), getDescID('invisiblePauseButton'), 'invisiblePauseButton'));
		add(new TextOption(getNameID('storageInfo'), getDescID('storageInfo'), () -> {
			funkin.backend.system.modules.AntiCrash.showNotice('Storage', StorageUtil.getStorageInfo());
		}));
		add(new TextOption(getNameID('reextractAssets'), getDescID('reextractAssets'), () -> {
			StorageUtil.requestReextract();
			funkin.backend.system.modules.AntiCrash.showNotice('Assets will be extracted again', 'Restart the game to apply.');
		}));
		add(new TextOption(getNameID('resetModFiles'), getDescID('resetModFiles'), () -> {
			var count = funkin.backend.assets.ModGuard.getBlocked().length;
			funkin.backend.assets.ModGuard.clearBlocked();
			funkin.backend.system.modules.AntiCrash.showNotice('Re-enabled $count mod files', null);
		}));
	}
}
