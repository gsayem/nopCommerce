﻿--upgrade scripts from nopCommerce 3.80 to next version

--new locale resources
declare @resources xml
--a resource will be deleted if its value is empty
set @resources='
<Language>
  <LocaleResource Name="Account.CustomerProductReviews.NoRecords">
    <Value>You haven''t written any reviews yet</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.CustomerUser.EnteringEmailTwice.Hint">
    <Value>Force entering email twice during registration.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.Vendor.MaximumProductNumber.Hint">
    <Value>Sets a maximum number of products per vendor.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Shipping.Methods.Description">
    <Value>Shipping methods used by offline shipping rate computation methods (e.g. "Fixed Rate Shipping" or "Shipping by weight").</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Catalog.Products.Fields.Price.Hint">
    <Value>The price of the product. You can manage currency by selecting Configuration > Currencies.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Customers.Customers.Fields.CustomerRoles.Hint">
    <Value>Choose customer roles of this user.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.Catalog.ExportImportProductAttributes.Hint">
    <Value>Check if products should be exported/imported with product attributes.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.Shipping.ShipToSameAddress.Hint">
    <Value>Check to display "ship to the same address" option during checkout ("billing address" step). In this case "shipping address" with appropriate options (e.g. pick up in store) will be skipped. Also note that all billing countries should support shipping ("Allow shipping" checkbox ticked).</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.System.ScheduleTasks.24days">
    <Value>Task period should not exceed 24 days.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Payment.MethodRestrictions">
    <Value>Payment restrictions</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Catalog.Products.Fields.Vendor.Hint">
    <Value>Choose a vendor associated with this product. This can be useful when running a multi-vendor store to keep track of goods associated with vendor.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Countries.ImportTip">
    <Value>You can download a CSV file with a list of states for other countries on the following page:</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Catalog.Products.Fields.ProductTags.Placeholder">
    <Value>Enter tags ...</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Catalog.Categories.Fields.Parent.None">
    <Value>[None]</Value>
  </LocaleResource>  
  <LocaleResource Name="Admin.Configuration.Settings.Shipping.HideShippingTotal">
    <Value>Hide shipping total if shipping not required</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.Shipping.HideShippingTotal.Hint">
    <Value>Check if you want Hide ''Shipping total'' label if shipping not required.</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Payments.PayPalDirect.Fields.ApiAccountName">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Payments.PayPalDirect.Fields.ApiAccountName.Hint">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Payments.PayPalDirect.Fields.ApiAccountPassword">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Payments.PayPalDirect.Fields.ApiAccountPassword.Hint">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Payments.PayPalDirect.Fields.Signature">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Payments.PayPalDirect.Fields.Signature.Hint">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Payments.PayPalDirect.Fields.ClientId">
    <Value>Client ID</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Payments.PayPalDirect.Fields.ClientId.Hint">
    <Value>Specify client ID.</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Payments.PayPalDirect.Fields.ClientSecret">
    <Value>Client secret</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Payments.PayPalDirect.Fields.ClientSecret.Hint">
    <Value>Specify secret key.</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Payments.PayPalDirect.Fields.WebhookId">
    <Value>Webhook ID</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Payments.PayPalDirect.Fields.WebhookId.Hint">
    <Value>Specify webhook ID.</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Payments.PayPalDirect.WebhookCreate">
    <Value>Get webhook ID</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Payments.PayPalDirect.WebhookError">
    <Value>Webhook was not created (see details in the log)</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.Tax.TaxCategories.None">
    <Value>[None]</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.Tax.DefaultTaxCategory">
    <Value>Default tax category</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.Tax.DefaultTaxCategory.Hint">
    <Value>Select default tax category for products.</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.AddNewAddressAttribute">
    <Value>Added a new address attribute (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.AddNewAddressAttributeValue">
    <Value>Added a new address attribute value (ID = {0})</Value>
  </LocaleResource>    
  <LocaleResource Name="ActivityLog.AddNewAffiliate">
    <Value>Added a new affiliate (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.AddNewBlogPost">
    <Value>Added a new blog post (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.AddNewCampaign">
    <Value>Added a new campaign (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.AddNewCountry">
    <Value>Added a new country (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.AddNewCurrency">
    <Value>Added a new currency (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.AddNewCustomerAttribute">
    <Value>Added a new customer attribute (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.AddNewCustomerAttributeValue">
    <Value>Added a new customer attribute value (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.AddNewEmailAccount">
    <Value>Added a new email account (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.AddNewLanguage">
    <Value>Added a new language (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.AddNewMeasureDimension">
    <Value>Added a new measure dimension (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.AddNewMeasureWeight">
    <Value>Added a new measure weight (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.AddNewNews">
    <Value>Added a new news (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.InstallNewPlugin">
    <Value>Installed a new plugin (FriendlyName: ''{0}'')</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.AddNewStateProvince">
    <Value>Added a new state province (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.AddNewStore">
    <Value>Added a new store (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.AddNewVendor">
    <Value>Added a new vendor (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.AddNewWarehouse">
    <Value>Added a new warehouse (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.DeleteAddressAttribute">
    <Value>Deleted an address attribute (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.DeleteAddressAttributeValue">
    <Value>Deleted an address attribute value (ID = {0})</Value>
  </LocaleResource>  
  <LocaleResource Name="ActivityLog.DeleteAffiliate">
    <Value>Deleted an affiliate (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.DeleteBlogPost">
    <Value>Deleted a blog post (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.DeleteBlogPostComment">
    <Value>Deleted a blog post comment (ID = {0})</Value>
  </LocaleResource>  
  <LocaleResource Name="ActivityLog.DeleteCampaign">
    <Value>Deleted a campaign (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.DeleteCountry">
    <Value>Deleted a country (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.DeleteCurrency">
    <Value>Deleted a currency (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.DeleteCustomerAttribute">
    <Value>Deleted a customer attribute (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.DeleteCustomerAttributeValue">
    <Value>Deleted a customer attribute value (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.DeleteEmailAccount">
    <Value>Deleted an email account (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.DeleteLanguage">
    <Value>Deleted a language (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.DeleteMeasureDimension">
    <Value>Deleted a measure dimension (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.DeleteMeasureWeight">
    <Value>Deleted a measure weight (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.DeleteMessageTemplate">
    <Value>Deleted a message template (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.DeleteNews">
    <Value>Deleted a news (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.DeleteNewsComment">
    <Value>Deleted a news comment (ID = {0})</Value>
  </LocaleResource>  
  <LocaleResource Name="ActivityLog.UninstallPlugin">
    <Value>Uninstalled a plugin (FriendlyName: ''{0}'')</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.DeleteProductReview">
    <Value>Deleted a product revie (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.DeleteStateProvince">
    <Value>Deleted a state or province (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.DeleteStore">
    <Value>Deleted a store (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.DeleteVendor">
    <Value>Deleted a vendor (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.DeleteWarehouse">
    <Value>Deleted a warehouse (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.EditAddressAttribute">
    <Value>Edited an address attribute (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.EditAddressAttributeValue">
    <Value>Edited an address attribute value (ID = {0})</Value>
  </LocaleResource>  
  <LocaleResource Name="ActivityLog.EditAffiliate">
    <Value>Edited an affiliate (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.EditBlogPost">
    <Value>Edited a blog post (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.EditCampaign">
    <Value>Edited a campaign (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.EditCountry">
    <Value>Edited a country (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.EditCurrency">
    <Value>Edited a currency (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.EditCustomerAttribute">
    <Value>Edited a customer attribute (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.EditCustomerAttributeValue">
    <Value>Edited a customer attribute value (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.EditEmailAccount">
    <Value>Edited an email account (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.EditLanguage">
    <Value>Edited a language (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.EditMeasureDimension">
    <Value>Edited a measure dimension (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.EditMeasureWeight">
    <Value>Edited a measure weight (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.EditMessageTemplate">
    <Value>Edited a message template (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.EditNews">
    <Value>Edited a news (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.EditPlugin">
    <Value>Edited a plugin (FriendlyName: ''{0}'')</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.EditProductReview">
    <Value>Edited a product revie (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.EditStateProvince">
    <Value>Edited a state or province (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.EditStore">
    <Value>Edited a store (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.EditTask">
    <Value>Edited a task (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.EditVendor">
    <Value>Edited a vendor (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="ActivityLog.EditWarehouse">
    <Value>Edited a warehouse (ID = {0})</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.Catalog.ProductReviewPossibleOnlyAfterPurchasing">
    <Value>Product review possible only after purchasing product</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.Catalog.ProductReviewPossibleOnlyAfterPurchasing.Hint">
    <Value>Check if product can be reviewed only by customer who have already ordered it.</Value>
  </LocaleResource>
  <LocaleResource Name="Reviews.ProductReviewPossibleOnlyAfterPurchasing">
    <Value>Product can be reviewed only after purchasing it</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.ExchangeRate.EcbExchange.SetCurrencyToEURO">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.ExchangeRate.EcbExchange.Error">
    <Value>You can use ECB (European central bank) exchange rate provider only when the primary exchange rate currency is supported by ECB</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.System.QueuedEmails.Fields.AttachedDownload">
    <Value>Attached static file</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.System.QueuedEmails.Fields.AttachedDownload.Hint">
    <Value>The attached static file that will be sent in this email.</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.CanadaPost.Fields.ContractId">
    <Value>Contract ID</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.CanadaPost.Fields.ContractId.Hint">
    <Value>Specify contract identifier.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.Catalog.ProductReviewPossibleOnlyAfterPurchasing">
    <Value>Product review possible only after product purchasing</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Catalog.Categories.Fields.PageSize.Positive">
    <Value>Page size should be positive.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Catalog.Manufacturers.Fields.PageSize.Positive">
    <Value>Page size should be positive.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Vendors.Fields.PageSize.Positive">
    <Value>Page size should be positive.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.ContentManagement.Blog.BlogPosts.Fields.Tags.Placeholder">
    <Value>Enter tags ...</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.Catalog.ShowProductSku">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.Catalog.ShowProductSku.Hint">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.Catalog.ShowSkuOnCatalogPages">
    <Value>Show SKU on catalog pages</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.Catalog.ShowSkuOnCatalogPages.Hint">
    <Value>Check to show product SKU on catalog pages in public store.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.Catalog.ShowSkuOnProductDetailsPage">
    <Value>Show SKU on product details page</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.Catalog.ShowSkuOnProductDetailsPage.Hint">
    <Value>Check to show product SKU on the product details page in public store.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Orders.Fields.CancelCC">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Orders.Fields.CancelOrderTotals">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Catalog.Products.ProductAttributes.Attributes.Values.Fields.CustomerEntersQty">
    <Value>Customer enters quantity</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Catalog.Products.ProductAttributes.Attributes.Values.Fields.CustomerEntersQty.Hint">
    <Value>Allow customers enter the quantity of associated product.</Value>
  </LocaleResource>
  <LocaleResource Name="ProductAttributes.Quantity">
    <Value> - quantity {0}</Value>
  </LocaleResource>
  <LocaleResource Name="Products.ProductAttributes.PriceAdjustment">
    <Value>{0} [{1}{2}]</Value>
  </LocaleResource>
  <LocaleResource Name="Products.ProductAttributes.PriceAdjustment.PerItem">
    <Value> per item</Value>
  </LocaleResource>
  <LocaleResource Name="Products.ProductAttributes.PriceAdjustment.Quantity">
    <Value>Enter quantity</Value>
  </LocaleResource>  
  <LocaleResource Name="Admin.Promotions.Campaigns.Fields.EmailAccount">
    <Value>Email account</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Promotions.Campaigns.Fields.EmailAccount.Hint">
    <Value>The email account that will be used to send this campaign.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Plugins.Fields.AclCustomerRoles">
    <Value>Limited to customer roles</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Plugins.Fields.AclCustomerRoles.Hint">
    <Value>Choose one or several customer roles i.e. administrators, vendors, guests, who will be able to use this plugin. If you don''t need this option just leave this field empty.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.RewardPoints.ActivatePointsImmediately">
    <Value>Activate points immediately</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.RewardPoints.ActivatePointsImmediately.Hint">
    <Value>Activates bonus points immediately after their calculation</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.RewardPoints.ActivationDelay">
    <Value>Reward points activation</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.RewardPoints.ActivationDelay.Hint">
    <Value>Specify how many days (hours) must elapse before earned points become active. Points earned by purchase cannot be redeemed until activated. For example, you may set the days before the points become available to 7. In this case, the points earned will be available for spending 7 days after the order gets chosen awarded status.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Customers.Customers.RewardPoints.ActivatedLater">
    <Value>The points will be activated on {0}</Value>
  </LocaleResource>
  <LocaleResource Name="Enums.Nop.Core.Domain.Customers.RewardPointsActivatingDelayPeriod.Days">
    <Value>Days</Value>
  </LocaleResource>
  <LocaleResource Name="Enums.Nop.Core.Domain.Customers.RewardPointsActivatingDelayPeriod.Hours">
    <Value>Hours</Value>
  </LocaleResource>
  <LocaleResource Name="RewardPoints.ActivatedLater">
    <Value>The points will be activated on {0}</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Currencies.PublishedCurrencyRequired">
    <Value>At least one published currency is required</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Customers.Customers.GuestsAndRegisteredRolesError">
    <Value>The customer cannot be in both ''Guests'' and ''Registered'' customer roles</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Customers.Customers.AddCustomerToGuestsOrRegisteredRoleError">
    <Value>Add the customer to ''Guests'' or ''Registered'' customer role</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Customers.Customers.ValidEmailRequiredRegisteredRole">
    <Value>Valid Email is required for customer to be in ''Registered'' role</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Customers.Customers.NonAdminNotImpersonateAsAdminError">
    <Value>A non-admin user cannot impersonate as an administrator</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Languages.PublishedLanguageRequired">
    <Value>At least one published language is required</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Orders.OrderItem.DeleteAssociatedGiftCardRecordError">
    <Value>This order item has an associated gift card record. Please delete it first</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.ReturnRequests.OrderItemDeleted">
    <Value>Order item is deleted</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.GeneralCommon.CaptchaAppropriateKeysNotEnteredError">
    <Value>Captcha is enabled but the appropriate keys are not entered</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.ContentManagement.MessageTemplates.Copied">
    <Value>The message template has been copied successfully</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Catalog.Products.Copied">
    <Value>The product has been copied successfully</Value>
  </LocaleResource>  
  <LocaleResource Name="Admin.System.Warnings.URL.Reserved">
    <Value>Entered page name already exists, so it will be replaced by ''{0}''</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Catalog.Products.Fields.DeliveryDate.Hint">
    <Value>Choose a delivery date which will be displayed in the public store. You can manage delivery dates by selecting Configuration > Shipping > Dates and ranges.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Catalog.Products.Fields.ProductAvailabilityRange">
    <Value>Product availability range</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Catalog.Products.Fields.ProductAvailabilityRange.Hint">
    <Value>Choose the product availability range that indicates when the product is expected to be available when out of stock (e.g. Available in 10-14 days). You can manage availability ranges by selecting Configuration > Shipping > Dates and ranges.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Catalog.Products.Fields.ProductAvailabilityRange.None">
    <Value>None</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.ProductEditor.ProductAvailabilityRange">
    <Value>Product availability range</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Shipping.DatesAndRanges">
    <Value>Dates and ranges</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Shipping.DeliveryDates.Hint">
    <Value>List of delivery dates which will be available for choice in product details.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Shipping.ProductAvailabilityRanges">
    <Value>Product availability ranges</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Shipping.ProductAvailabilityRanges.Added">
    <Value>The new product availability range has been added successfully.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Shipping.ProductAvailabilityRanges.AddNew">
    <Value>Add a new product availability range</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Shipping.ProductAvailabilityRanges.BackToList">
    <Value>back to product availability range list</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Shipping.ProductAvailabilityRanges.Deleted">
    <Value>The product availability range has been deleted successfully.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Shipping.ProductAvailabilityRanges.EditProductAvailabilityRangeDetails">
    <Value>Edit product availability range details</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Shipping.ProductAvailabilityRanges.Fields.DisplayOrder">
    <Value>Display order</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Shipping.ProductAvailabilityRanges.Fields.DisplayOrder.Hint">
    <Value>The display order of this product availability range. 1 represents the top of the list.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Shipping.ProductAvailabilityRanges.Fields.Name">
    <Value>Name</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Shipping.ProductAvailabilityRanges.Fields.Name.Hint">
    <Value>Enter product availability range name.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Shipping.ProductAvailabilityRanges.Fields.Name.Required">
    <Value>Please provide a name.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Shipping.ProductAvailabilityRanges.Hint">
    <Value>List of availability ranges which will be available for choice in product details.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Shipping.ProductAvailabilityRanges.Updated">
    <Value>The product availability range has been updated successfully.</Value>
  </LocaleResource>
  <LocaleResource Name="Products.Availability.AvailabilityRange">
    <Value>Available in {0}</Value>
  </LocaleResource>
  <LocaleResource Name="Products.Availability.BackorderingWithDate">
    <Value>Out of stock - on backorder and will be dispatched once in stock ({0}).</Value>
  </LocaleResource>
  <LocaleResource Name="ShoppingCart.AvailabilityRange">
    <Value>Available in {0}</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Payment.CheckMoneyOrder.PaymentMethodDescription">
    <Value>Pay by cheque or money order</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Payments.Manual.PaymentMethodDescription">
    <Value>Pay by credit / debit card</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Payments.PayPalDirect.PaymentMethodDescription">
    <Value>Pay by credit / debit card</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Payments.PayPalStandard.PaymentMethodDescription">
    <Value>You will be redirected to PayPal site to complete the payment</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Payment.PurchaseOrder.PaymentMethodDescription">
    <Value>Pay by purchase order (PO) number</Value>
  </LocaleResource>
  <LocaleResource Name="Account.AccountActivation.AlreadyActivated">
    <Value>Your account already has been activated</Value>
  </LocaleResource>
  <LocaleResource Name="Account.PasswordRecovery.PasswordAlreadyHasBeenChanged">
    <Value>Your password already has been changed. For changing it once more, you need to again recover the password.</Value>
  </LocaleResource>
  <LocaleResource Name="Newsletter.ResultAlreadyDeactivated">
    <Value>Your subscription already has been deactivated.</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.FixedRateShipping.Fields.ShippingMethodName">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.FixedRateShipping.Fields.Rate">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.ByWeight.Fields.Store">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.ByWeight.Fields.Store.Hint">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.ByWeight.Fields.Warehouse">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.ByWeight.Fields.Warehouse.Hint">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.ByWeight.Fields.Country">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.ByWeight.Fields.Country.Hint">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.ByWeight.Fields.StateProvince">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.ByWeight.Fields.StateProvince.Hint">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.ByWeight.Fields.Zip">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.ByWeight.Fields.Zip.Hint">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.ByWeight.Fields.ShippingMethod">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.ByWeight.Fields.ShippingMethod.Hint">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.ByWeight.Fields.From">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.ByWeight.Fields.From.Hint">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.ByWeight.Fields.To">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.ByWeight.Fields.To.Hint">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.ByWeight.Fields.AdditionalFixedCost">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.ByWeight.Fields.AdditionalFixedCost.Hint">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.ByWeight.Fields.LowerWeightLimit">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.ByWeight.Fields.LowerWeightLimit.Hint">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.ByWeight.Fields.PercentageRateOfSubtotal">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.ByWeight.Fields.PercentageRateOfSubtotal.Hint">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.ByWeight.Fields.RatePerWeightUnit">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.ByWeight.Fields.RatePerWeightUnit.Hint">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.ByWeight.Fields.LimitMethodsToCreated">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.ByWeight.Fields.LimitMethodsToCreated.Hint">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.ByWeight.Fields.DataHtml">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.ByWeight.AddRecord">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.ByWeight.Formula">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.ByWeight.Formula.Value">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.FixedOrByWeight.ShippingByWeight">
    <Value>By Weight</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.FixedOrByWeight.Fixed">
    <Value>Fixed Rate</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.FixedOrByWeight.Fields.Rate">
    <Value>Rate</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.FixedOrByWeight.Fields.Store">
    <Value>Store</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.FixedOrByWeight.Fields.Store.Hint">
    <Value>If an asterisk is selected, then this shipping rate will apply to all stores.</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.FixedOrByWeight.Fields.Warehouse">
    <Value>Warehouse</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.FixedOrByWeight.Fields.Warehouse.Hint">
    <Value>If an asterisk is selected, then this shipping rate will apply to all warehouses.</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.FixedOrByWeight.Fields.Country">
    <Value>Country</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.FixedOrByWeight.Fields.Country.Hint">
    <Value>If an asterisk is selected, then this shipping rate will apply to all customers, regardless of the country.</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.FixedOrByWeight.Fields.StateProvince">
    <Value>State / province</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.FixedOrByWeight.Fields.StateProvince.Hint">
    <Value>If an asterisk is selected, then this shipping rate will apply to all customers from the given country, regardless of the state.</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.FixedOrByWeight.Fields.Zip">
    <Value>Zip</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.FixedOrByWeight.Fields.Zip.Hint">
    <Value>Zip / postal code. If zip is empty, then this shipping rate will apply to all customers from the given country or state, regardless of the zip code.</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.FixedOrByWeight.Fields.ShippingMethod">
    <Value>Shipping method</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.FixedOrByWeight.Fields.From">
    <Value>Order weight from</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.FixedOrByWeight.Fields.From.Hint">
    <Value>Order weight from.</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.FixedOrByWeight.Fields.To">
    <Value>Order weight to</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.FixedOrByWeight.Fields.To.Hint">
    <Value>Order weight to.</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.FixedOrByWeight.Fields.AdditionalFixedCost">
    <Value>Additional fixed cost</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.FixedOrByWeight.Fields.AdditionalFixedCost.Hint">
    <Value>Specify an additional fixed cost per shopping cart for this option. Set to 0 if you don''t want an additional fixed cost to be applied.</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.FixedOrByWeight.Fields.LowerWeightLimit">
    <Value>Lower weight limit</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.FixedOrByWeight.Fields.LowerWeightLimit.Hint">
    <Value>Lower weight limit. This field can be used for \"per extra weight unit\" scenarios.</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.FixedOrByWeight.Fields.PercentageRateOfSubtotal">
    <Value>Charge percentage (of subtotal)</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.FixedOrByWeight.Fields.PercentageRateOfSubtotal.Hint">
    <Value>Charge percentage (of subtotal).</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.FixedOrByWeight.Fields.RatePerWeightUnit">
    <Value>Rate per weight unit</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.FixedOrByWeight.Fields.RatePerWeightUnit.Hint">
    <Value>Rate per weight unit.</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.FixedOrByWeight.Fields.LimitMethodsToCreated">
    <Value>Limit shipping methods to configured ones</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.FixedOrByWeight.Fields.LimitMethodsToCreated.Hint">
    <Value>If you check this option, then your customers will be limited to shipping options configured here. Otherwise, they''ll be able to choose any existing shipping options even they''ve not configured here (zero shipping fee in this case).</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.FixedOrByWeight.Fields.DataHtml">
    <Value>Data</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.FixedOrByWeight.AddRecord">
    <Value>Add record</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.FixedOrByWeight.Formula">
    <Value>Formula to calculate rates</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.FixedOrByWeight.Formula.Value">
    <Value>[additional fixed cost] + ([order total weight] - [lower weight limit]) * [rate per weight unit] + [order subtotal] * [charge percentage]</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.Vendor.AllowVendorsToImportProducts">
    <Value>Allow vendors to import products</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.Vendor.AllowVendorsToImportProducts.Hint">
    <Value>Check if vendors are allowed to import products.</Value>
  </LocaleResource>
  <LocaleResource Name="ShoppingCart.ItemYouSave">
    <Value>You save: {0}</Value>
  </LocaleResource>
  <LocaleResource Name="ShoppingCart.MaximumDiscountedQty">
    <Value>Discounted qty: {0}</Value>
  </LocaleResource>
</Language>
'

CREATE TABLE #LocaleStringResourceTmp
	(
		[ResourceName] [nvarchar](200) NOT NULL,
		[ResourceValue] [nvarchar](max) NOT NULL
	)

INSERT INTO #LocaleStringResourceTmp (ResourceName, ResourceValue)
SELECT	nref.value('@Name', 'nvarchar(200)'), nref.value('Value[1]', 'nvarchar(MAX)')
FROM	@resources.nodes('//Language/LocaleResource') AS R(nref)

--do it for each existing language
DECLARE @ExistingLanguageID int
DECLARE cur_existinglanguage CURSOR FOR
SELECT [ID]
FROM [Language]
OPEN cur_existinglanguage
FETCH NEXT FROM cur_existinglanguage INTO @ExistingLanguageID
WHILE @@FETCH_STATUS = 0
BEGIN
	DECLARE @ResourceName nvarchar(200)
	DECLARE @ResourceValue nvarchar(MAX)
	DECLARE cur_localeresource CURSOR FOR
	SELECT ResourceName, ResourceValue
	FROM #LocaleStringResourceTmp
	OPEN cur_localeresource
	FETCH NEXT FROM cur_localeresource INTO @ResourceName, @ResourceValue
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (EXISTS (SELECT 1 FROM [LocaleStringResource] WHERE LanguageID=@ExistingLanguageID AND ResourceName=@ResourceName))
		BEGIN
			UPDATE [LocaleStringResource]
			SET [ResourceValue]=@ResourceValue
			WHERE LanguageID=@ExistingLanguageID AND ResourceName=@ResourceName
		END
		ELSE 
		BEGIN
			INSERT INTO [LocaleStringResource]
			(
				[LanguageId],
				[ResourceName],
				[ResourceValue]
			)
			VALUES
			(
				@ExistingLanguageID,
				@ResourceName,
				@ResourceValue
			)
		END
		
		IF (@ResourceValue is null or @ResourceValue = '')
		BEGIN
			DELETE [LocaleStringResource]
			WHERE LanguageID=@ExistingLanguageID AND ResourceName=@ResourceName
		END
		
		FETCH NEXT FROM cur_localeresource INTO @ResourceName, @ResourceValue
	END
	CLOSE cur_localeresource
	DEALLOCATE cur_localeresource

	--fetch next language identifier
	FETCH NEXT FROM cur_existinglanguage INTO @ExistingLanguageID
END
CLOSE cur_existinglanguage
DEALLOCATE cur_existinglanguage

DROP TABLE #LocaleStringResourceTmp
GO

--new setting
IF NOT EXISTS (SELECT 1 FROM [Setting] WHERE [name] = N'shippingsettings.hideshippingtotal')
BEGIN
	INSERT [Setting] ([Name], [Value], [StoreId])
	VALUES (N'shippingsettings.hideshippingtotal', N'False', 0)
END
GO

--new setting
IF NOT EXISTS (SELECT 1 FROM [Setting] WHERE [name] = N'taxsettings.defaulttaxcategoryid')
BEGIN
	INSERT [Setting] ([Name], [Value], [StoreId])
	VALUES (N'taxsettings.defaulttaxcategoryid', N'0', 0)
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'AddNewAddressAttribute')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'AddNewAddressAttribute', N'Add a new address attribute', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'AddNewAffiliate')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'AddNewAffiliate', N'Add a new affiliate', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'AddNewBlogPost')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'AddNewBlogPost', N'Add a new blog post', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'AddNewCampaign')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'AddNewCampaign', N'Add a new campaign', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'AddNewCountry')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'AddNewCountry', N'Add a new country', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'AddNewCurrency')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'AddNewCurrency', N'Add a new currency', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'AddNewCustomerAttribute')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'AddNewCustomerAttribute', N'Add a new customer attribute', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'AddNewCustomerAttributeValue')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'AddNewCustomerAttributeValue', N'Add a new customer attribute value', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'AddNewEmailAccount')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'AddNewEmailAccount', N'Add a new email account', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'AddNewLanguage')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'AddNewLanguage', N'Add a new language', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'AddNewMeasureDimension')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'AddNewMeasureDimension', N'Add a new measure dimension', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'AddNewMeasureWeight')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'AddNewMeasureWeight', N'Add a new measure weight', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'AddNewNews')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'AddNewNews', N'Add a new news', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'InstallNewPlugin')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'InstallNewPlugin', N'Install a new plugin', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'AddNewStateProvince')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'AddNewStateProvince', N'Add a new state or province', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'AddNewStore')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'AddNewStore', N'Add a new store', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'AddNewVendor')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'AddNewVendor', N'Add a new vendor', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'AddNewWarehouse')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'AddNewWarehouse', N'Add a new warehouse', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'DeleteAddressAttribute')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'DeleteAddressAttribute', N'Delete an address attribute', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'DeleteAffiliate')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'DeleteAffiliate', N'Delete an affiliate', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'DeleteBlogPost')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'DeleteBlogPost', N'Delete a blog post', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'DeleteCampaign')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'DeleteCampaign', N'Delete a campaign', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'DeleteCountry')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'DeleteCountry', N'Delete a country', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'DeleteCurrency')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'DeleteCurrency', N'Delete a currency', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'DeleteCustomerAttribute')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'DeleteCustomerAttribute', N'Delete a customer attribute', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'DeleteCustomerAttributeValue')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'DeleteCustomerAttributeValue', N'Delete a customer attribute value', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'DeleteEmailAccount')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'DeleteEmailAccount', N'Delete an email account', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'DeleteLanguage')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'DeleteLanguage', N'Delete a language', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'DeleteMeasureDimension')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'DeleteMeasureDimension', N'Delete a measure dimension', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'DeleteMeasureWeight')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'DeleteMeasureWeight', N'Delete a measure weight', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'DeleteMessageTemplate')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'DeleteMessageTemplate', N'Delete a message template', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'DeleteNews')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'DeleteNews', N'Delete a news', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'UninstallPlugin')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'UninstallPlugin', N'Uninstall a plugin', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'DeleteProductReview')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'DeleteProductReview', N'Delete a product review', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'DeleteStateProvince')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'DeleteStateProvince', N'Delete a state or province', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'DeleteStore')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'DeleteStore', N'Delete a store', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'DeleteVendor')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'DeleteVendor', N'Delete a vendor', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'DeleteWarehouse')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'DeleteWarehouse', N'Delete a warehouse', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'EditAddressAttribute')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'EditAddressAttribute', N'Edit an address attribute', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'EditAffiliate')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'EditAffiliate', N'Edit an affiliate', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'EditBlogPost')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'EditBlogPost', N'Edit a blog post', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'EditCampaign')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'EditCampaign', N'Edit a campaign', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'EditCountry')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'EditCountry', N'Edit a country', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'EditCurrency')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'EditCurrency', N'Edit a currency', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'EditCustomerAttribute')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'EditCustomerAttribute', N'Edit a customer attribute', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'EditCustomerAttributeValue')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'EditCustomerAttributeValue', N'Edit a customer attribute value', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'EditEmailAccount')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'EditEmailAccount', N'Edit an email account', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'EditLanguage')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'EditLanguage', N'Edit a language', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'EditMeasureDimension')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'EditMeasureDimension', N'Edit a measure dimension', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'EditMeasureWeight')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'EditMeasureWeight', N'Edit a measure weight', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'EditMessageTemplate')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'EditMessageTemplate', N'Edit a message template', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'EditNews')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'EditNews', N'Edit a news', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'EditPlugin')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'EditPlugin', N'Edit a plugin', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'EditProductReview')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'EditProductReview', N'Edit a product review', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'EditStateProvince')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'EditStateProvince', N'Edit a state or province', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'EditStore')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'EditStore', N'Edit a store', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'EditTask')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'EditTask', N'Edit a task', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'EditVendor')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'EditVendor', N'Edit a vendor', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'EditWarehouse')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'EditWarehouse', N'Edit a warehouse', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'DeleteBlogPostComment')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'DeleteBlogPostComment', N'Delete a blog post comment', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'DeleteNewsComment')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'DeleteNewsComment', N'Delete a news comment', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'AddNewAddressAttributeValue')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'AddNewAddressAttributeValue', N'Add a new address attribute value', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'EditAddressAttributeValue')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'EditAddressAttributeValue', N'Edit an address attribute value', N'true')
END
GO

