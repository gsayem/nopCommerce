using Nop.Core;
using Nop.Core.Configuration;
using Nop.Core.Plugins;
using Nop.Services.Cms;
using Nop.Services.Configuration;
using System;
using System.Collections.Generic;

namespace Nop.Plugin.Widgets.Task2MessageDisplay
{
    public class Task2MessageDisplaySettings : ISettings
    {
        public string MessageText { get; set; }
    }
}
