/*
* Copyright (c) 2018 Bert Goens
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: Bert Goens <bertgoens@gmail.com>
*/

public class MainWindow : Gtk.Window {

    public MainWindow (Gtk.Application application) {
        Object (
            application: application,
            border_width: 0,
            icon_name: "com.github.bertgoens.cloudhop",
            height_request: 700,
            width_request: 500,
            title: "Cloudhop",
            window_position: Gtk.WindowPosition.CENTER
        );
    }

    construct {
        var header = make_headerbar ();
        set_titlebar (header);

        var body = make_body ();
        add (body);
    }

    private Gtk.HeaderBar make_headerbar () {
        var gtk_settings = Gtk.Settings.get_default ();

        // Create header elements
        // A switch between light & dark mode, from /Widgets/ModeSwitch
        var light_mode_switch = new ModeSwitch ("display-brightness-symbolic", "weather-clear-night-symbolic");
        light_mode_switch.primary_icon_tooltip_text = "Light background";
        light_mode_switch.secondary_icon_tooltip_text = "Dark background";
        light_mode_switch.valign = Gtk.Align.CENTER;
        light_mode_switch.bind_property ("active", gtk_settings, "gtk_application_prefer_dark_theme");
        // Breaks the application
        //Cloudhop.settings.bind ("prefer-dark-style", light_mode_switch, "active", GLib.SettingsBindFlags.DEFAULT);

        // Create the actual header, and add previous elements
        var header = new Gtk.HeaderBar ();
        header.show_close_button = true;
        header.pack_end (light_mode_switch);
        header.pack_end (new Gtk.Separator (Gtk.Orientation.VERTICAL));
        
        return header;
    }

    private Gtk.Box make_body () {
        var website_icon_label = new Gtk.Label ("Icon");
        var website_icon = new Gtk.Image.from_icon_name ("application-default-icon", Gtk.IconSize.DIALOG);
        
        var website_name = new Gtk.Label ("Title");
        var website_name_entry = new Gtk.Entry ();

        var website_url = new Gtk.Label ("Website");
        var website_url_entry = new Gtk.Entry ();

        var result = new Gtk.Label ("");

        var reset_input_image = new Gtk.Image.from_icon_name ("edit-clear", Gtk.IconSize.DIALOG);
        reset_input_image.margin_bottom = 12;
        var reset_input_event_box = new Gtk.EventBox ();
        reset_input_event_box.add (reset_input_image);
        reset_input_event_box.button_press_event.connect (() => {
            website_name_entry.set_text ("");
            website_url_entry.set_text ("");
            result.label = "";
            return true;
        });

        var load_website = new Gtk.Button.with_label ("Load");
        load_website.margin = 4;
        load_website.clicked.connect (() => {
            load_website.label = "Loading...";
            load_website.sensitive = false;
        });

        var create_desktop_link = new Gtk.Button.with_label ("Create desktop link");
        create_desktop_link.margin = 4;
        create_desktop_link.margin_top = 40;
        create_desktop_link.clicked.connect (() => {
            string strWebsiteLink = website_url_entry.get_text ();
            string strName = website_name_entry.get_text ();
 
            bool is_filled_in = true;
            if (strWebsiteLink.length == 0) {
                is_filled_in = false;
                result.label = "Paste in a website URL\n";
            }
            if (strName.length == 0) {
                is_filled_in = false;
                result.label += "Give the website a title\n";
            }

            if (is_filled_in) {
                result.label = strName + " created!";
            } else {
                result.label += "And try again.";
            }
        });

        var grid = new Gtk.Grid (); 
        grid.row_spacing = 3;
        grid.column_spacing = 10;

        // attach (element, left, top, width=1, height=1)
        grid.attach (website_url, 0, 0);
        grid.attach (website_url_entry, 1, 0);
        grid.attach (load_website, 2, 0);

        grid.attach (website_name, 0, 1);
        grid.attach (website_name_entry, 1, 1);

        grid.attach (website_icon_label, 0, 2);
        grid.attach (website_icon, 1, 2);

        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        box.margin = 10;
        box.add (reset_input_event_box);
        
        box.add (grid);

        box.add (create_desktop_link);
        box.add (result);
        return box;
    }

    public override bool configure_event (Gdk.EventConfigure event) {
        int root_x, root_y;
        get_position (out root_x, out root_y);
        Cloudhop.settings.set_int ("window-x", root_x);
        Cloudhop.settings.set_int ("window-y", root_y);

        return base.configure_event (event);
    }
}
