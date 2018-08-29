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

public class Cloudhop : Gtk.Application { 
    // public static GLib.Settings settings;
    private MainWindow main_window;

    public Cloudhop () {
        Object (
            application_id: "com.github.bertgoens.cloudhop",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    static construct {

    }

    protected override void activate () {
        // Force focus existing window, if it exists
        if (get_windows ().length () > 0) {
            get_windows ().data.present ();
            return;
        }

        main_window = new MainWindow (this);
        // Optional: read and apply size from settings
        main_window.show_all ();

        var quit_action = new SimpleAction ("quit", null);

        add_action (quit_action);
        set_accels_for_action ("app.quit", {"Escape"});

        // Optional: Override CSS with custom Gtk CSS (Application.css)

        quit_action.activate.connect (() => {
            if (main_window != null) {
                main_window.destroy ();
            }
        });
    }

    public static int main (string[] args) {
        Gtk.init (ref args);

        var app = new Cloudhop ();
        return app.run (args);
    }
}