--new activity types
IF NOT EXISTS (SELECT 1 FROM [ActivityLogType] WHERE [SystemKeyword] = N'DeleteAddressAttributeValue')
BEGIN
	INSERT [ActivityLogType] ([SystemKeyword], [Name], [Enabled])
	VALUES (N'DeleteAddressAttributeValue', N'Delete an address attribute value', N'true')
END
GO

--new setting
IF NOT EXISTS (SELECT 1 FROM [Setting] WHERE [name] = N'catalogsettings.productreviewpossibleonlyafterpurchasing')
BEGIN
	INSERT [Setting] ([Name], [Value], [StoreId])
	VALUES (N'catalogsettings.productreviewpossibleonlyafterpurchasing', N'False', 0)
END
GO

 --new setting
 IF NOT EXISTS (SELECT 1 FROM [Setting] WHERE [name] = N'catalogsettings.exportimportusedropdownlistsforassociatedentities')
 BEGIN
 	INSERT [Setting] ([Name], [Value], [StoreId])
 	VALUES (N'catalogsettings.exportimportusedropdownlistsforassociatedentities', N'True', 0)
 END
 GO

 --new setting
IF NOT EXISTS (SELECT 1 FROM [Setting] WHERE [name] = N'catalogsettings.showskuoncatalogpages')
BEGIN
	INSERT [Setting] ([Name], [Value], [StoreId])
	VALUES (N'catalogsettings.showskuoncatalogpages', N'False', 0)
