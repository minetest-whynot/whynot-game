Smart inventory can be enhanced using the API call

```
smart_sfinv_api.register_enhancement(enhancement_def)
```
enhancement_def is a lua table that contains the next values:

Methods:
 - make_formspec(enhancement_def, player, context, content, show_inv) - Allow to modify page formspec in context
 - get_nav_fs(enhancement_def, player, context, nav, current_idx) - Allow to modify shown tabs (in nav table) before sfinv creates tab header 
 - receive_fields(handler, player, context, fields) - Receive fields processing for new elements in enhancement

Method does set Attributes:
 - enh.formspec_size - Overrides the default size (size[8,9.1])
 - enh.formspec_size_add_w - Overssides the defaults size - additional with
 - enh.formspec_size_add_h - Overssides the defaults size - additional height
 - enh.theme_main - Theme - Additional formspec appended at begin of sfinv formspec

 - enh.formspec_before_navfs - Additional formspec string appended before get_nav_fs tab header
 - enh.custom_nav_fs - Custom formspec replaces the get_nav_fs tab header
 - enh.formspec_after_navfs - Additional formspec string appended after get_nav_fs tab header and before content
 - enh.formspec_after_content - Additional formspec string appended after content
 - enh.theme_inv  - Additional formspec string appended before player inventory is shown
})
