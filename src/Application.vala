/*
 * Copyright 2021 Pong Loong Yeat (https://github.com/pongloongyeat/drive-daemon)
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation; either
 * version 3 of the License, or (at your option) any later version.
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
 */

public class DriveDaemon.Application : GLib.Application {
    private VolumeMonitor volume_monitor;

    public Application () {
        Object (
            application_id: "com.github.pongloongyeat.drive-daemon",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    public override void activate () {
        hold ();

        /* For some reason, DriveMonitor doesn't get us
        the information we want (number of volumes) but
        VolumeMonitor does so this is a workaround. */
        volume_monitor = VolumeMonitor.get ();

        var n_volumes = 0;

        this.volume_monitor.volume_added.connect ((volume) => {
            volume_added_callback (volume, ref n_volumes);
        });
    }

    private void volume_added_callback (Volume volume, ref int n_volumes) {
        var drive = volume.get_drive ();

        // Send notification only after all volumes are added
        n_volumes++;

        if (n_volumes == drive.get_volumes ().length ()) {
            var notification = new Notification (_("%s connected").printf (drive.get_name ()));

            /* Elementary's Notification server does not support
            changing the icon atm. */
            // notification.set_icon (drive.get_icon ());

            notification.set_body (_("With %u %s present").printf (n_volumes, ngettext ("volume", "volumes", n_volumes)));

            send_notification (application_id, notification);

            // Reset for next added device
            n_volumes = 0;
        }
    }

    public static int main (string[] args) {
        debug ("Activating Drive Daemon");

        var app = new Application ();
        return app.run (args);
    }
}