END
GO

--rename settings
UPDATE [Setting] 
SET [Name] = N'catalogsettings.showskuonproductdetailspage' 
WHERE [Name] = N'catalogsettings.showproductsku'
GO

--new column
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=object_id('[ProductAttributeValue]') and NAME='CustomerEntersQty')
BEGIN
	ALTER TABLE [ProductAttributeValue]
	ADD [CustomerEntersQty] bit NULL
END
GO

UPDATE [ProductAttributeValue]
SET [CustomerEntersQty] = 0
WHERE [CustomerEntersQty] IS NULL
GO

ALTER TABLE [ProductAttributeValue] ALTER COLUMN [CustomerEntersQty] bit NOT NULL
GO

--new or update setting
IF NOT EXISTS (SELECT 1 FROM [Setting] WHERE [name] = N'shoppingcartsettings.renderassociatedattributevaluequantity')
BEGIN
	INSERT [Setting] ([Name], [Value], [StoreId]) 
	VALUES (N'shoppingcartsettings.renderassociatedattributevaluequantity', N'True', 0);
END
ELSE
BEGIN
	UPDATE [Setting] 
	SET [Value] = N'True' 
	WHERE [Name] = N'shoppingcartsettings.renderassociatedattributevaluequantity'
END
GO

--update column
ALTER TABLE [RewardPointsHistory] ALTER COLUMN [PointsBalance] int NULL
GO

