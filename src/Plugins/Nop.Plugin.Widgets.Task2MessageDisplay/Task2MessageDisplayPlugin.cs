using Nop.Core;
using Nop.Core.Plugins;
using Nop.Services.Cms;
using Nop.Services.Configuration;
using Nop.Services.Localization;
using System.Collections.Generic;

namespace Nop.Plugin.Widgets.Task2MessageDisplay
{
    public class Task2MessageDisplayPlugin : BasePlugin, IWidgetPlugin
    {
        private readonly ISettingService _settingService;
        private readonly IWebHelper _webHelper;

        public Task2MessageDisplayPlugin(ISettingService settingService, IWebHelper webHelper)
        {
            this._settingService = settingService;
            this._webHelper = webHelper;
        }
        public void GetPublicViewComponent(string widgetZone, out string viewComponentName)
        {
            viewComponentName = "Task2MessageDisplay";
        }

        public IList<string> GetWidgetZones()
        {
            return new List<string> { "productdetails_top" };
        }

        /// <summary>
        /// Gets a configuration page URL
        /// </summary>
        public override string GetConfigurationPageUrl()
        {
            return _webHelper.GetStoreLocation() + "Admin/WidgetsTask2MessageDisplay/Configure";
        }
        /// <summary>
        /// Install plugin
        /// </summary>
        public override void Install()
        {
            string defaultMessage = "This is default message, please change the message from widgets configuration.";
            //settings
            var settings = new Task2MessageDisplaySettings
            {
                MessageText = defaultMessage
            };
            _settingService.SaveSetting(settings);


            this.AddOrUpdatePluginLocaleResource("Plugins.Widgets.Task2MessageDisplay.MessageText", "Message");
            
            base.Install();
        }

        /// <summary>
        /// Uninstall plugin
        /// </summary>
        public override void Uninstall()
        {
            //settings
            _settingService.DeleteSetting<Task2MessageDisplaySettings>();

            //locales
            this.DeletePluginLocaleResource("Plugins.Widgets.Task2MessageDisplay.MessageText");

            base.Uninstall();
        }
    }
}
