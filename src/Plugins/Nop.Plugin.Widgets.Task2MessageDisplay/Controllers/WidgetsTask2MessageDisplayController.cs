using Microsoft.AspNetCore.Mvc;
using Nop.Core;
using Nop.Core.Caching;
using Nop.Plugin.Widgets.Task2MessageDisplay.Models;
using Nop.Services.Configuration;
using Nop.Services.Localization;
using Nop.Services.Security;
using Nop.Services.Stores;
using Nop.Web.Framework;
using Nop.Web.Framework.Controllers;

namespace Nop.Plugin.Widgets.Task2MessageDisplay.Controllers
{
    [Area(AreaNames.Admin)]
    public class WidgetsTask2MessageDisplayController : BasePluginController
    {
        private readonly IWorkContext _workContext;
        private readonly IStoreService _storeService;
        private readonly IPermissionService _permissionService;        
        private readonly ISettingService _settingService;
        private readonly ILocalizationService _localizationService;

        public WidgetsTask2MessageDisplayController(IWorkContext workContext,
            IStoreService storeService,
            IPermissionService permissionService,            
            ISettingService settingService,
            ICacheManager cacheManager,
            ILocalizationService localizationService)
        {
            this._workContext = workContext;
            this._storeService = storeService;
            this._permissionService = permissionService;            
            this._settingService = settingService;
            this._localizationService = localizationService;
        }
        public IActionResult Configure()
        {            
            var storeScope = this.GetActiveStoreScopeConfiguration(_storeService, _workContext);
            var task2MessageDisplaySettings = _settingService.LoadSetting<Task2MessageDisplaySettings>(storeScope);
            var model = new ConfigurationModel { MessageText= task2MessageDisplaySettings.MessageText, ActiveStoreScopeConfiguration = storeScope };
            return View("~/Plugins/Widgets.Task2MessageDisplay/Views/Configure.cshtml", model);
        }
        [HttpPost]
        public IActionResult Configure(ConfigurationModel model)
        {
            if (!_permissionService.Authorize(StandardPermissionProvider.ManageWidgets))
                return AccessDeniedView();
            
            var storeScope = this.GetActiveStoreScopeConfiguration(_storeService, _workContext);
            var task2MessageDisplaySettings = _settingService.LoadSetting<Task2MessageDisplaySettings>(storeScope);

            task2MessageDisplaySettings.MessageText = model.MessageText;


            _settingService.SaveSettingOverridablePerStore(task2MessageDisplaySettings, x => x.MessageText, model.MessageText_OverrideForStore, storeScope, false);
            _settingService.ClearCache();

            SuccessNotification(_localizationService.GetResource("Admin.Plugins.Saved"));
            return Configure();
        }
    }
}