--new setting
IF NOT EXISTS (SELECT 1 FROM [Setting] WHERE [name] = N'rewardpointssettings.activationdelay')
BEGIN
	INSERT [Setting] ([Name], [Value], [StoreId])
	VALUES (N'rewardpointssettings.activationdelay', N'0', 0)
END
GO

--new setting
IF NOT EXISTS (SELECT 1 FROM [Setting] WHERE [name] = N'rewardpointssettings.activationdelayperiodid')
BEGIN
	INSERT [Setting] ([Name], [Value], [StoreId])
	VALUES (N'rewardpointssettings.activationdelayperiodid', N'0', 0)
END
GO


--new discount coupon code logic
DELETE FROM [GenericAttribute]
WHERE [KeyGroup] = 'Customer' and [Key] = 'DiscountCouponCode'
GO

--new table
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[ProductAvailabilityRange]') and OBJECTPROPERTY(object_id, N'IsUserTable') = 1)
BEGIN
	CREATE TABLE [dbo].[ProductAvailabilityRange](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[Name] nvarchar(400) NOT NULL,
		[DisplayOrder] int NOT NULL,
	PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
	)
END
GO

--add a new column
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=object_id('[Product]') and NAME='ProductAvailabilityRangeId')
BEGIN
	ALTER TABLE [Product]
	ADD [ProductAvailabilityRangeId] int NULL
