using Nop.Web.Framework.Mvc.ModelBinding;
using Nop.Web.Framework.Mvc.Models;

namespace Nop.Plugin.Widgets.Task2MessageDisplay.Models
{
    public class ConfigurationModel : BaseNopModel
    {
        public int ActiveStoreScopeConfiguration { get; set; }
        [NopResourceDisplayName("Plugins.Widgets.Task2MessageDisplay.MessageText")]
        public string MessageText { get; set; }
        public bool MessageText_OverrideForStore { get; set; }
    }
}
