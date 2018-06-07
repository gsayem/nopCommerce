using Microsoft.AspNetCore.Mvc;
using Nop.Core;
using Nop.Plugin.Widgets.Task2MessageDisplay.Models;
using Nop.Services.Configuration;
using Nop.Web.Framework.Components;

namespace Nop.Plugin.Widgets.Task2MessageDisplay.Components
{
    [ViewComponent(Name = "Task2MessageDisplay")]
    public class Task2MessageDisplayViewComponent : NopViewComponent
    {
        private readonly IStoreContext _storeContext;
        private readonly ISettingService _settingService;

        public Task2MessageDisplayViewComponent(IStoreContext storeContext,
            ISettingService settingService)
        {
            this._storeContext = storeContext;
            this._settingService = settingService;
        }

        public IViewComponentResult Invoke(string widgetZone, object additionalData)
        {
            var msgSettings = _settingService.LoadSetting<Task2MessageDisplaySettings>(_storeContext.CurrentStore.Id);

            var model = new ConfigurationModel { MessageText = msgSettings.MessageText };
            return View("~/Plugins/Widgets.Task2MessageDisplay/Views/PublicInfo.cshtml", model);
        }


    }
}