END
GO

UPDATE [Product]
SET [ProductAvailabilityRangeId] = 0
WHERE [ProductAvailabilityRangeId] IS NULL
GO

ALTER TABLE [Product] ALTER COLUMN [ProductAvailabilityRangeId] int NOT NULL
GO

--new setting
IF NOT EXISTS (SELECT 1 FROM [Setting] WHERE [name] = N'paymentsettings.showpaymentmethoddescriptions')
BEGIN
	INSERT [Setting] ([Name], [Value], [StoreId])
	VALUES (N'paymentsettings.showpaymentmethoddescriptions', N'True', 0)
END
GO


--ensure that dbo is added to existing stored procedures
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[FullText_IsSupported]') AND OBJECTPROPERTY(object_id,N'IsProcedure') = 1)
DROP PROCEDURE [FullText_IsSupported]
GO
CREATE PROCEDURE [dbo].[FullText_IsSupported]
AS
BEGIN	
	EXEC('
	SELECT CASE SERVERPROPERTY(''IsFullTextInstalled'')
	WHEN 1 THEN 
		CASE DatabaseProperty (DB_NAME(DB_ID()), ''IsFulltextEnabled'')
		WHEN 1 THEN 1
		ELSE 0
		END
	ELSE 0
	END')
END
GO


IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[FullText_Enable]') AND OBJECTPROPERTY(object_id,N'IsProcedure') = 1)
DROP PROCEDURE [FullText_Enable]
GO
CREATE PROCEDURE [dbo].[FullText_Enable]
AS
BEGIN
	--create catalog
	EXEC('
	IF NOT EXISTS (SELECT 1 FROM sys.fulltext_catalogs WHERE [name] = ''nopCommerceFullTextCatalog'')
		CREATE FULLTEXT CATALOG [nopCommerceFullTextCatalog] AS DEFAULT')
	
	--create indexes
	DECLARE @create_index_text nvarchar(4000)
	SET @create_index_text = '
	IF NOT EXISTS (SELECT 1 FROM sys.fulltext_indexes WHERE object_id = object_id(''[Product]''))
		CREATE FULLTEXT INDEX ON [Product]([Name], [ShortDescription], [FullDescription])
		KEY INDEX [' + dbo.[nop_getprimarykey_indexname] ('Product') +  '] ON [nopCommerceFullTextCatalog] WITH CHANGE_TRACKING AUTO'
	EXEC(@create_index_text)
	
	SET @create_index_text = '
	IF NOT EXISTS (SELECT 1 FROM sys.fulltext_indexes WHERE object_id = object_id(''[LocalizedProperty]''))
		CREATE FULLTEXT INDEX ON [LocalizedProperty]([LocaleValue])
		KEY INDEX [' + dbo.[nop_getprimarykey_indexname] ('LocalizedProperty') +  '] ON [nopCommerceFullTextCatalog] WITH CHANGE_TRACKING AUTO'
	EXEC(@create_index_text)

	SET @create_index_text = '
	IF NOT EXISTS (SELECT 1 FROM sys.fulltext_indexes WHERE object_id = object_id(''[ProductTag]''))
		CREATE FULLTEXT INDEX ON [ProductTag]([Name])
		KEY INDEX [' + dbo.[nop_getprimarykey_indexname] ('ProductTag') +  '] ON [nopCommerceFullTextCatalog] WITH CHANGE_TRACKING AUTO'
	EXEC(@create_index_text)
END
GO



IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[FullText_Disable]') AND OBJECTPROPERTY(object_id,N'IsProcedure') = 1)
DROP PROCEDURE [FullText_Disable]
GO
CREATE PROCEDURE [dbo].[FullText_Disable]
AS
BEGIN
	EXEC('
	--drop indexes
	IF EXISTS (SELECT 1 FROM sys.fulltext_indexes WHERE object_id = object_id(''[Product]''))
		DROP FULLTEXT INDEX ON [Product]
	')

	EXEC('
	IF EXISTS (SELECT 1 FROM sys.fulltext_indexes WHERE object_id = object_id(''[LocalizedProperty]''))
		DROP FULLTEXT INDEX ON [LocalizedProperty]
	')

	EXEC('
	IF EXISTS (SELECT 1 FROM sys.fulltext_indexes WHERE object_id = object_id(''[ProductTag]''))
		DROP FULLTEXT INDEX ON [ProductTag]
	')

	--drop catalog
	EXEC('
	IF EXISTS (SELECT 1 FROM sys.fulltext_catalogs WHERE [name] = ''nopCommerceFullTextCatalog'')
		DROP FULLTEXT CATALOG [nopCommerceFullTextCatalog]
	')
END
GO




IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[LanguagePackImport]') AND OBJECTPROPERTY(object_id,N'IsProcedure') = 1)
DROP PROCEDURE [LanguagePackImport]
GO
CREATE PROCEDURE [dbo].[LanguagePackImport]
(
	@LanguageId int,
	@XmlPackage xml
)
AS
BEGIN
	IF EXISTS(SELECT * FROM [Language] WHERE [Id] = @LanguageId)
	BEGIN
		CREATE TABLE #LocaleStringResourceTmp
			(
				[LanguageId] [int] NOT NULL,
				[ResourceName] [nvarchar](200) NOT NULL,
				[ResourceValue] [nvarchar](MAX) NOT NULL
			)

		INSERT INTO #LocaleStringResourceTmp (LanguageID, ResourceName, ResourceValue)
		SELECT	@LanguageId, nref.value('@Name', 'nvarchar(200)'), nref.value('Value[1]', 'nvarchar(MAX)')
		FROM	@XmlPackage.nodes('//Language/LocaleResource') AS R(nref)

		DECLARE @ResourceName nvarchar(200)
		DECLARE @ResourceValue nvarchar(MAX)
		DECLARE cur_localeresource CURSOR FOR
		SELECT LanguageID, ResourceName, ResourceValue
		FROM #LocaleStringResourceTmp
		OPEN cur_localeresource
		FETCH NEXT FROM cur_localeresource INTO @LanguageId, @ResourceName, @ResourceValue
		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF (EXISTS (SELECT 1 FROM [LocaleStringResource] WHERE LanguageID=@LanguageId AND ResourceName=@ResourceName))
			BEGIN
				UPDATE [LocaleStringResource]
				SET [ResourceValue]=@ResourceValue
				WHERE LanguageID=@LanguageId AND ResourceName=@ResourceName
			END
			ELSE 
			BEGIN
				INSERT INTO [LocaleStringResource]
				(
					[LanguageId],
					[ResourceName],
					[ResourceValue]
				)
				VALUES
				(
					@LanguageId,
					@ResourceName,
					@ResourceValue
				)
			END
			
			
			FETCH NEXT FROM cur_localeresource INTO @LanguageId, @ResourceName, @ResourceValue
			END
		CLOSE cur_localeresource
		DEALLOCATE cur_localeresource

		DROP TABLE #LocaleStringResourceTmp
	END
END

 --new setting
IF NOT EXISTS (SELECT 1 FROM [Setting] WHERE [name] = N'fixedorbyweightsettings.shippingbyweightenabled')
BEGIN
	INSERT [Setting] ([Name], [Value], [StoreId])
	VALUES (N'fixedorbyweightsettings.shippingbyweightenabled', N'False', 0)
END
GO

--rename settings
UPDATE [Setting] 
SET [Name] = N'fixedorbyweightsettings.limitmethodstocreated' 
WHERE [Name] = N'shippingbyweightsettings.limitmethodstocreated'
GO

--rename settings
UPDATE [Setting] 
SET [Name] = N'shippingratecomputationmethod.fixedorbyweight.rate.shippingmethodid' + SUBSTRING(name, 62, len(name))
WHERE [Name] like N'shippingratecomputationmethod.fixedrate.rate.shippingmethodid%'
GO

 --new setting
 IF NOT EXISTS (SELECT 1 FROM [Setting] WHERE [name] = N'vendorsettings.allowvendorstoimportproducts')
 BEGIN
 	INSERT [Setting] ([Name], [Value], [StoreId])
 	VALUES (N'vendorsettings.allowvendorstoimportproducts', N'True', 0)
 END
 GO